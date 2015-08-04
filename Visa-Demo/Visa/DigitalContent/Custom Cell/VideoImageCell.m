//
//  VideoImageCell.m
//  Fastacash
//
//  Created by Accion on 08/07/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import "VideoImageCell.h"
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
    [self.downloadIndicator updateDownloadStatus:eDownloadStarted];
    self.isDownloading = YES;
    self.downloadIndicator.hidden = NO;
    self.uploadLabel.hidden = NO;
    self.closeBtn.hidden = YES;
    self.mediaImageView.hidden = YES;
    self.playButton.hidden = YES;
    [self startDownloading:[inDataDict valueForKey:@"path"] parent:self];
}


-(void)setFinalDatasource:(NSMutableDictionary *)inDataDict
{
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
        self.playButton.hidden = NO;
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
    //     NSString *downloadPath = self.filePath;
    NSString *downloadPath = [self mediaFolderPathForFileName:[url lastPathComponent]];
    NSString *tempNAme = [NSString stringWithFormat:@"temp_%@",[url lastPathComponent]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self mediaFolderPathForFileName:tempNAme] error:nil];

    if ([fileManager fileExistsAtPath:downloadPath])
    {
        [fileManager removeItemAtPath:downloadPath error:nil];
        //             [weakSelf.downloadManagerDelegate didMediaDownloadComplete:self];
    }

    // request the video file from server
    //    NSString *downloadURL = @"http://anon.eastbaymediac.m7z.net/anon.eastbaymediac.m7z.net/teachingco/CourseGuideBooks/DG9344_B618F.PDF";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.downloadOp = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:downloadPath tempFileName:tempNAme shouldResume:YES];

    __weak VideoImageCell* weakSelf = self;
    
    // done saving!
    [self.downloadOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Done downloading %@  for lecture ID ==> %@", downloadPath,self.mediaID);
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

@end
