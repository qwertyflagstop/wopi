//
//  WPPeerClient.m
//  Wopi
//
//  Created by Nicholas Peretti on 10/24/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import "WPPeerClient.h"


@implementation WPPeerClient
{
    WPPeerPosition currentPosition;
    MCPeerID *myPeerID;
    MCSession *session;
    MCNearbyServiceBrowser *broswer;
}

-(instancetype)initWithPosition:(WPPeerPosition)position
{
    self = [super init];
    if (self)
    {
        myPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
        currentPosition = position;
        broswer =[[MCNearbyServiceBrowser alloc]initWithPeer:myPeerID serviceType:XXServiceType];
        session = [[MCSession alloc]initWithPeer:myPeerID];
        self.browserVC  = [[MCBrowserViewController alloc]initWithServiceType:@"wopi" session:session];
    }
    return self;
}

-(BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info
{
    NSLog(@"%@",peerID.displayName);
    return YES;
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"%@",state==MCSessionStateConnected?@"connected":@"not connected");
}



@end
