//
//  TGCDownloadProgressIndicator.m
//  PerfectWellness
//
//  Created by Apple on 14/05/15.
//
//

#import "TGCDownloadProgressIndicator.h"



@implementation TGCDownloadProgressIndicator

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    float currentDownloadSize = self.progressValue * 100 == 0 ? 0.001 : self.progressValue * 100;
    float angle = currentDownloadSize * 3.6;
    
    float radius = self.frame.size.width /2.0;
    // Drawing code
    
    [[UIColor lightGrayColor] setFill];
    
    self.path0 =     [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:radius startAngle:0 endAngle:360 clockwise:YES];
    [self.path0 fill];
    [self.path0 closePath];
    
    
    [[UIColor colorWithRed:16.0/256.0 green:103.0/256.0 blue:245.0/256.0 alpha:1.0] setFill];
    
    self.path1 =     [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:radius-0.3 startAngle:0 endAngle:360 clockwise:YES];
    
    [self.path1 fill];
    [self.path1 closePath];
    
    [[UIColor lightGrayColor] setFill];
    
    
    self.path2 =     [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:radius-0.6 startAngle:-90*(M_PI/180) endAngle:(angle - 90)*(M_PI/180) clockwise:NO];
    
    [self.path2 addLineToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0)];
    [self.path2 fill];
    [self.path2 closePath];
    
    [[UIColor colorWithRed:16.0/256.0 green:103.0/256.0 blue:245.0/256.0 alpha:1.0] setFill];
    
    self.path3 =     [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:radius-4.8 startAngle:0 endAngle:360 clockwise:YES];
    
    [self.path3 fill];
    [self.path3 closePath];
    
    [[UIColor lightGrayColor] setFill];
    
    self.path4 =     [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:radius-5.0 startAngle:0 endAngle:360 clockwise:YES];
    
    [self.path4 fill];
    [self.path4 closePath];
    
}

-(IBAction)actionButtonClicked:(id)sender
{    
    [self.delegate cancelUploading];
}

-(void)updateProgress:(float)inProgress
{
    self.progressValue = inProgress;
    [self setNeedsDisplay];
}

-(void)updateDownloadCompletedStatus
{
    self.downloadButton.tag = eDownloadFinished;
    self.downloadButton.hidden = YES;
    [self setNeedsDisplay];
}


-(void)updateDownloadStatus:(eDownloadState)inDownloadState
{
    self.downloadButton.hidden = NO;
    
    self.downloadButton.tag = inDownloadState;
    switch (inDownloadState)
    {
        case eDownloadStart:
        {
            [self.downloadButton setImage:[UIImage imageNamed:@"download_cloud.png"] forState: UIControlStateNormal];
            break;
        }
        case eDownloadStarted:
        {
            [self.downloadButton setImage:[UIImage imageNamed:@"gb_pause.png"] forState: UIControlStateNormal];
            break;
        }
        case eDownloadPaused:
        {
            [self.downloadButton setImage:[UIImage imageNamed:@"gb_resume.png"] forState: UIControlStateNormal];
            break;
        }
        case eDownloadResumed:
        {
            [self.downloadButton setImage:[UIImage imageNamed:@"gb_pause.png"] forState: UIControlStateNormal];
            break;
        }
        case eDownloadFinished:
        {
            //self.downloadButton.hidden = YES;
            [self.downloadButton setImage:[UIImage imageNamed:@"checkbox_selected.png"] forState: UIControlStateNormal];
            break;
        }
        case eDownloadFailed:
        {
            [self.downloadButton setImage:[UIImage imageNamed:@"gb_resume.png"] forState: UIControlStateNormal];
            break;
        }
            
        default:
            break;
    }
    [self setNeedsDisplay];
}



@end
