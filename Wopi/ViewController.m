//
//  ViewController.m
//  Wopi
//
//  Created by Nicholas Peretti on 10/24/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import "ViewController.h"

static vDSP_Length const FFTViewControllerFFTWindowSize = 4096;

@interface ViewController ()
{
    UILabel *readOut;
    float amp;
    float freq;
}
@end

@implementation ViewController

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        //init other stuff later
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
    // Do any additional setup after loading the view, typically from a nib.
    //
    // Create an instance of the microphone and tell it to use this view controller instance as the delegate
    //
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    
    //
    // Create an instance of the EZAudioFFTRolling to keep a history of the incoming audio data and calculate the FFT.
    //
    self.fft = [EZAudioFFTRolling fftWithWindowSize:FFTViewControllerFFTWindowSize
                                         sampleRate:self.microphone.audioStreamBasicDescription.mSampleRate
                                           delegate:self];
    
    //
    // Start the mic
    //
    [self.microphone startFetchingAudio];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (float)getDecibelsFromVolume:(float**)buffer withBufferSize:(UInt32)bufferSize {
    
    float one = 1.0;
    float meanVal = 0.0;
    float tiny = 0.1;
    float lastdbValue = 0.0;
    
    vDSP_vsq(buffer[0], 1, buffer[0], 1, bufferSize);
    
    vDSP_meanv(buffer[0], 1, &meanVal, bufferSize);
    
       amp = (meanVal*0.5)+(amp*0.5);
    
    vDSP_vdbcon(&meanVal, 1, &one, &meanVal, 1, 1, 0);
    
    
    // Exponential moving average to dB level to only get continous sounds.
    
    float currentdb = 1.0 - (fabs(meanVal) / 100);
    
    if (lastdbValue == INFINITY || lastdbValue == -INFINITY || isnan(lastdbValue)) {
        lastdbValue = 0.0;
    }
    
    float dbValue = ((1.0 - tiny) * lastdbValue) + tiny * currentdb;
    
    //lastdbValue = dbValue;
    
    return dbValue;
}
-(void)updateLabels
{
    [readOut setText:[NSString stringWithFormat:@"%f dB /n %f Hz",amp,freq]];
}
//------------------------------------------------------------------------------
#pragma mark - EZMicrophoneDelegate
//------------------------------------------------------------------------------

-(void)    microphone:(EZMicrophone *)microphone
     hasAudioReceived:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
{
    
    
    //
    // Calculate the FFT, will trigger EZAudioFFTDelegate
    //
    [self.fft computeFFTWithBuffer:buffer[0] withBufferSize:bufferSize];
    float dbVal = [self getDecibelsFromVolume:buffer withBufferSize:bufferSize];
    //__weak typeof (self) weakSelf = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateLabels];
    });
}

//------------------------------------------------------------------------------
#pragma mark - EZAudioFFTDelegate
//------------------------------------------------------------------------------

- (void)        fft:(EZAudioFFT *)fft
 updatedWithFFTData:(float *)fftData
         bufferSize:(vDSP_Length)bufferSize
{
    float maxFrequency = [fft maxFrequency];
    //__weak typeof (self) weakSelf = self;
    freq = maxFrequency;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateLabels];
    });
}

//------------------------------------------------------------------------------

@end
