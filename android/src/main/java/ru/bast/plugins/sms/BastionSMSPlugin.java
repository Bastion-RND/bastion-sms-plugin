package ru.bast.skatpoe;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;
import androidx.core.content.ContextCompat;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "BastionSMSPlugin")
public class BastionSMSPlugin extends Plugin {

    private static final int SMS_REQUEST_CODE = 12345;
    private PluginCall savedCall;

    @PluginMethod
    public void sendSMS(PluginCall call) {
        String phoneNumber = call.getString("phoneNumber");
        String message = call.getString("message");

        if (phoneNumber == null || message == null) {
            call.reject("Phone number and message are required");
            return;
        }

        // Check if device has SIM card and is ready
        if (!hasSimCard()) {
            call.reject("NOSIM");
            return;
        }

        savedCall = call; // Save call for later response

        try {
            SmsManager smsManager = SmsManager.getDefault();

            PendingIntent sentIntent = PendingIntent.getBroadcast(
                getContext(),
                SMS_REQUEST_CODE,
                new Intent("SMS_SENT"),
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
            );

            PendingIntent deliveryIntent = PendingIntent.getBroadcast(
                getContext(),
                SMS_REQUEST_CODE,
                new Intent("SMS_DELIVERED"),
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
            );

            // Register dynamic BroadcastReceiver
            IntentFilter sentFilter = new IntentFilter("SMS_SENT");
            IntentFilter deliveredFilter = new IntentFilter("SMS_DELIVERED");

            ContextCompat.registerReceiver(
                getContext(),
                new BroadcastReceiver() {
                    @Override
                    public void onReceive(Context context, Intent intent) {
                        JSObject result = new JSObject();

                        if ("SMS_SENT".equals(intent.getAction())) {
                            switch (getResultCode()) {
                                case Activity.RESULT_OK:
                                    result.put("sentStatus", "SENT");
                                    break;
                                default:
                                    result.put("sentStatus", "FAILED");
                                    break;
                            }
                        }
                    }
                },
                sentFilter,
                ContextCompat.RECEIVER_EXPORTED
            );
            ContextCompat.registerReceiver(
                getContext(),
                new BroadcastReceiver() {
                    @Override
                    public void onReceive(Context context, Intent intent) {
                        JSObject result = new JSObject();
                        if ("SMS_DELIVERED".equals(intent.getAction())) {
                            switch (getResultCode()) {
                                case Activity.RESULT_OK:
                                    result.put("deliveryStatus", "DELIVERED");
                                    savedCall.resolve(result); // Send final result
                                    getContext().unregisterReceiver(this); // Unregister
                                    break;
                                default:
                                    result.put("deliveryStatus", "FAILED");
                                    savedCall.resolve(result);
                                    getContext().unregisterReceiver(this);
                                    break;
                            }
                        }
                    }
                },
                deliveredFilter,
                ContextCompat.RECEIVER_EXPORTED
            );

            smsManager.sendTextMessage(phoneNumber, null, message, sentIntent, deliveryIntent);
        } catch (Exception e) {
            call.reject("SMS sending failed", e);
        }
    }

    private boolean hasSimCard() {
        TelephonyManager telephonyManager = (TelephonyManager) getContext().getSystemService(Context.TELEPHONY_SERVICE);
        if (telephonyManager == null) {
            return false;
        }

        // Check if device has a SIM card inserted
        int simState = telephonyManager.getSimState();
        return simState != TelephonyManager.SIM_STATE_ABSENT
               && simState != TelephonyManager.SIM_STATE_UNKNOWN;
    }
}
