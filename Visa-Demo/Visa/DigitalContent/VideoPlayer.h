//
//  VideoPlayer.h
//  Fastacash
//
//  Created by Accion on 09/07/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface VideoPlayer : UIViewController
@property (nonatomic, retain) NSURL *movieURL;
@property (nonatomic, retain) MPMoviePlayerController *movieController;

@end
