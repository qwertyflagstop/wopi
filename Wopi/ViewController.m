//
//  ViewController.m
//  Wopi
//
//  Created by Nicholas Peretti on 10/24/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import "ViewController.h"
#import "WPPeerClient.h"
#import "WPListener.h"


@interface ViewController ()
{
    UILabel *readOut;
    UIView *bar;
    WPPeerClient *client;
    WPListener *listener;
    NSTimer *barPoll;
    UISegmentedControl *control;

}
@end

@implementation ViewController

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        //init other stuff later
        client = [[WPPeerClient alloc]initWithPosition:kTopLeft];
        listener = [[WPListener alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    bar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    [bar setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:bar];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    readOut = [[UILabel alloc]init];
    [readOut setTextColor:[UIColor blackColor]];
    [self.view addSubview:readOut];
    [readOut setTranslatesAutoresizingMaskIntoConstraints:NO];
    [readOut setNumberOfLines:0];
    [readOut setTextAlignment:NSTextAlignmentCenter];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:readOut attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:readOut attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:readOut attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:readOut attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    */
    
    control = [[UISegmentedControl alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40, 40)];
    [control insertSegmentWithTitle:@"L" atIndex:0 animated:YES];
    [control insertSegmentWithTitle:@"R" atIndex:1 animated:YES];
    [control insertSegmentWithTitle:@"M" atIndex:2 animated:YES];
    [control setSelectedSegmentIndex:0];
    [self.view addSubview:control];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissBrowser) name:@"done" object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self presentViewController:[client browserVC] animated:YES completion:nil];
    });
    
}

-(void)viewDidAppear:(BOOL)animated
{
    barPoll = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(refreshAudioLevel) userInfo:nil repeats:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [barPoll invalidate];
}

-(void)refreshAudioLevel
{
    //[readOut setText:[NSString stringWithFormat:@"%f",listener.averageAudioIntensity]];
    //[bar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 30+(((listener.averageAudioIntensity)/60.0)*self.view.frame.size.height-30))];
    [self.view setBackgroundColor:[UIColor colorWithRed:(0 + (listener.averageAudioIntensity*.0167)) green:0 blue:1.0 alpha:1]];
    
    WPPeerPosition pos;
    if (control.selectedSegmentIndex==0) {
        pos = kTopLeft;
    } else if (control.selectedSegmentIndex == 1) {
        pos = kTopRight;
    } else if (control.selectedSegmentIndex == 2) {
        pos = kBack;
    }
    [client sendAudio:listener.averageAudioIntensity forPosition:pos];
}

-(void)dismissBrowser
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
