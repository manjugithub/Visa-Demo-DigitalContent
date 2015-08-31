//
//  DigitalContentCreationVC.m
//  Fastacash
//
//  Created by Manjunath on 06/07/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import "DigitalContentCreationVC.h"
#import "VideoImageCell.h"
#import "VideoPlayer.h"
#import "MessageCell.h"
#import "AudioPlaybackCell.h"
#import "AppDelegate.h"
#import "FCSession.h"
#import "Util.h"
@interface DigitalContentCreationVC ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UIView *customTabbar,*tabbar1;
@property (weak, nonatomic) IBOutlet UIButton *messageButton,*messageButton1;
@property (weak, nonatomic) IBOutlet UIButton *photoCaptureBtn,*photoCaptureBtn1;
@property (weak, nonatomic) IBOutlet UIButton *videoRecordBtn,*videoRecordBtn1;
@property (weak, nonatomic) IBOutlet UIButton *audioRecordBtn,*audioRecordBtn1;
@property (weak, nonatomic) IBOutlet UIImageView *tempImageview;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) NSMutableArray *dataSourceDict;
@property (assign, nonatomic) CGRect tableRect,tabBarRect,textViewRect;
@property (assign, nonatomic) CGSize keyboardSize;
@property (assign, nonatomic) BOOL shouldHideKeyBoard,isFirstLaunch,shouldSave;
@property (assign, nonatomic) int counter;
@property (strong , nonatomic) NSTimer *timer;
- (IBAction)recordAudio:(id)sender;
- (IBAction)createMessage:(id)sender;
- (IBAction)recordVideo:(id)sender;
- (IBAction)capturePhoto:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)cancelBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;

#pragma mark - Audio creation
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIView *audioRecordOverLay;

- (IBAction)startRecordingAudio:(id)sender;
- (IBAction)stopRecordingAudio:(id)sender;



@end

@implementation DigitalContentCreationVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstLaunch = YES;
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
//    self.messageTextView.layer.cornerRadius = 5.0;
    self.dataSourceDict = [[NSMutableArray alloc] init];

//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *moviePath = [bundle pathForResource:@"video" ofType:@"mp4"];
//    UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);

    
    NSURL *tmpFileUrl = [NSURL fileURLWithPath:[Util audioFilePath]];
    NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                    [NSNumber numberWithFloat:16000.0], AVSampleRateKey,
                                    [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                    nil];
    NSError *error = nil;
    recorder = [[AVAudioRecorder alloc] initWithURL:tmpFileUrl settings:recordSettings error:&error];
    [recorder prepareToRecord];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.customTabbar.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableRect = self.contentTableView.frame;
    self.tabBarRect = self.customTabbar.frame;
    self.textViewRect = self.messageTextView.frame;

    if(self.isFirstLaunch)
    {
        [self.messageTextView becomeFirstResponder];
        [self.view bringSubviewToFront:self.messageTextView];
        self.isFirstLaunch = NO;
    }
    
    [self rearrangeTabbarButton];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Action methods

- (IBAction)doneButtonClicked:(id)sender
{
    if(self.shouldHideKeyBoard)
        [self.messageTextView resignFirstResponder];
    else
        [self.parentVC doneWithDigitalContentCreation];
}

- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelBtnClicked:(id)sender
{
    self.messageTextView.text = @"";
    [self.messageTextView resignFirstResponder];
}

#pragma mark - Action methods for creating Digital contents
- (IBAction)recordAudio:(id)sender
{
    if(self.shouldHideKeyBoard)
        [self.messageTextView resignFirstResponder];
    
    if(0 == self.audioRecordBtn.tag)
    {
        [self showAudioRecorder];
    }
    else
    {
        [self hideAudioRecorder];
    }
}

- (IBAction)createMessage:(id)sender
{
    [self hideAudioRecorder];
    [self.messageTextView becomeFirstResponder];
    [self.view bringSubviewToFront:self.messageTextView];
}

- (IBAction)recordVideo:(id)sender
{
    if(self.shouldHideKeyBoard)
        [self.messageTextView resignFirstResponder];
    [self hideAudioRecorder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil
                                               destructiveButtonTitle:nil otherButtonTitles:@"Take Video",@"Video Library",@"Cancel", nil];
    actionSheet.tag = 1001;
    [actionSheet showInView:[self view]];

}

