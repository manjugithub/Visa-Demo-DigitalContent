//
//  VideoImageCell.h
//  Fastacash
//
//  Created by Accion on 08/07/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DigitalContentCreationVC.h"
#import "TGCDownloadProgressIndicator.h"
#import "AFDownloadRequestOperation.h"
@interface VideoImageCell : UITableViewCell<FCHTTPClientProgress,TGCDownloadProgressIndicatorCallback,FCHTTPClientDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;
@property (weak, nonatomic) IBOutlet UIButton *playButton,*closeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sideImageView,*profileImageView;
@property (nonatomic, retain) MPMoviePlayerController *movieController;
@property (nonatomic, weak) id ParentVC;
@property (nonatomic, weak) NSMutableDictionary *selectedDict;

@property (nonatomic, weak) IBOutlet TGCDownloadProgressIndicator *downloadIndicator;
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;
@property (nonatomic,weak) AFHTTPRequestOperation *uploadDataRequest;
@property (nonatomic,assign) BOOL isDownloading;



@property (nonatomic, strong) NSString *mediaURL,*mediaID;
@property (nonatomic, strong) NSDate *lastProgressUpdateTime;
@property (nonatomic, assign) float progressValue;
@property (nonatomic, assign) id  progressDelegate;
@property (nonatomic, strong) NSNumber *fileSize;
@property (nonatomic, weak) AFDownloadRequestOperation *downloadOp;
@property (nonatomic, assign) int downloadRequestCount;

- (IBAction)playMedia:(id)sender;
- (IBAction)closeDigitalCell:(id)sender;
-(void)setDatasource:(NSMutableDictionary *)inDataDict;
-(void)cancelUploading;
-(void)setFinalDatasource:(NSMutableDictionary *)inDataDict;
-(void)downloadMedia:(NSMutableDictionary *)inDataDict;
-(void)getVideoLink:(NSMutableDictionary *)inDataDict;
@end
