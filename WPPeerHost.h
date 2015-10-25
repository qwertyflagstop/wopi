//
//  WPPeerHost.h
//  Wopi
//
//  Created by Nicholas Peretti on 10/24/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

#import "WPPeerClient.h"

@protocol WPPeerHostDelegate <NSObject>
@required
- (void)gotAudioLvl:(CGFloat)lvl forChannel:(char)chanel; // L R B
@end

@interface WPPeerHost : NSObject <MCAdvertiserAssistantDelegate, MCSessionDelegate>

@property (nonatomic, weak) id <WPPeerHostDelegate> delegate;
-(instancetype)init;
-(void)startConnecting;
@end
