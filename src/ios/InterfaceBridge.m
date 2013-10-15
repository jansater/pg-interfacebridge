//
//  InterfaceBridge.m
//  IdrottOnline
//
//  Created by Mac Symbio on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InterfaceBridge.h"
#import "TransparentToolbar.h"
#import "UIBarButtonItem+UIBarButtonCategory.h"
#import "LoaderViewController.h"

@implementation InterfaceBridge

UIBarButtonItem *menuLeftItem;
UIBarButtonItem *menuCenterItem;
UIBarButtonItem *menuRightItem;

UIBarButtonItem *bottomMenuLeftItem;
UIBarButtonItem *bottomMenuCenterItem;
UIBarButtonItem *bottomMenuCenterItem2;
UIBarButtonItem *bottomMenuRightItem;

//LoadingViewController *_loadingController;

LoaderViewController *loaderView;
UIWindow *_window;

UILabel *orgLabel;
UILabel *teamLabel;

UIToolbar *menu;
UIToolbar *footer;
UIImageView *imgView;

double defaultWebViewHeight = 0;
bool showAds = false;
bool showHeaders = true;
bool showFooters = true;
bool showKeyboard = false;
double keyboardHeight = 0;
double menuHeight = 60;
double footerHeight = 60;

- (id)initWithWindow:(UIWindow *)window andController:(UIViewController *)controller
{
    _controller = controller;
    _window = window;
    loaderView = [[LoaderViewController alloc] init];
    //_loadingController = [[LoadingViewController alloc] init];
    //_loadingController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageReceived:) name:@"MessageAdded" object:nil];
    defaultWebViewHeight = controller.view.frame.size.height;
    controller.view.autoresizesSubviews = YES;
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self createMenu];
    [self createFooter];
    
    [menu setBackgroundColor:[UIColor colorWithRed:40.0/255 green:53.0/255 blue:79.0/255 alpha:1]];
    [footer setBackgroundColor:[UIColor colorWithRed:40.0/255 green:53.0/255 blue:79.0/255 alpha:1]];
    
    [self updateUI: (UIWebView*)controller.view showHeader:true showFooter:true];
    return self;
}

- (void) updateUI: (UIWebView *) view showHeader: (bool) showHeader showFooter: (bool) showFooter {
    showHeaders = showHeader;
    showFooters = showFooter;
    double y = 20;
    double height = defaultWebViewHeight;

    if (showHeader) {
        y += menuHeight;
        height -= menuHeight;
    }

    if (showFooter) {
        if (!showKeyboard) {
            height -= footerHeight; 
        }
        else {
            height -= footerHeight; 
        }
    
    }
    else if (showFooter) {
        height -= footerHeight;
    }
    
    if (showKeyboard) {
        height -= keyboardHeight;
    }

    [view setFrame:CGRectMake(
                          0.0,
                          y,
                          view.frame.size.width,
                          height)];
    
}