- (IBAction)capturePhoto:(id)sender
{
    if(self.shouldHideKeyBoard)
        [self.messageTextView resignFirstResponder];
    [self hideAudioRecorder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil
                                               destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Photo Library",@"Cancel", nil];
    actionSheet.tag = 1000;
    [actionSheet showInView:[self view]];
}


#pragma mark - ActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    switch (actionSheet.tag)
    {
        case 1000:
        {
            if (buttonIndex == 2)
            {
                return;
            }
            else
            {
                UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.allowsEditing = YES;
                imagePicker.delegate = self;
                if ( [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]&& buttonIndex == 0)
                {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    self.shouldSave = YES;
                }
                else
                {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    self.shouldSave = NO;
                    
                }
                [[self navigationController] presentViewController:imagePicker animated:YES completion:nil];
            }

        }
            break;
        case 1001:
        {
            if (buttonIndex == 2)
            {
                return;
            }
            else
            {
                UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.allowsEditing = YES;
                imagePicker.delegate = self;
                if ( [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]&& buttonIndex == 0)
                {
                    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.allowsEditing = YES;
                    imagePicker.delegate = self;
                    if ( [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
                    {
                        
                        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                        
                        self.shouldSave = YES;
                    }
                    else
                    {
                        
                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        imagePicker.mediaTypes =
                        [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                        self.shouldSave = NO;
                    }
                    [[self navigationController] presentViewController:imagePicker animated:YES completion:nil];
                }
                else
                {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePicker.mediaTypes =
                    [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                    [[self navigationController] presentViewController:imagePicker animated:YES completion:nil];
                }
            }
            
        }
            break;
            
            
        default:
            break;
    }
    
}

#pragma mark - Image picker delegate

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([[info valueForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.movie"])
    {
        NSString *path=[Util videoFilePath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path] == YES)
        {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
        
        [[NSFileManager defaultManager] copyItemAtPath:[(NSURL *)[info valueForKey:UIImagePickerControllerMediaURL] path] toPath:path error:nil];
        


        AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:[info valueForKey:UIImagePickerControllerMediaURL] options:nil];
        AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
        generate1.appliesPreferredTrackTransform = YES;
        NSError *err = NULL;
        CMTime time = CMTimeMake(1, 2);
        CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
        UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];
//        self.tempImageview.image = one;
//        self.tempImageview.contentMode = UIViewContentModeScaleAspectFit;
        
        
        BOOL videoAdded = NO;
        for (NSMutableDictionary *dict in self.dataSourceDict)
        {
            if ([[dict valueForKey:@"type"] isEqualToString:@"Video"])
            {
                [dict setObject:path forKey:@"path"];
                [dict setObject:one forKey:@"image"];
                videoAdded = YES;
            }
        }
        
        if(NO == videoAdded)
        {
            [self.dataSourceDict addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:path,@"path",one,@"image",@"Video",@"type",nil]];
        }
        
        if(self.shouldSave == YES)
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        
        
    }
    else
    {
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        NSString *path = [Util imageFilePath];
        [imageData writeToFile:path atomically:YES];

        BOOL imageAdded = NO;
        for (NSMutableDictionary *dict in self.dataSourceDict)
        {
            if ([[dict valueForKey:@"type"] isEqualToString:@"Image"])
            {
                [dict setObject:path forKey:@"path"];
                [dict setObject:[info objectForKey:UIImagePickerControllerEditedImage] forKey:@"image"];
                imageAdded = YES;
            }
        }
        
        if(NO == imageAdded)
        {
            [self.dataSourceDict addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:path,@"path",[info objectForKey:UIImagePickerControllerEditedImage],@"image",@"Image",@"type",nil]];
        }

        if(self.shouldSave == YES)
            UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerEditedImage], nil, nil, nil);



    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    [self.contentTableView reloadData];
}

#pragma mark - Text View delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    return YES;
}


#pragma mark - Keyboard show / hide notification handling methods
-(void)repositionTabbarAgain
{
    CGRect frameRect = self.tableRect;
    CGRect frameRect1 = self.tabBarRect;
    CGRect frameRect2 = self.textViewRect;
    frameRect.size.height = frameRect.size.height - self.keyboardSize.height;
    frameRect1.origin.y = frameRect1.origin.y - self.keyboardSize.height;
    frameRect2.size.height = frameRect2.size.height - self.keyboardSize.height;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(repositionTabbarAgain)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.0];
    self.contentTableView.frame = frameRect;
    self.customTabbar.frame = frameRect1;
    self.messageTextView.frame = frameRect2;
    [UIView commitAnimations];
    self.contentTableView.hidden = YES;
}
- (void)keyboardWillShow:(NSNotification*)notification
{
    if(self.cancelBtn.hidden)
    {
        self.instructionLabel.hidden = NO;
        self.messageTextView.text = @"";
    }
    
    [self.messageButton setImage:[UIImage imageNamed:@"meta_message_activate.png"] forState:UIControlStateNormal];
    self.shouldHideKeyBoard = YES;
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"%@",NSStringFromCGSize(kbSize));
    self.keyboardSize = kbSize;
    CGRect frameRect = self.tableRect;
    CGRect frameRect1 = self.tabBarRect;
    CGRect frameRect2 = self.textViewRect;
    frameRect.size.height = frameRect.size.height - kbSize.height;
    frameRect1.origin.y = frameRect1.origin.y - kbSize.height;
    frameRect2.size.height = frameRect2.size.height - kbSize.height;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(repositionTabbarAgain)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.contentTableView.frame = frameRect;
    self.customTabbar.frame = frameRect1;
    self.messageTextView.frame = frameRect2;
    [UIView commitAnimations];
    self.contentTableView.hidden = YES;
    self.cancelBtn.hidden = NO;
    self.backBtn.hidden = YES;
}


