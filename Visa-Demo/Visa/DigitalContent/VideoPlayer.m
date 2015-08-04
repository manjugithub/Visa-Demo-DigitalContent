//
//  VideoPlayer.m
//  Fastacash
//
//  Created by Accion on 09/07/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import "VideoPlayer.h"

@interface VideoPlayer ()
- (IBAction)doneButtonClicked:(id)sender;
- (IBAction)backButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *videoplayerView;

@end

@implementation VideoPlayer


- (IBAction)doneButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.movieController = [[MPMoviePlayerController alloc] initWithContentURL:[self movieURL]];
    [self.movieController setAllowsAirPlay:YES];
    [self.movieController.backgroundView setBackgroundColor:[UIColor blackColor]];
    self.movieController.controlStyle = MPMovieControlStyleEmbedded;
    [self.movieController.view setFrame:self.videoplayerView.bounds];
    [self.movieController setMovieSourceType:MPMovieSourceTypeFile];
    [self.videoplayerView addSubview:self.movieController.view];
    [self.movieController prepareToPlay];
    [self.movieController play];
}
@end
