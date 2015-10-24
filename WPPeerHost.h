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

@interface WPPeerHost : NSObject <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>

-(instancetype)init;

@end