- (void)keyboardWillHide:(NSNotification*)notification
{
    self.cancelBtn.hidden = YES;
    self.backBtn.hidden = NO;
    self.instructionLabel.hidden = YES;

    [self.messageButton setImage:[UIImage imageNamed:@"meta_message.png"] forState:UIControlStateNormal];
    self.shouldHideKeyBoard = NO;
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"%@",NSStringFromCGSize(kbSize));
    self.keyboardSize = kbSize;
    CGRect frameRect = self.tableRect;
    CGRect frameRect1 = self.tabBarRect;
    CGRect frameRect2 = self.textViewRect;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.contentTableView.frame = frameRect;
    self.customTabbar.frame = frameRect1;
    self.messageTextView.frame = frameRect2;
    [UIView commitAnimations];
    [self.view sendSubviewToBack:self.messageTextView];
    self.contentTableView.hidden = NO;
    
    if([[self.messageTextView text] isEqualToString:@""])
        return;
    
    BOOL imageAdded = NO;
    for (NSMutableDictionary *dict in self.dataSourceDict)
    {
        if ([[dict valueForKey:@"type"] isEqualToString:@"text"])
        {
            [dict setObject:self.messageTextView.text forKey:@"message"];
            imageAdded = YES;
        }
    }
    if(NO == imageAdded)
    {
        [self.dataSourceDict addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.messageTextView.text,@"message",@"text",@"type",nil]];
    }
    
    NSString *linkID = [FCSession sharedSession].linkID;
    NSMutableDictionary *paramsDict1 = [[NSMutableDictionary alloc] init];
    [paramsDict1 setValue:@"text" forKey:@"type"];
    [paramsDict1 setValue:self.messageTextView.text forKey:@"text"];
    
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    [[FCHTTPClient sharedFCHTTPClient] uploadText:self.messageTextView.text];
//    [[FCHTTPClient sharedFCHTTPClient] createLinkMetadata:linkID withParams:paramsDict1];

    [self.contentTableView reloadData];

}

- (void)didSuccessUpdateLink:(id)result
{
    
}
- (void)didFailedUpdateLink:(NSError *)error
{
    
}




#pragma mark - TableView datasource and delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dataDict = [self.dataSourceDict objectAtIndex:indexPath.row];
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"text"])
    {
        CGFloat height = self.messageTextView.contentSize.height + 10.0;
        [[NSUserDefaults standardUserDefaults] setFloat:height > 80.0 ? height : 80.0 forKey:@"textRowHeight"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return height > 80 ? height : 80;
    }
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"audio"])
    {
        return 110;
    }
    
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.datasourceArray = self.dataSourceDict;
    return self.dataSourceDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dataDict = [self.dataSourceDict objectAtIndex:indexPath.row];
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"text"])
    {
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
        cell.ParentVC = self;
        [cell setDatasource:dataDict];
        return cell;
    }
    else if([[dataDict valueForKey:@"type"] isEqualToString:@"audio"])
    {
        AudioPlaybackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudioPlaybackCell" forIndexPath:indexPath];
        cell.ParentVC = self;
        [cell setDatasource:dataDict];
        return cell;
    }
    else
    {
        VideoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoImageCell" forIndexPath:indexPath];
        cell.ParentVC = self;
        [cell setDatasource:dataDict];
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(void)showVideoController:(NSMutableDictionary *)inDict
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"DigitalContent" bundle:nil];
    VideoPlayer *videoController = [mainStoryboard instantiateViewControllerWithIdentifier:@"VideoPlayer"];
    videoController.movieURL = [NSURL fileURLWithPath:[Util videoFilePath]];

    //    [socialSetup assignParent:self];
    [self.navigationController pushViewController:videoController animated:YES];

}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
 
    if([textView.text isEqualToString:@""] && [text isEqualToString:@""])
        self.instructionLabel.hidden = NO;
    else
        self.instructionLabel.hidden = YES;

    return YES;
}

