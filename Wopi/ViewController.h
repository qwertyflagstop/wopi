//
//  ViewController.h
//  Wopi
//
//  Created by Nicholas Peretti on 10/24/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudio.h"

@interface ViewController : UIViewController <EZMicrophoneDelegate, EZAudioFFTDelegate>


@property (nonatomic,strong)  EZMicrophone *microphone;

@property (nonatomic, strong) EZAudioFFTRolling *fft;

@end

