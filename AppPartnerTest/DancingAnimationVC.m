//
//  DancingAnimationVC.m
//  AppPartnerTest
//
//  Created by Ujwal Manjunath on 6/12/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "DancingAnimationVC.h"

@interface DancingAnimationVC ()
@property (nonatomic, weak) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *danceFloor;
@property (weak, nonatomic) IBOutlet UIImageView *luigi;
@property (weak, nonatomic) IBOutlet UIImageView *mario;
@property(nonatomic,strong) AVAudioPlayer *player;
@end



@implementation DancingAnimationVC

-(void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(marioLuigiDance:) userInfo:nil repeats:YES];
}


-(void)stopTimer
{
    [self.timer invalidate]; // timer set to nil
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopTimer];
}

-(void)marioLuigiDance:(NSTimer *)timer
{
    [self marioLuigiDance];
}

-(void)marioLuigiDance
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        
            
            [self setRandomLocation:self.mario];
             [self setRandomLocation:self.luigi];
        
        
        
        
    }completion:^(BOOL finished){
        
        if(finished)
        {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                [self setRandomLocation:self.mario];
                [self setRandomLocation:self.luigi];
                
                
                
            }completion:^(BOOL fin){
                
            }];
        }
    }];
    
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)danceMarioDance:(UIButton *)sender {
    if(![self.player isPlaying]){
        [self.player play];
        [self startTimer];
    }
    else{
        [self.player stop];
        [self stopTimer];
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(!flag){
        // may be add an alert;
    }
    [self stopTimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMp3File];
	// Do any additional setup after loading the view.
}

-(void)loadMp3File
{
    NSString *marioMp3 = [[NSBundle mainBundle]pathForResource:@"marioDance" ofType:@"mp3"];
    self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:marioMp3 ] error:nil];
    [self.player setDelegate:self];
}

-(void)setRandomLocation:(UIView *)view{
    
    //[view sizeToFit];
    CGRect ViewBounds = CGRectInset(self.danceFloor.bounds, view.frame.size.width/2, view.frame.size.height/2);
    CGFloat x = arc4random() % (int)ViewBounds.size.width + view.frame.size.width/2;
    CGFloat y = arc4random() % (int)ViewBounds.size.height + view.frame.size.height/2;
    view.center= CGPointMake(x,y );
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