-(void)closeDigitalContentCell:(UITableViewCell *)inTableCell
{
    NSIndexPath *indexPath = [self.contentTableView indexPathForCell:inTableCell];
    [self.dataSourceDict removeObjectAtIndex:indexPath.row];
    [self.contentTableView beginUpdates];
    [self.contentTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    [self.contentTableView endUpdates];
}
- (IBAction)startRecordingAudio:(id)sender
{
    [self.recordBtn setImage:[UIImage imageNamed:@"audio_recording.png"] forState:UIControlStateNormal];

    if ([[NSFileManager defaultManager] fileExistsAtPath:[Util audioFilePath]])
    {
        [[NSFileManager defaultManager]removeItemAtPath:[Util audioFilePath] error:nil];
    }
    
    NSURL *tmpFileUrl = [NSURL fileURLWithPath:[Util audioFilePath]];
    NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                    [NSNumber numberWithFloat:16000.0], AVSampleRateKey,
                                    [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                    nil];
    NSError *error = nil;
    recorder = [[AVAudioRecorder alloc] initWithURL:tmpFileUrl settings:recordSettings error:&error];
    [recorder prepareToRecord];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryRecord error:nil];
    [session setActive:YES error:nil];
    [recorder record];
    [self showAudioRecorder];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    self.counter = 0;
}


-(void)updateTime
{
    self.counter ++;
    self.timeLabel.text = [NSString stringWithFormat:@"%d",self.counter];
}


- (IBAction)stopRecordingAudio:(id)sender
{
    [self.timer invalidate];
    self.counter = 0;
    self.timeLabel.text = [NSString stringWithFormat:@"%d",self.counter];

    [self.recordBtn setImage:[UIImage imageNamed:@"audio_record.png"] forState:UIControlStateNormal];
    [recorder stop];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
    
    BOOL videoAdded = NO;
    for (NSMutableDictionary *dict in self.dataSourceDict)
    {
        if ([[dict valueForKey:@"type"] isEqualToString:@"audio"])
        {
            videoAdded = YES;
        }
    }
    
    if(NO == videoAdded)
    {
        [self.dataSourceDict addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"audio",@"type",nil]];
    }
    [self.contentTableView reloadData];
    [self hideAudioRecorder];
    
}

-(void)updateProgress:(CGFloat)progress
{
    
}

-(void)showAudioRecorder
{
    [self.audioRecordBtn setImage:[UIImage imageNamed:@"meta_audio_activate.png"] forState:UIControlStateNormal];
    [self.audioRecordBtn setTag:1];
    
    self.audioRecordOverLay.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.audioRecordOverLay.alpha = 1.0;
    [UIView commitAnimations];
    
    if(self.dataSourceDict.count > 0)
        [self.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSourceDict.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

-(void)hideAudioRecorder
{
    [self.audioRecordBtn setImage:[UIImage imageNamed:@"meta_audio.png"] forState:UIControlStateNormal];
    [self.audioRecordBtn setTag:0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationEnded)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.audioRecordOverLay.alpha = 0.0;
    [UIView commitAnimations];
}

-(void)animationEnded
{
    self.audioRecordOverLay.hidden = YES;
}

-(void)rearrangeTabbarButton
{
    
    CGFloat startPoint = 15.0;
    CGFloat totalFrameWidth = self.view.frame.size.width;
    CGFloat remainingWidth = totalFrameWidth -(30 * 4) - (startPoint * 2);
    CGFloat offset = remainingWidth / 3.0;

//    CGFloat fWidth = self.customTabbar.frame;
    

    CGRect messageBtnFrame =   self.messageButton.frame;
    CGRect videoRecordBtnFrame =   self.videoRecordBtn.frame;
    CGRect audioRecordBtnFrame =   self.audioRecordBtn.frame;
    CGRect photoCaptureBtnFrame =   self.photoCaptureBtn.frame;
    
    
    messageBtnFrame.origin.x = startPoint;
    photoCaptureBtnFrame.origin.x = startPoint + offset + 30;
    videoRecordBtnFrame.origin.x = startPoint + offset*2 + 30*2;
    audioRecordBtnFrame.origin.x = startPoint + offset*3 + 30*3;
    
    self.messageButton.frame = messageBtnFrame;
    self.videoRecordBtn.frame = videoRecordBtnFrame;
    self.audioRecordBtn.frame = audioRecordBtnFrame;
    self.photoCaptureBtn.frame = photoCaptureBtnFrame;

    
    self.messageButton1.frame = messageBtnFrame;
    self.videoRecordBtn1.frame = videoRecordBtnFrame;
    self.audioRecordBtn1.frame = audioRecordBtnFrame;
    self.photoCaptureBtn1.frame = photoCaptureBtnFrame;

    
    self.customTabbar.hidden = NO;
    
}
@end
