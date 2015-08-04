//
//  SplashPage.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 28/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "SplashPage.h"

@interface SplashPage ()

@end

@implementation SplashPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *animationImages = [@[] mutableCopy];
    
    for (NSInteger i = 0 ; i <= 28 ; i++){
        NSString *imgName = [NSString stringWithFormat:@"splash_%ld.png", (long)i];
        
        UIImage *img = [UIImage imageNamed:imgName];
        [animationImages addObject:img];
    }
    
    splashImg.animationImages = animationImages;
    splashImg.animationDuration = 1.5f;
    splashImg.animationRepeatCount = 1;
    [splashImg startAnimating];
    
    [self performSelector:@selector(animationDone) withObject:nil afterDelay:2.5f];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)assignParent:(ViewController *)parent{
    myParentViewController = parent;
}

-(void)animationDone{
    
    [myParentViewController navMoneyInputGo];
    
}


@end
