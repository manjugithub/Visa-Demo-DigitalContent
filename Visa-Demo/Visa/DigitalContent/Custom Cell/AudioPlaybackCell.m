//
//  AudioPlaybackCell.m
//  Fastacash
//
//  Created by Accion on 09/07/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import "AudioPlaybackCell.h"

@implementation AudioPlaybackCell

- (void)awakeFromNib
{
    self.scrubRect = self.scrubber.frame;
    self.containerView.layer.cornerRadius = 5.0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setFinalDatasource:(NSMutableDictionary *)inDataDict
{
    [self.downloadIndicator updateDownloadStatus:eDownloadStarted];
    [self uploadSuccess];
}

-(void)setDatasource:(NSMutableDictionary *)inDataDict
{
    [self.downloadIndicator updateDownloadStatus:eDownloadStarted];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:[docsDir stringByAppendingPathComponent:@"tmp.m4a"]] error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer setVolume:1.0];
    [self.audioPlayer prepareToPlay];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%0.0f",[self.audioPlayer duration]];
    self.startTimeLabel.text = [NSString stringWithFormat:@"%0.0f",[self.audioPlayer currentTime]];
    
    if(NO ==   self.isDownloading)
    {
        self.containerView.hidden = YES;
        self.playPauseBtn.enabled = NO;
        self.isDownloading = YES;
        [[FCHTTPClient sharedFCHTTPClient] uploadMediaOfType:@"audio" parent:self];
    }
}

- (IBAction)closeDigitalCell:(id)sender
{
    if(self.downloadIndicator.hidden)
    {
        self.isDownloading = NO;
        [self.ParentVC closeDigitalContentCell:self];
    }
}


- (IBAction)playAudio:(id)sender
{
    if ([sender tag] == 0)
    {
        [self.playPauseBtn setImage:[UIImage imageNamed:@"video-pause-button.png"] forState:UIControlStateNormal];
        [sender setTag:1];
        
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
        
        if (nil == self.audioPlayer)
        {
            self.audioPlayer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:[docsDir stringByAppendingPathComponent:@"tmp.m4a"]] error:nil];
            self.audioPlayer.delegate = self;
            [self.audioPlayer setVolume:1.0];
            [self.audioPlayer prepareToPlay];
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setCategory:AVAudioSessionCategoryPlayback error:nil];
            [session setActive:YES error:nil];
        }
        self.endTimeLabel.text = [NSString stringWithFormat:@"%0.0f",[self.audioPlayer duration]];
        self.startTimeLabel.text = [NSString stringWithFormat:@"%0.0f",[self.audioPlayer currentTime]];
        [self.audioPlayer play];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    }
    else
    {
        [self.playPauseBtn setImage:[UIImage imageNamed:@"audioplaybtn.png"] forState:UIControlStateNormal];
        [sender setTag:0];
        [self.audioPlayer pause];
        [self.timer invalidate];
    }
}


-(void)updateTime
{
    self.startTimeLabel.text = [NSString stringWithFormat:@"%0.0f",[self.audioPlayer currentTime]];
    CGFloat chunkTime = self.seekBar.frame.size.width/[self.audioPlayer duration];
    CGRect frameRect = self.scrubber.frame;
    frameRect.origin.x = frameRect.origin.x + chunkTime;
    self.scrubber.frame = frameRect;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    self.playPauseBtn.tag = 0;
    self.startTimeLabel.text = [NSString stringWithFormat:@"%0.0f",[self.audioPlayer currentTime]];
    CGRect frameRect = self.scrubRect;
    self.scrubber.frame = frameRect;
    [self.playPauseBtn setImage:[UIImage imageNamed:@"audioplaybtn.png"]
                       forState:UIControlStateNormal];
    [self.timer invalidate];
}

-(void)updateProgress:(CGFloat)progress
{
    NSLog(@"progress vlaue ==================> %f",progress);
    [self.downloadIndicator updateProgress:progress];
}

-(void)uploadFailed
{
    self.containerView.hidden = NO;
    self.downloadIndicator.hidden = YES;
    self.uploadLabel.hidden = YES;
    self.playPauseBtn.enabled = YES;
}

-(void)uploadSuccess

{
    self.containerView.hidden = NO;
    self.downloadIndicator.hidden = YES;
    self.uploadLabel.hidden = YES;
    self.playPauseBtn.enabled = YES;
}

-(void)cancelUploading
{
    [self.uploadDataRequest cancel];
    self.downloadIndicator.hidden = YES;
    self.uploadLabel.hidden = YES;
    self.playPauseBtn.enabled = YES;
}

-(void)setOperation:(AFHTTPRequestOperation *)op
{
    self.uploadDataRequest = op;
}

@end