- (void) createMenu {
       
    UIBarButtonItem *space = [[UIBarButtonItem alloc] 
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIImage *navBarBg = [UIImage imageNamed:@"navbar.png"];
    menuHeight = navBarBg.size.height;
    menu = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 20,
                                                       _controller.view.frame.size.width,
                                                       menuHeight)];
    
    if([[[UIDevice currentDevice] systemVersion] intValue] >= 5) {
        
        [[UIToolbar appearance] setBackgroundImage:navBarBg forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    else {
        [menu insertSubview:[[UIImageView alloc] initWithImage:navBarBg] atIndex:0];
    }
    
    UIImage *imgMenuLeft = [UIImage imageNamed:@"_cog.png"];
    imgView = [[UIImageView alloc] initWithImage:imgMenuLeft];
    [imgView setFrame:CGRectMake(0, (menuHeight / 2 - 10),20,20)];
    /*menuLeftItem = [[UIBarButtonItem alloc] initWithImage:imgMenuLeft style:UIBarButtonItemStylePlain target:self action:@selector(onLeftMenuClick:)];*/   
    
    UIControl *customView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 260, 40)];
    
    orgLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 2, 200, 20)];
    [orgLabel setBackgroundColor:[UIColor clearColor]];
    [orgLabel setOpaque:NO];
    [orgLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [orgLabel setTextColor:[UIColor whiteColor]];
    [orgLabel setText:@"Ingen grupp vald"];
    [orgLabel setLineBreakMode:NSLineBreakByTruncatingHead];
    
    teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 16, 200, 20)];
    [teamLabel setBackgroundColor:[UIColor clearColor]];
    [teamLabel setOpaque:NO];
    [teamLabel setFont:[UIFont systemFontOfSize:12]];
    [teamLabel setTextColor:[UIColor whiteColor]];
    [teamLabel setText:@"Klicka här för att ändra"];
    
    [customView addSubview:imgView];
    [customView addSubview:orgLabel];
    [customView addSubview:teamLabel]; 
    
    menuLeftItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    [customView addTarget:self action:@selector(onLeftMenuClick:) forControlEvents:UIControlEventAllEvents];
    
    //UIImage *imgMenuCenter = [UIImage imageNamed:@"qf_icon_topbar_pl.png"];
    //menuCenterItem = [[UIBarButtonItem alloc] initWithImage:imgMenuCenter style:UIBarButtonItemStylePlain target:self action:@selector(onCenterMenuClick:)];    
    //[menuCenterItem setButtonImage:imgMenuCenter];
    
    UIImage *imgMenuRight = [UIImage imageNamed:@"_man.png"];
    menuRightItem = [[UIBarButtonItem alloc] initWithImage:imgMenuRight style:UIBarButtonItemStylePlain target:self action:@selector(onRightMenuClick:)];
    
    NSArray *menuItems = [NSArray arrayWithObjects: menuLeftItem, space, space, space, space,space, menuRightItem, nil];
    [menu setItems:menuItems animated:NO];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [menu setTintColor:[UIColor whiteColor]];
    }
    
    //[_controller.view addSubview:menu];
    [_window addSubview:menu];
}

- (void) createFooter {
    UIBarButtonItem *space = [[UIBarButtonItem alloc] 
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIImage *footerBg = [UIImage imageNamed:@"footerbar.png"];
    
    footerHeight = footerBg.size.height;
    
    footer = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, _window.frame.size.height - footerHeight,
                                                                  _window.frame.size.width,
                                                                  footerHeight)];
    
    if([[[UIDevice currentDevice] systemVersion] intValue] >= 5) {
        [footer setBackgroundImage:footerBg forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        
    }
    else {
        [footer insertSubview:[[UIImageView alloc] initWithImage:footerBg] atIndex:0];
    }
    
    
    UIImage *imgMenuLeft = [UIImage imageNamed:@"flag.png"];
    bottomMenuLeftItem = [[UIBarButtonItem alloc] initWithImage:imgMenuLeft style:UIBarButtonItemStylePlain target:self action:@selector(onBottomLeftMenuClick:)];    
    
    
    UIImage *imgMenuCenter = [UIImage imageNamed:@"_comment2.png"];
    bottomMenuCenterItem = [[UIBarButtonItem alloc] initWithImage:imgMenuCenter style:UIBarButtonItemStylePlain target:self action:@selector(onBottomCenterMenuClick:)];
    
    UIImage *imgMenuCenter2 = [UIImage imageNamed:@"_group.png"];
    bottomMenuCenterItem2 = [[UIBarButtonItem alloc] initWithImage:imgMenuCenter2 style:UIBarButtonItemStylePlain target:self action:@selector(onBottomCenter2MenuClick:)];
    
    UIImage *imgMenuRight = [UIImage imageNamed:@"_list.png"];
    bottomMenuRightItem = [[UIBarButtonItem alloc] initWithImage:imgMenuRight style:UIBarButtonItemStylePlain target:self action:@selector(onBottomRightMenuClick:)];
    
    NSArray *menuItems = [NSArray arrayWithObjects: bottomMenuLeftItem, space, space, bottomMenuCenterItem, space,space, bottomMenuCenterItem2 ,space,space, bottomMenuRightItem, nil];
    [footer setItems:menuItems animated:NO];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [footer setTintColor:[UIColor whiteColor]];
    }
    
    //[_controller.view addSubview:menu];
    [_window addSubview:footer];

}

