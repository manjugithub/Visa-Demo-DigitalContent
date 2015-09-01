//
//  AudioPlaybackCell.m
//  Fastacash
//
//  Created by Accion on 09/07/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import "AudioPlaybackCell.h"
#import "Util.h"
#import "NSMutableURLRequest+BasicAuth.h"
#import "FCSession.h"
#import "UIImageView+WebCache.h"

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



- (void)didSuccessgetDownloadLink:(id)result
{
    /*
    {
        id = "b559c36a-48c0-4b5d-a105-52de13bb5468";
        params = "<null>";
        url = "https://dew-visa-demo.s3.amazonaws.com/audios/54cb3376-2e1a-4019-96c5-b59f4bbf7e71.mp3?Expires=1439887374&AWSAccessKeyId=AKIAJZOPGO7E244QQYJA&Signature=TTOOfN87ELtU4mvsD8bJcjj6iAY%3D";
    }
    */
    
    NSLog(@"Audio url ==> %@",[result valueForKey:@"url"]);
    [self startDownloading:[result valueForKey:@"url"] parent:self];
    
    
}

- (void)didFailedgetDownloadLink:(NSError *)error
{
    
}


-(void)getAudioLink:(NSMutableDictionary *)inDataDict
{
    if(self.isDownloading)
    {
        return;
    }
    [self setProfilePicture];
    NSString *downloadPath = [Util audioFilePath];
    NSString *tempNAme = [NSString stringWithFormat:@"temp_%@",@"audio.mp3"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self mediaFolderPathForFileName:tempNAme] error:nil];
    
    if ([fileManager fileExistsAtPath:downloadPath])
    {
        [self uploadSuccess];
        return;
    }

    
    [self.downloadIndicator updateDownloadStatus:eDownloadStarted];
    self.containerView.hidden = YES;
    self.playPauseBtn.enabled = NO;
    self.isDownloading = YES;

    {
        NSString *urlString = [NSString stringWithFormat:@"%@metadata/%@",[FCHTTPClient sharedFCHTTPClient].baseURL,[inDataDict valueForKey:@"id"]];
        AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
        NSError *error = nil;
        NSMutableURLRequest *request = [r requestWithMethod:@"GET" URLString:urlString parameters:nil error:&error];
        [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
        
        [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
        
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        operation.securityPolicy = securityPolicy;
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"Audio URL%@",[responseObject valueForKey:@"url"]);
             [self startDownloading:[responseObject valueForKey:@"url"] parent:self];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         }];
        
        [operation start];
    }
}

-(void)downloadMedia:(NSMutableDictionary *)inDataDict
{
    
}


-(void)setDatasource:(NSMutableDictionary *)inDataDict
{
    [self setProfilePicture];

    [self.downloadIndicator updateDownloadStatus:eDownloadStarted];

    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:[Util audioFilePath]] error:nil];
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
        [self.downloadIndicator updateDownloadStatus:eDownloadStarted];
        self.containerView.hidden = YES;
        self.playPauseBtn.enabled = NO;
        self.downloadIndicator.hidden = NO;
    }
}


