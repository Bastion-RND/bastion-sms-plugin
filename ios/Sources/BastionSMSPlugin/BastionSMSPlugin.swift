import Foundation
import Capacitor
import MessageUI
import CoreTelephony

@objc(BastionSMSPlugin)
public class BastionSMSPlugin: CAPPlugin, MFMessageComposeViewControllerDelegate {
    private var call: CAPPluginCall?
    private var currentComposeVC: MFMessageComposeViewController?

    @objc func sendSMS(_ call: CAPPluginCall) {
        self.call = call

        // Check for valid parameters
        guard let phoneNumber = call.getString("phoneNumber"),
              let message = call.getString("message") else {
            call.reject("Phone number and message are required")
            return
        }

        // Check for SIM card availability
        guard hasSimCard() else {
            call.reject("NOSIM")
            return
        }

        // Check if device can send texts
        guard MFMessageComposeViewController.canSendText() else {
            call.reject("SMS not available on this device")
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            composeVC.recipients = [phoneNumber]
            composeVC.body = message

            self.currentComposeVC = composeVC

            if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                rootVC.present(composeVC, animated: true)
            } else {
                call.reject("Could not present SMS composer")
            }
        }
    }

    // Handle SMS composition result
    public func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                           didFinishWith result: MessageComposeResult) {
        DispatchQueue.main.async { [weak self] in
            controller.dismiss(animated: true) {
                guard let self = self, let call = self.call else { return }

                var resultData = JSObject()

                switch result {
                case .sent:
                    resultData["sentStatus"] = "SENT"
                    // iOS doesn't provide delivery confirmation
                    resultData["deliveryStatus"] = "UNKNOWN"
                case .failed:
                    resultData["sentStatus"] = "FAILED"
                    resultData["deliveryStatus"] = "FAILED"
                case .cancelled:
                    resultData["sentStatus"] = "CANCELLED"
                    resultData["deliveryStatus"] = "CANCELLED"
                @unknown default:
                    resultData["sentStatus"] = "UNKNOWN"
                    resultData["deliveryStatus"] = "UNKNOWN"
                }

                call.resolve(resultData)
                self.currentComposeVC = nil
                self.call = nil
            }
        }
    }

    // Check for SIM card availability
    private func hasSimCard() -> Bool {
        let networkInfo = CTTelephonyNetworkInfo()
        guard let carriers = networkInfo.serviceSubscriberCellularProviders else {
            return false
        }

        // Check if any carrier has valid SIM
        return carriers.values.contains { carrier in
            carrier.mobileCountryCode != nil && carrier.mobileNetworkCode != nil
        }
    }
}