-(void)onLeftMenuClick:(UIBarButtonItem*) item {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"LeftMenuButton" forKey:@"element"];
    [dict setValue:@"LeftMenuButton" forKey:@"Action"];
    [dict setValue:@"YES" forKey:@"keepCallback"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceCallback" object:self userInfo:dict];
}

-(void)onCenterMenuClick:(UIBarButtonItem*) item {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"CenterMenuButton" forKey:@"element"];
    [dict setValue:@"CenterMenuButton" forKey:@"Action"];
    [dict setValue:@"YES" forKey:@"keepCallback"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceCallback" object:self userInfo:dict];
}

-(void)onRightMenuClick:(UIBarButtonItem*) item {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"RightMenuButton" forKey:@"element"];
    [dict setValue:@"RightMenuButton" forKey:@"Action"];
    [dict setValue:@"YES" forKey:@"keepCallback"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceCallback" object:self userInfo:dict];
}

-(void)onBottomLeftMenuClick:(UIBarButtonItem*) item {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"BottomLeftMenuButton" forKey:@"element"];
    [dict setValue:@"BottomLeftMenuButton" forKey:@"Action"];
    [dict setValue:@"YES" forKey:@"keepCallback"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceCallback" object:self userInfo:dict];
}

-(void)onBottomCenterMenuClick:(UIBarButtonItem*) item {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"BottomCenterMenuButton" forKey:@"element"];
    [dict setValue:@"BottomCenterMenuButton" forKey:@"Action"];
    [dict setValue:@"YES" forKey:@"keepCallback"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceCallback" object:self userInfo:dict];
}

-(void)onBottomCenter2MenuClick:(UIBarButtonItem*) item {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"BottomCenter2MenuButton" forKey:@"element"];
    [dict setValue:@"BottomCenter2MenuButton" forKey:@"Action"];
    [dict setValue:@"YES" forKey:@"keepCallback"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceCallback" object:self userInfo:dict];
}

-(void)onBottomRightMenuClick:(UIBarButtonItem*) item {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"BottomRightMenuButton" forKey:@"element"];
    [dict setValue:@"BottomRightMenuButton" forKey:@"Action"];
    [dict setValue:@"YES" forKey:@"keepCallback"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceCallback" object:self userInfo:dict];
}