- (IBAction)playAudio:(id)sender
{
    if ([sender tag] == 0)
    {
        [self.playPauseBtn setImage:[UIImage imageNamed:@"video-pause-button.png"] forState:UIControlStateNormal];
        [sender setTag:1];
        
        if (nil == self.audioPlayer)
        {
            self.audioPlayer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:[Util audioFilePath]] error:nil];
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



-(void)startDownloading:(NSString *)url parent:(id<FCHTTPClientProgress>)parent
{
    //     NSString *downloadPath = self.filePath;
    
    
    NSString *downloadPath = [Util audioFilePath];
    NSString *tempNAme = [NSString stringWithFormat:@"temp_%@",@"audio.mp3"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self mediaFolderPathForFileName:tempNAme] error:nil];
    
    if ([fileManager fileExistsAtPath:downloadPath])
    {
        [self uploadSuccess];
        return;
    }
    
    // request the video file from server
    //    NSString *downloadURL = @"http://anon.eastbaymediac.m7z.net/anon.eastbaymediac.m7z.net/teachingco/CourseGuideBooks/DG9344_B618F.PDF";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.downloadOp = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:downloadPath tempFileName:tempNAme shouldResume:YES];
    
    __weak AudioPlaybackCell* weakSelf = self;
    
    // done saving!
    [self.downloadOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Done downloading %@  for lecture ID ==> %@", downloadPath,self.mediaID);
         [weakSelf uploadSuccess];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSFileManager *fileManager = [NSFileManager defaultManager];
         if ([fileManager fileExistsAtPath:downloadPath])
         {
             [fileManager removeItemAtPath:[self mediaFolderPathForFileName:tempNAme] error:nil];
             [weakSelf uploadSuccess];
         }
         else
         {
             [weakSelf uploadFailed];
         }
         NSLog(@"Error: %ld", (long)[error code]);
     }];
    
    // set the progress
    [self.downloadOp setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile)
     {
         float progress = ((float)totalBytesReadForFile) / totalBytesExpectedToReadForFile;
         NSLog(@"progress: %f", progress);
         weakSelf.progressValue = progress;
         [weakSelf updateProgress:progress];
     }];
    
    [self.downloadOp start];
}


//Return file path for document folder
-(NSString*)downloadedMediaPath:(NSString*)filename
{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* filePath = [documentsPath stringByAppendingPathComponent:filename];
    //    [PWUtilities addSkipBackupAttributeToItemAtPath:[filePath UTF8String]];
    return filePath;
}


-(NSString *)mediaFolderPath;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *guideBookPAth = [documentsPath stringByAppendingPathComponent:@"MediaFiles"];
    //    [PWUtilities addSkipBackupAttributeToItemAtPath:[guideBookPAth UTF8String]];
    return guideBookPAth;
}

-(NSString *)mediaFolderPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *guideBookPAth = [documentsPath stringByAppendingPathComponent:@"MediaFiles"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:guideBookPAth])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:guideBookPAth withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *filePath = [guideBookPAth stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
    
    //    [PWUtilities addSkipBackupAttributeToItemAtPath:[filePath UTF8String]];
    return filePath;
}


-(void)setProfilePicture
{
    NSString *imageProfile = [[FCSession sharedSession].recipient getProfilePhoto];
    if ( imageProfile == nil)
    {
        NSString *photoURL = [[FCSession sharedSession] getRecipientPhoto];
        if(nil == photoURL)
        {
            
            NSLog(@"%@",NSStringFromCGRect(self.profilePicture.bounds));
            UILabel *label = [[UILabel alloc] initWithFrame:self.profilePicture.bounds];
            
            
            NSString *fullName = [FCSession sharedSession].sender.name;
            NSString *shortName = @"";
            
            [self.profilePicture setImage:[UIImage imageNamed:[self tableCellGetRandomImg]]];

            
            NSArray *array = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
            
            for (NSString *string in array) {
                //NSString *firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.firstName characterAtIndex:0]] uppercaseString]
                NSString *initial = [[NSString stringWithFormat: @"%C", [string characterAtIndex:0]] uppercaseString];
                shortName = [shortName stringByAppendingString:initial];
            }
            
            label.text = shortName;
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self.profilePicture addSubview:label];
            
        }
        else
        {
            [self.profilePicture sd_setImageWithURL:[NSURL URLWithString:photoURL]];
        }
    }
    else{
        [self.profilePicture sd_setImageWithURL:[NSURL URLWithString:imageProfile]];
    }
    
    self.profilePicture.layer.masksToBounds = YES;
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
    
}

-(NSString *)tableCellGetRandomImg{
    
    NSInteger r = 1 + arc4random() % 4;
    NSString *imgNameStr = [NSString stringWithFormat:@"FriendsList_Avatar_Bg_%ld", (long)r];
    return imgNameStr;
    
}

@end
