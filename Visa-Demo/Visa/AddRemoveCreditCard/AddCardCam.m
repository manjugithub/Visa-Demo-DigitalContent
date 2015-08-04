//
//  AddCardCam.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 15/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "AddCardCam.h"
#import "UniversalData.h"

@interface AddCardCam ()

@end

@implementation AddCardCam

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    overlayView.hidden = YES;
    
    if (![CardIOView canReadCardWithCamera]) {
        // Hide your "Scan Card" button, or take other appropriate action...
        NSLog(@"NOT ABLE TO SCAN CARD");
    }

    /*
    cameraPicker = [[UIImagePickerController alloc] init];
    cameraPicker.delegate = self;
    cameraPicker.allowsEditing = YES;
    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraPicker.showsCameraControls = NO;
    cameraPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    cameraPicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    
    [scannerView addSubview:cameraPicker.view];
    */
    
    [self performSelector:@selector(cardIOSetup) withObject:nil afterDelay:0.2f];
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    // Return YES for supported orientations
    return NO;
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


-(void)cardIOSetup{
    CardIOView *cardIOView = [[CardIOView alloc] initWithFrame:scannerView.frame];
    cardIOView.useCardIOLogo = YES;
    cardIOView.allowFreelyRotatingCardGuide = NO;
    cardIOView.delegate = self;
    
    [scannerView addSubview:cardIOView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CardIOView preload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)assignParent:(ViewController *)parent{
    myParentViewController = parent;
}

-(void)clearAll{
    myParentViewController = nil;
}

-(void)activate{
    
}

-(void)deactivate{
    
}

-(void)cardScannedDone{
    
    [myParentViewController navAddCardBack];
}


-(IBAction)pressCancel:(id)sender{
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSDictionary *cardInfo = @{@"cardNumber":@"", @"cardName":@"", @"expiryDate":@"", @"CVV":@""};
    [uData populateCapturedCardInfo:cardInfo];
    
    [cameraPicker.view removeFromSuperview];
    cameraPicker = nil;
    [myParentViewController navAddCardBack];
}



- (void)cardIOView:(CardIOView *)cardIOView didScanCard:(CardIOCreditCardInfo *)info {
    if (info) {
        NSLog(@"info : %@",info.cardNumber);
        // The full card number is available as info.cardNumber, but don't log that!
        
        
        //NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
        // Use the card info...
        UniversalData *uData = [UniversalData sharedUniversalData];
        NSDictionary *cardInfo = @{@"cardNumber":info.cardNumber, @"cardName":@"", @"expiryDate":@"", @"CVV":@""};
        [uData populateCapturedCardInfo:cardInfo];
        
        [cardIOView removeFromSuperview];
        [self cardScannedDone];
        
    }
    else {
        NSLog(@"User cancelled payment info");
        // Handle user cancellation here...
    }
    
    
}



@end