- (void) onMessageReceived:(NSNotification *) notification
{
    NSDictionary *dict = [notification userInfo];
    NSString *element = [dict valueForKey:@"Element"];
    NSString *action = [dict valueForKey:@"Action"];
    
    
    if ([element isEqualToString:@"Menu"]) {
        if ([action isEqualToString:@"Hide"]) {
            [menu removeFromSuperview];
            showHeaders = false;
            [self updateUI:(UIWebView *)_controller.view showHeader:showHeaders showFooter:showFooters];
        }
        else if ([action isEqualToString:@"Show"]) {
            [_window insertSubview:menu atIndex:0];
            showHeaders = true;
            [self updateUI:(UIWebView *)_controller.view showHeader:showHeaders showFooter:showFooters];
        }
    }
    else if ([element isEqualToString:@"Footer"]) {
        if ([action isEqualToString:@"Hide"]) {
            [footer removeFromSuperview];
            showFooters = false;
            [self updateUI:(UIWebView *)_controller.view showHeader:showHeaders showFooter:showFooters];
        }
        else if ([action isEqualToString:@"Show"]) {
            [_window addSubview:footer];
            showFooters = true;
            [self updateUI:(UIWebView *)_controller.view showHeader:showHeaders showFooter:showFooters];
        }
    }
    else if ([element isEqualToString:@"LeftMenuButton"]) {
        
        
        //[self updateUI:self.viewController.webView, true, showFooters];
        [menu setHidden:NO];
        if ([action isEqualToString:@"Hide"]) {
            [menuLeftItem setEnabled:NO];
            //[menuLeftButton setAlpha:0];
        }
        else if ([action isEqualToString:@"Show"]) {
            [menuLeftItem setEnabled:YES];
            //[menuLeftButton setAlpha:1];
            NSString* text = [dict valueForKey:@"Text"];
            
            //this one can be json with Org and Team
            if (text != Nil && [text isEqualToString:@"./images/cancel.png"]) {
                //switch icon
                [imgView setImage:[UIImage imageNamed:@"cancel.png"]];
                [orgLabel setHidden:YES];
                [teamLabel setHidden:YES];
            }
            else {
                //do we have json in the text
                if  ([text length] > 0 && [text characterAtIndex:0] == '{') {
                    
                    NSError* error;
                    NSData *jsonData = [text dataUsingEncoding:NSUTF8StringEncoding];
                    id jsonObject = [NSJSONSerialization 
                                          JSONObjectWithData:jsonData
                                          options:NSJSONReadingAllowFragments 
                                          error:&error];
                    if ([jsonObject respondsToSelector:@selector(objectForKey:)]) 
                    {
                        NSString *org = [jsonObject objectForKey:@"org"];
                        NSString *team = [jsonObject objectForKey:@"team"];
                        
                        if (org != nil && team != nil && [team length] > 0) {
                            [orgLabel setText: [org stringByAppendingFormat:@" - %@", team]];
                        }
                        else if (org != nil) {
                            [orgLabel setText: [org stringByAppendingFormat:@" - Ingen grupp vald"]];
                        }
                        else {
                            [orgLabel setText: @"Ingen grupp vald"];
                        }
                        [orgLabel setHidden:NO];
                        [teamLabel setHidden:NO];
                        
                    }
                    else {
                        [orgLabel setText: @"Ingen grupp vald"];
                        [orgLabel setHidden:NO];
                    }
                }
                else {
                    [orgLabel setText: @"Ingen grupp vald"];
                    [orgLabel setHidden:NO];
                }
                [imgView setImage:[UIImage imageNamed:@"_cog.png"]];
            }
        }
        
    }
    else if ([element isEqualToString:@"CenterMenuButton"]) {
        
       
        //[self updateUI:self.viewController.webView, true, showFooters];
        [menu setHidden:NO];
        if ([action isEqualToString:@"Hide"]) {
            [menuCenterItem setEnabled:NO];
            //[menuCenterButton setAlpha:0];
        }
        else if ([action isEqualToString:@"Show"]) {
            [menuCenterItem setEnabled:YES];
            //[menuCenterButton setAlpha:1];
            NSString* text = [dict valueForKey:@"Text"];
            if (text != Nil && [text isEqualToString:@"red"]) {
                //switch icon
                //[menuCenterItem setImage:[UIImage imageNamed:@"qf_icon_topbarRed_pl.png"]];
            }
            else {
                //switch icon
                //[menuCenterItem setImage:[UIImage imageNamed:@"qf_icon_topbar_pl.png"]];
            }
            
        }
    }
    else if ([element isEqualToString:@"BottomLeftMenuButton"]) {
        if ([action isEqualToString:@"Hide"]) {
            [bottomMenuLeftItem setEnabled:NO];
        }
        else if ([action isEqualToString:@"Show"]) {
            [bottomMenuLeftItem setEnabled:YES];
        }
    }
    else if ([element isEqualToString:@"BottomCenterMenuButton"]) {
        if ([action isEqualToString:@"Hide"]) {
            [bottomMenuCenterItem setEnabled:NO];
        }
        else if ([action isEqualToString:@"Show"]) {
            [bottomMenuCenterItem setEnabled:YES];
        }
    }
    else if ([element isEqualToString:@"BottomCenter2MenuButton"]) {
        if ([action isEqualToString:@"Hide"]) {
            [bottomMenuCenterItem2 setEnabled:NO];
        }
        else if ([action isEqualToString:@"Show"]) {
            [bottomMenuCenterItem2 setEnabled:YES];
        }
    }
    else if ([element isEqualToString:@"BottomRightMenuButton"]) {
        if ([action isEqualToString:@"Hide"]) {
            [bottomMenuRightItem setEnabled:NO];
        }
        else if ([action isEqualToString:@"Show"]) {
            [bottomMenuRightItem setEnabled:YES];
        }
    }
    else if ([element isEqualToString:@"RightMenuButton"]) {
             //  [self updateUI:self.viewController.webView, true, showFooters];
        [menu setHidden:NO];
        if ([action isEqualToString:@"Hide"]) {
            [menuRightItem setEnabled:NO];
            [menuRightItem setImage:nil];
            //[menuRightButton setAlpha:0];
        }
        else if ([action isEqualToString:@"Show"]) {
            [menuRightItem setImage:[UIImage imageNamed:@"_man.png"]];
            [menuRightItem setEnabled:YES];
            
            //[menuRightButton setAlpha:1];
            NSString* text = [dict valueForKey:@"Text"];
            NSLog(@"Text: %@", text);
            if (text != Nil && [text isEqualToString:@"refresh"]) {
                //switch icon
                NSLog(@"Changing to refresh icon");
                //[menuRightItem setImage:[UIImage imageNamed:@"refresh.png"]];
            }
            else {
                //switch icon
                //[menuRightItem setImage:[UIImage imageNamed:@"lines.png"]];
            }
            
            
        }
    }
    else if ([element isEqualToString:@"Message"]) {
        NSString* text = [dict valueForKey:@"Text"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:text
														message:nil
													   delegate:nil
                                              cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
    }
    else if ([element isEqualToString:@"OFFLINE"]) {
        [menuRightItem setTintColor:[UIColor redColor]];
    }
    else if ([element isEqualToString:@"ONLINE"]) {
        [menuRightItem setTintColor:[UIColor whiteColor]];
    }
    else if ([element isEqualToString:@"AppVersion"]) {
        NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        NSString *txt = [[NSString alloc] initWithFormat: @"%s", __DATE__];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *loc = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale: loc];
        
        [dateFormatter setDateFormat:@"MMM dd yyyy"];
        NSDate *date = [dateFormatter dateFromString:txt];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue: [NSString stringWithFormat:@"Version: %@ (%@)", version, [dateFormatter stringFromDate:date]] forKey:@"element"];
        [dict setValue:@"AppVersion" forKey:@"Action"];
        
        [dict setValue:@"YES" forKey:@"keepCallback"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceCallback" object:self userInfo:dict];
        
    }
    else if ([element isEqualToString:@"Loading"]) {
        NSString* text = [dict valueForKey:@"Text"];
        if ([action isEqualToString:@"Hide"]) {
            [loaderView hide];
            
        }
        else if ([action isEqualToString:@"Show"]) {
            [loaderView show:_window withText:text];
        }
    }

    /*else if ([element isEqualToString:@"Loading"]) {
        
        if ([action isEqualToString:@"Hide"]) {
            [_loadingController.view removeFromSuperview];
        }
        else if ([action isEqualToString:@"Show"]) {
            [_window addSubview:_loadingController.view];
            //[_controller.view addSubview:_loadingController.view];
        }
    }*/
    
}



@end
