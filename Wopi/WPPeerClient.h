//
//  WPPeerClient.h
//  Wopi
//
//  Created by Nicholas Peretti on 10/24/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

static NSString * const XXServiceType = @"xx-wopi";

typedef enum WPPeerPosition : NSUInteger {
    kTopLeft,
    kTopRight,
    kBack,
} WPPeerPosition;

@interface WPPeerClient : NSObject <MCBrowserViewControllerDelegate, MCSessionDelegate,NSStreamDelegate>

@property (nonatomic, strong) MCBrowserViewController *browserVC;

-(instancetype)initWithPosition:(WPPeerPosition)position;

-(void)sendAudio:(float)audioLvl forPosition:(WPPeerPosition)position;

@end
