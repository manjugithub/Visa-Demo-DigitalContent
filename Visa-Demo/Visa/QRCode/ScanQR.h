//
//  ScanQR.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
# import "ZBarSDK.h"
#import "QRCodeMenu.h"

@class QRCodeMenu;

@interface ScanQR : UIViewController <ZBarReaderViewDelegate>{
    QRCodeMenu *myParentViewController;
    
    IBOutlet UIImageView *__weak scanFrameImg;
    IBOutlet UIView *__weak scanDoneView;
    IBOutlet UILabel *__weak scanDoneTitleLabel;
    
    IBOutlet UIView *__weak bottomView;
    NSString *capturedQRCode;
    
}
@property (nonatomic, retain) IBOutlet ZBarReaderView *readerView;

-(void)assignParent:(QRCodeMenu *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;


@end
