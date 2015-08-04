//
//  AppDelegate.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

#import "FCHTTPClient.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,FCHTTPClientDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *datasourceArray;


@end

