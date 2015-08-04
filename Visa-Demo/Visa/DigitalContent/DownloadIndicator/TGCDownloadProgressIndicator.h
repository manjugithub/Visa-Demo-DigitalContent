//
//  TGCDownloadProgressIndicator.h
//  PerfectWellness
//
//  Created by Apple on 14/05/15.
//
//

#import <UIKit/UIKit.h>

@protocol TGCDownloadProgressIndicatorCallback;

typedef enum downloadState
{
    eDownloadStart = 0,
    eDownloadStarted,
    eDownloadPaused,
    eDownloadResumed,
    eDownloadFinished,
    eDownloadFailed
}
eDownloadState;


@interface TGCDownloadProgressIndicator : UIView
@property (nonatomic, strong) UIBezierPath *path0,*path1,*path2,*path3,*path4;
@property (nonatomic,strong) IBOutlet UIButton *downloadButton;
@property (nonatomic,strong) IBOutlet UIImageView *downloadImgView,*progressImgView;
@property (nonatomic, assign) float progressValue;
@property (nonatomic, assign) id<TGCDownloadProgressIndicatorCallback> delegate;
-(IBAction)actionButtonClicked:(id)sender;
-(void)updateProgress:(float)inProgress;
-(void)updateDownloadCompletedStatus;
-(void)updateDownloadStatus:(eDownloadState)inDownloadState;

@end





@protocol TGCDownloadProgressIndicatorCallback <NSObject>
@required
-(void)cancelUploading;
@end

