//
//  VideoImageCell.m
//  Fastacash
//
//  Created by Accion on 08/07/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import "VideoImageCell.h"
#import "Util.h"
#import "NSMutableURLRequest+BasicAuth.h"
#import "FCSession.h"
#import "UIImageView+WebCache.h"

@implementation VideoImageCell

- (void)awakeFromNib
{
    self.mediaImageView.layer.cornerRadius = 5.0;
    self.downloadIndicator.delegate = self;
    self.isDownloading = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)closeDigitalCell:(id)sender
{
    if(self.downloadIndicator.hidden)
    {
        self.isDownloading = NO;
        [self.ParentVC closeDigitalContentCell:self];
    }
}

- (IBAction)playMedia:(id)sender
{    
    [self.ParentVC showVideoController:self.selectedDict];
}


-(void)downloadMedia:(NSMutableDictionary *)inDataDict
{
    self.selectedDict = inDataDict;
    self.isDownloading = YES;
    self.downloadIndicator.hidden = NO;
    self.uploadLabel.hidden = NO;
    self.closeBtn.hidden = YES;
    self.mediaImageView.hidden = YES;
    self.playButton.hidden = YES;
    NSString *downloadPath = [Util imageFilePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:downloadPath])
    {
        self.mediaImageView.image = [[UIImage alloc] initWithContentsOfFile:downloadPath];
        [self uploadSuccess];
        return;
    }

    [self.downloadIndicator updateDownloadStatus:eDownloadStarted];
    [self startDownloading:[inDataDict valueForKey:@"path"] parent:self];
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
    
    
    
}

- (void)didFailedgetDownloadLink:(NSError *)error
{
    
}

-(void)setProfilePicture
{
    NSString *imageProfile = [[FCSession sharedSession].recipient getProfilePhoto];
    if ( imageProfile == nil)
    {
        NSString *photoURL = [[FCSession sharedSession] getRecipientPhoto];
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:photoURL]];
    }
    else{
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:imageProfile]];
    }
    
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;

}


-(void)getVideoLink:(NSMutableDictionary *)inDataDict
{
    [self setProfilePicture];
    NSString *downloadPath = [Util videoFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:downloadPath])
    {
        self.mediaImageView.image = [[UIImage alloc] initWithContentsOfFile:downloadPath];
        [self uploadSuccess];
        return;
    }
    
    [self.downloadIndicator updateDownloadStatus:eDownloadStarted];
    self.sideImageView.image = [UIImage imageNamed:@"sideicon-video.png"];
    self.isDownloading = YES;
    self.downloadIndicator.hidden = NO;
    self.uploadLabel.hidden = NO;
    self.closeBtn.hidden = YES;
    self.mediaImageView.hidden = YES;
    self.playButton.hidden = YES;
    
    
    
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
            NSLog(@"Video url ==> %@",[responseObject valueForKey:@"url"]);

            [self startDownloading:[responseObject valueForKey:@"url"] parent:self];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
        [operation start];
    }
    
}


//-(void)getVideoLink:(NSMutableDictionary *)inDataDict
//{
//    self.selectedDict = inDataDict;
//    [self.downloadIndicator updateDownloadStatus:eDownloadStarted];
//    self.isDownloading = YES;
//    self.downloadIndicator.hidden = NO;
//    self.uploadLabel.hidden = NO;
//    self.closeBtn.hidden = YES;
//    self.mediaImageView.hidden = YES;
//    self.playButton.hidden = YES;
//    [self startDownloading:[inDataDict valueForKey:@"path"] parent:self];
//}


-(void)setFinalDatasource:(NSMutableDictionary *)inDataDict
{
    [self setProfilePicture];

    [self.downloadIndicator updateDownloadStatus:eDownloadStarted];
    self.selectedDict = inDataDict;
    if ([[inDataDict valueForKey:@"type"] isEqualToString:@"Image"])
    {
        self.sideImageView.image = [UIImage imageNamed:@"sideicon-photo.png"];
        if(NO ==   self.isDownloading)
        {
            self.isDownloading = YES;
            self.downloadIndicator.hidden = NO;
            self.uploadLabel.hidden = NO;
            self.closeBtn.hidden = YES;
            self.mediaImageView.hidden = YES;
            self.playButton.hidden = YES;
        }
    }
    else
    {
        self.sideImageView.image = [UIImage imageNamed:@"sideicon-video.png"];
        
        if(NO ==   self.isDownloading)
        {
            self.isDownloading = YES;
            self.downloadIndicator.hidden = NO;
            self.uploadLabel.hidden = NO;
            self.closeBtn.hidden = YES;
            self.mediaImageView.hidden = YES;
            self.playButton.hidden = YES;
        }
        
    }
    self.mediaImageView.image = [inDataDict objectForKey:@"image"];
    [self uploadSuccess];
}




