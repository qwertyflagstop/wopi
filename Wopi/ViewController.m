//
//  ViewController.m
//  Wopi
//
//  Created by Nicholas Peretti on 10/24/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import "ViewController.h"
#import "WPPeerClient.h"


@interface ViewController ()
{
    UILabel *readOut;
    UIView *bar;
    WPPeerClient *client;

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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self presentViewController:[client browserVC] animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
