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
    MCSessionState constate;
    NSOutputStream *outputStream;
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
        _browserVC.delegate = self;
        constate = MCSessionStateNotConnected;
        outputStream = nil;
    }
    return self;
}

-(void)sendAudio:(float)audioLvl forPosition:(WPPeerPosition)pos
{
    
 
        
        
        MCPeerID *hostPeer;
        for (MCPeerID *peer in session.connectedPeers) {
            if ([peer.displayName isEqualToString:@"Wopi Host"]) {
                hostPeer = peer;
                break;
            }
        }
        if (!hostPeer) {
            return;
        }
        
        char p = 'L';
        if (pos == kTopLeft) {
            p = 'L';
        }
        if (pos == kTopRight) {
            p = 'R';
        }
        if (pos == kBack) {
            p = 'B';
        }
        NSString *sensorDat = [NSString stringWithFormat:@"%c %2.2f",p,audioLvl];
        NSError *erro;
        [session sendData:[sensorDat dataUsingEncoding:NSUTF8StringEncoding] toPeers:@[hostPeer] withMode:MCSessionSendDataUnreliable error:&erro];
        if (erro) {
            NSLog(@"%@",erro);
        }
    
    
}

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    
}

-(BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info
{
    NSLog(@"%@",peerID.displayName);
    return YES;
}
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"done" object:nil]];
}
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"done" object:nil]];
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    constate = state;
    NSLog(@"%@",state==MCSessionStateConnected?@"connected":@"not connected");
}



@end
