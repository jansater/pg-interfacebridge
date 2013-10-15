//
//  InterfaceBridge.h
//  IdrottOnline
//
//  Created by Mac Symbio on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterfaceBridge : NSObject
{
    UIWindow *_window;
    UIViewController *_controller;
}

- (id) initWithWindow: (UIWindow *)window andController:(UIViewController *)controller;

@end
