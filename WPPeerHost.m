//
//  WPPeerHost.m
//  Wopi
//
//  Created by Nicholas Peretti on 10/24/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import "WPPeerHost.h"

@interface WPPeerHost()

@property (nonatomic, strong) MCPeerID *myPeerID;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;

@end

@implementation WPPeerHost
{
    NSMutableArray *sessions;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.myPeerID = [[MCPeerID alloc] initWithDisplayName:@"Wopi Host"];
        self.advertiser =
        [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.myPeerID
                                          discoveryInfo:nil
                                            serviceType:@"wopi"];
        self.advertiser.delegate = self;
        [self.advertiser startAdvertisingPeer];
        sessions = [NSMutableArray new];
        NSLog(@"advertising");
        
    }
    return self;
}


- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser
didReceiveInvitationFromPeer:(MCPeerID *)peerID
       withContext:(NSData *)context
 invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    
    NSLog(@"invited");
    MCSession *session = [[MCSession alloc] initWithPeer:self.myPeerID
                             securityIdentity:nil
                         encryptionPreference:MCEncryptionNone];
    session.delegate = self;
    [sessions addObject:session];
    invitationHandler(YES,session);
    
}
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"%@ changed to %@",peerID.displayName,state==MCSessionStateConnecting ? @"connecting" : state==MCSessionStateConnected ? @"connected":@"not connected");
}
-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    

}
-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"%@",error);
}


@end
