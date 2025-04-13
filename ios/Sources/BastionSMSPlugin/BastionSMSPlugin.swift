import Foundation
import Capacitor
import MessageUI

@objc(BastionSMSPlugin)
public class BastionSMSPlugin: CAPPlugin, MFMessageComposeViewControllerDelegate {
    private var call: CAPPluginCall?

    @objc func sendSMS(_ call: CAPPluginCall) {
        self.call = call

        guard MFMessageComposeViewController.canSendText() else {
            call.reject("SMS not available on this device")
            return
        }

        guard let phoneNumber = call.getString("phoneNumber"),
              let message = call.getString("message") else {
            call.reject("Both phoneNumber and message are required")
            return
        }

        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.recipients = [phoneNumber]
        composeVC.body = message

        DispatchQueue.main.async { [weak self] in
            self?.bridge?.viewController?.present(composeVC, animated: true)
        }
    }

    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true) { [weak self] in
            var resultData = JSObject()
            switch result {
            case .sent:
                resultData["status"] = "SENT"
            case .failed:
                resultData["status"] = "FAILED"
            case .cancelled:
                resultData["status"] = "CANCELLED"
            @unknown default:
                resultData["status"] = "UNKNOWN"
            }
            self?.call?.resolve(resultData)
        }
    }
}
