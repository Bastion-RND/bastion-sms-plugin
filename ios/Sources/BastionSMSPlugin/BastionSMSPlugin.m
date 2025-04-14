#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// THIS IS WHAT MAKES CAPACITOR RECOGNIZE YOUR PLUGIN
CAP_PLUGIN(BastionSMSPlugin, "BastionSMSPlugin",
    CAP_PLUGIN_METHOD(sendSMS, CAPPluginReturnPromise);
)
