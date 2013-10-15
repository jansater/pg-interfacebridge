/*
 Copyright 2009-2011 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "InterfaceBridgePlugin.h"
#import "ApplicationMessage.h"
#import <Cordova/CDVJSON.h>


@implementation InterfaceBridgePlugin 

NSMutableDictionary *_callbackTable;

- (void)dealloc {
    NSLog(@"deallocating");
    [_callbackTable removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) onMessageReceived:(NSNotification *) notification
{
    NSDictionary *dict = [notification userInfo];
    NSString *element = [dict valueForKey:@"Action"];
    BOOL shouldKeepCallback = false;
    if ([[dict allKeys] containsObject:@"keepCallback"]) {
        shouldKeepCallback = YES; //not checking the actual value
    }
    if ([[_callbackTable allKeys] containsObject:element]) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary:dict];
        if (shouldKeepCallback) {
            [pluginResult setKeepCallbackAsBool:YES];
        }
        else {
            [_callbackTable removeObjectForKey:element];
            [pluginResult setKeepCallbackAsBool:NO];
        }
        
        NSString* callback = [pluginResult toSuccessCallbackString:[_callbackTable valueForKey:element]];
        NSLog(@"callback: %@", callback);
        [super writeJavascript:[NSString stringWithFormat:@"setTimeout(function() { %@; }, 0);", callback]];
    }
    else {
        NSLog(@"No key in callback table %@", element);
    }

}

- (CDVPlugin*) initWithWebView:(UIWebView*)theWebView
{
    NSLog(@"initing");
    self = (InterfaceBridgePlugin*)[super initWithWebView:theWebView];
    if (self) {
        _callbackTable = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageReceived:) name:@"InterfaceCallback" object:nil];
    }
    return self;
}

- (void)Show:(CDVInvokedUrlCommand*)command {
    
    id options = [command.arguments objectAtIndex:0];

    
    NSString* callbackId = command.callbackId;
    NSString* element = [options objectForKey: @"element"];
    NSString* text = [options objectForKey: @"text"];
    //NSString* keepOpen = [options objectForKey: @"keepOpen"];
    //NSLog(@"showing: %@", element);
    if (callbackId != nil) {
        [_callbackTable setValue:callbackId forKey:element];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"Show" forKey:@"Action"];
    [dict setValue:element forKey:@"Element"];
    [dict setValue:callbackId forKey:@"CallbackId"];
    [dict setValue:text forKey:@"Text"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageAdded" object:self userInfo:dict];
    
    //NSMutableDictionary *results = [NSMutableDictionary dictionary];
    //PluginResult* pluginResult = [PluginResult resultWithStatus: PGCommandStatus_NO_RESULT messageAsDictionary:results];
    //if (keepOpen == @"true") {
    //    [pluginResult setKeepCallbackAsBool:YES];
   // }
    
    //[self writeJavascript:[pluginResult toSuccessCallbackString:callbackId]];
    
}

- (void)Disable:(CDVInvokedUrlCommand*)command {
        
    id options = [command.arguments objectAtIndex:0];
    
    NSLog(@"interface disable:%@\n withDict:%@", [arguments description], [options description]);
    NSString* callbackId = command.callbackId;
    NSString* element = [options objectForKey: @"element"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"Disable" forKey:@"Action"];
    [dict setValue:element forKey:@"Element"];
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageAdded" object:self userInfo:dict];
    
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary:results];
    [self writeJavascript:[pluginResult toSuccessCallbackString:callbackId]];
    
}

- (void)Hide:(CDVInvokedUrlCommand*)command {
    
    id options = [command.arguments objectAtIndex:0];
    
    NSString* callbackId = command.callbackId;
    NSString* element = [options objectForKey: @"element"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"Hide" forKey:@"Action"];
    [dict setValue:element forKey:@"Element"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageAdded" object:self userInfo:dict];
    
    
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_NO_RESULT messageAsDictionary:results];
    [self writeJavascript:[pluginResult toSuccessCallbackString:callbackId]];
    
}

@end
