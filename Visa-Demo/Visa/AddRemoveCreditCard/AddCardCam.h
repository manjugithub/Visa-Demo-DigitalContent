//
//  AddCardCam.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 15/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "CardIO.h"


@class ViewController;

@interface AddCardCam : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CardIOViewDelegate>{
    ViewController *myParentViewController;
    
    IBOutlet UIView *__weak scannerView;
    IBOutlet UIView *__weak overlayView;
    IBOutlet UIImageView *__weak overlayFrameImg;
    IBOutlet UIView *__weak topView;
    IBOutlet UIView *__weak bottomView;
    IBOutlet UIButton *__weak cancelBtn;
    
    UIImagePickerController *cameraPicker;
    
    
}

-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressCancel:(id)sender;

@end