-(void)setDatasource:(NSMutableDictionary *)inDataDict
{
    [self setProfilePicture];

    [self.downloadIndicator updateDownloadStatus:eDownloadStarted];
    self.selectedDict = inDataDict;
    if ([[inDataDict valueForKey:@"type"] isEqualToString:@"Image"])
    {
        self.sideImageView.image = [UIImage imageNamed:@"sideicon-photo.png"];
        if(NO ==   self.isDownloading)
        {
            self.isDownloading = YES;
            self.downloadIndicator.hidden = NO;
            self.uploadLabel.hidden = NO;
            self.closeBtn.hidden = YES;
            self.mediaImageView.hidden = YES;
            self.playButton.hidden = YES;
            [[FCHTTPClient sharedFCHTTPClient] uploadMediaOfType:@"image" parent:self];
        }
    }
    else
    {
        self.sideImageView.image = [UIImage imageNamed:@"sideicon-video.png"];
        
        if(NO ==   self.isDownloading)
        {
            self.isDownloading = YES;
            self.downloadIndicator.hidden = NO;
            self.uploadLabel.hidden = NO;
            self.closeBtn.hidden = YES;
            self.mediaImageView.hidden = YES;
            self.playButton.hidden = YES;
            [[FCHTTPClient sharedFCHTTPClient] uploadMediaOfType:@"video" parent:self];
        }

    }
    self.mediaImageView.image = [inDataDict objectForKey:@"image"];
    
//    [self startDownloading:@"http://res.cloudinary.com/fastacash-dev/image/upload/c_fit,h_256,w_256/361f3406-d4ef-4de4-9374-a26be8e53ad4.jpg" parent:self];
}


-(void)updateProgress:(CGFloat)progress
{
    NSLog(@"progress vlaue ==================> %f",progress);
    [self.downloadIndicator updateProgress:progress];
}

-(void)uploadFailed
{

    self.downloadIndicator.hidden = YES;
    self.uploadLabel.hidden = YES;
    if (![[self.selectedDict valueForKey:@"type"] isEqualToString:@"Image"])
        self.playButton.hidden = NO;

    self.closeBtn.hidden = NO;
    self.mediaImageView.hidden = NO;

}

-(void)uploadSuccess
{
    self.downloadIndicator.hidden = YES;
    self.uploadLabel.hidden = YES;
    if (![[[self.selectedDict valueForKey:@"type"] lowercaseString] isEqualToString:@"image"])
    {
        self.sideImageView.image = [UIImage imageNamed:@"sideicon-video.png"];
        self.playButton.hidden = NO;
        
        
//        AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:[Util videoFilePath]] options:nil];
//        AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
//        generate1.appliesPreferredTrackTransform = YES;
//        NSError *err = NULL;
//        CMTime time = CMTimeMake(1, 2);
//        CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
        self.mediaImageView.layer.borderColor = [[UIColor blackColor]CGColor];
        self.mediaImageView.layer.borderWidth = 1.0;
//        image = [[UIImage alloc] initWithCGImage:oneRef];

    }
    else
    {
        self.sideImageView.image = [UIImage imageNamed:@"sideicon-photo.png"];
    }
    self.closeBtn.hidden = NO;
    self.mediaImageView.hidden = NO;
}

-(void)cancelUploading
{
    [self.uploadDataRequest cancel];
    self.downloadIndicator.hidden = YES;
    self.uploadLabel.hidden = YES;
    if (![[self.selectedDict valueForKey:@"type"] isEqualToString:@"Image"])
        self.playButton.hidden = NO;
    self.closeBtn.hidden = NO;
    self.mediaImageView.hidden = NO;
}

-(void)setOperation:(AFHTTPRequestOperation *)op
{
    self.uploadDataRequest = op;
}


-(void)startDownloading:(NSString *)url parent:(id<FCHTTPClientProgress>)parent
{
    
    if (![[[self.selectedDict valueForKey:@"type"] lowercaseString] isEqualToString:@"image"])
    {
        self.sideImageView.image = [UIImage imageNamed:@"sideicon-video.png"];
    }
    else
    {
        self.sideImageView.image = [UIImage imageNamed:@"sideicon-photo.png"];
    }

    
    //     NSString *downloadPath = self.filePath;
    NSString *downloadPath = [Util videoFilePath];
    
    if ([[[self.selectedDict valueForKey:@"type"] lowercaseString] isEqualToString:@"image"])
        downloadPath = [Util imageFilePath];

    NSString *tempNAme = [NSString stringWithFormat:@"temp_%@",[url lastPathComponent]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self mediaFolderPathForFileName:tempNAme] error:nil];

    if ([fileManager fileExistsAtPath:downloadPath])
    {
        self.mediaImageView.image = [[UIImage alloc] initWithContentsOfFile:downloadPath];
        [self uploadSuccess];
        return;
    }

    // request the video file from server
    //    NSString *downloadURL = @"http://anon.eastbaymediac.m7z.net/anon.eastbaymediac.m7z.net/teachingco/CourseGuideBooks/DG9344_B618F.PDF";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.downloadOp = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:downloadPath tempFileName:tempNAme shouldResume:YES];

    __weak VideoImageCell* weakSelf = self;
    
    // done saving!
    [self.downloadOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Done downloading %@", downloadPath);
         self.mediaImageView.image = [[UIImage alloc] initWithContentsOfFile:downloadPath];
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
    return filePath;
}

@end
