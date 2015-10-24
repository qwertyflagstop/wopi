//
//  WPListener.h
//  Wopi
//
//  Created by Nicholas Peretti on 10/24/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WPListener : NSObject <AVAudioRecorderDelegate>

@property (nonatomic) CGFloat averageAudioIntensity;
@property (nonatomic, strong) AVAudioRecorder *recorder;

@end
