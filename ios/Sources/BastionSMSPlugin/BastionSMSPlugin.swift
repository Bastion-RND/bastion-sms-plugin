import Foundation
import Capacitor
import MessageUI

@objc(BastionSMSPlugin)
public class BastionSMSPlugin: CAPPlugin, MFMessageComposeViewControllerDelegate {
    private var call: CAPPluginCall?
    private weak var currentComposeVC: MFMessageComposeViewController?

    @objc func sendSMS(_ call: CAPPluginCall) {
        self.call = call

        guard MFMessageComposeViewController.canSendText() else {
            call.reject("SMS not available on this device")
            return
        }

        guard let phoneNumber = call.getString("phoneNumber")?.trimmingCharacters(in: .whitespaces),
              !phoneNumber.isEmpty,
              let message = call.getString("message"),
              !message.isEmpty else {
            call.reject("Valid phoneNumber and message are required")
            return
        }

        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.recipients = [phoneNumber]
        composeVC.body = message
        self.currentComposeVC = composeVC

        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let bridgeVC = self.bridge?.viewController else {
                call.reject("Presentation failed")
                return
            }

            bridgeVC.present(composeVC, animated: true)
        }
    }

    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true) { [weak self] in
            guard let self = self, let call = self.call else { return }

            // Changed to var to make it mutable
            var resultData = JSObject()

            switch result {
            case .sent:
                resultData["status"] = "SENT"
                resultData["deliveryStatus"] = "UNKNOWN" // iOS doesn't provide delivery confirmation
            case .failed:
                resultData["status"] = "FAILED"
                resultData["deliveryStatus"] = "FAILED"
            case .cancelled:
                resultData["status"] = "CANCELLED"
                resultData["deliveryStatus"] = "CANCELLED"
            @unknown default:
                resultData["status"] = "UNKNOWN"
                resultData["deliveryStatus"] = "UNKNOWN"
            }

            call.resolve(resultData)
            self.currentComposeVC = nil
            self.call = nil
        }
    }
}
