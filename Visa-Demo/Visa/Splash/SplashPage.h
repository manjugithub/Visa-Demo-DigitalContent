//
//  SplashPage.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 28/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@class ViewController;

@interface SplashPage : UIViewController {
    
    IBOutlet UIImageView *splashImg;
    
    ViewController *myParentViewController;
    
}

-(void)assignParent:(ViewController *)parent;

@end
