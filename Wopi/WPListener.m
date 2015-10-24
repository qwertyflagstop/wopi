//
//  WPListener.m
//  Wopi
//
//  Created by Nicholas Peretti on 10/24/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import "WPListener.h"
#import <AVFoundation/AVFoundation.h>

@implementation WPListener

-(instancetype)init
{
    self = [super init];
    if (self)
    {
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
        NSDictionary *recordSetting =[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat: 176400], AVSampleRateKey,
                                             [NSNumber numberWithInt: kAudioFormatLinearPCM], AVFormatIDKey,
                                             [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                             [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
                                             [NSNumber numberWithInt:8],AVLinearPCMBitDepthKey,
                                             [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                             [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                             nil];
        
        self.recorder = [[AVAudioRecorder alloc] initWithURL:[self audioFilePathUrl] settings:recordSetting error:&error];
        self.recorder.delegate=self;
        [self.recorder prepareToRecord];
        self.recorder.meteringEnabled = YES;
        [self.recorder record];
        NSTimer *levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.02f target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
        
    }
    return self;
}


-(NSURL *)audioFilePathUrl
{
    
    NSArray *arr = [[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains: NSUserDomainMask];
    NSURL *documentsUrl = [arr firstObject];
    return [documentsUrl URLByAppendingPathComponent:@"sound.wav"];
}

- (void)levelTimerCallback:(NSTimer *)timer {
    
    [self.recorder updateMeters];
    self.averageAudioIntensity = -[self.recorder averagePowerForChannel:0];
    
}

@end
