//
//  WPPeerHost.m
//  Wopi
//
//  Created by Nicholas Peretti on 10/24/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import "WPPeerHost.h"

@interface WPPeerHost() <NSStreamDelegate>

@property (nonatomic, strong) MCPeerID *myPeerID;
@property (nonatomic, strong) MCAdvertiserAssistant *assistant;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) NSInputStream *leftStream;
@property (nonatomic, strong) NSInputStream *rightStream;
@property (nonatomic, strong) NSInputStream *backStream;


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
        
    }
    return self;
}

-(void)startConnecting
{
    _myPeerID = [[MCPeerID alloc] initWithDisplayName:@"Wopi Host"];
    _session = [[MCSession alloc]initWithPeer:_myPeerID];
    [_session setDelegate:self];
    _assistant = [[MCAdvertiserAssistant alloc]initWithServiceType:@"wopi" discoveryInfo:nil session:_session];
    [_assistant start];
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"%@ changed to %@",peerID.displayName,state==MCSessionStateConnecting ? @"connecting" : state==MCSessionStateConnected ? @"connected":@"not connected");
}
-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSLog(@"received stream %@",streamName);
    if ([streamName isEqualToString:@"Left"]) {
        _leftStream = stream;
        _leftStream.delegate = self;
        [_leftStream scheduleInRunLoop:[NSRunLoop mainRunLoop]
                               forMode:NSDefaultRunLoopMode];
        [_leftStream open];
    }
    if ([streamName isEqualToString:@"Back"]) {
        _backStream = stream;
        _backStream.delegate = self;
        [_backStream scheduleInRunLoop:[NSRunLoop mainRunLoop]
                               forMode:NSDefaultRunLoopMode];
        [_backStream open];
        
    }
    if ([streamName isEqualToString:@"Right"]) {
        _rightStream = stream;
        _rightStream.delegate = self;
        [_rightStream scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                forMode:NSDefaultRunLoopMode];
        [_rightStream open];
    }
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSString *sensorData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *parts = [sensorData componentsSeparatedByString:@" "];
    char chanel = [parts[0] characterAtIndex:0];
    CGFloat audiolvl = [parts[1] floatValue];
    if (self.delegate!=nil) {
        [self.delegate gotAudioLvl:audiolvl forChannel:chanel];
    }
    //NSLog(@"%@",sensorData);
    
}


- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    
    switch(eventCode) {
        case NSStreamEventHasBytesAvailable:
        {

            uint8_t audiolevel;
            NSInteger bytesRead = [(NSInputStream *)stream read:&audiolevel maxLength:sizeof(uint8_t)];
            if(bytesRead) {
                NSLog(@"%i",audiolevel);
            } else {
                NSLog(@"no buffer!");
            }
            break;
        }
        case NSStreamEventEndEncountered:
        {
            NSLog(@"ended");
        }
        case NSStreamEventErrorOccurred:
        {
            NSLog(@"stream error");
        }
        case NSStreamEventHasSpaceAvailable:
        {
            NSLog(@"space available");
        }
        case NSStreamEventNone:
        {
            NSLog(@"stream non");
        }
        case NSStreamEventOpenCompleted:
        {
            NSLog(@"stream event completed");
        }
    }
    
}








-(void)advertiserAssistantDidDismissInvitation:(MCAdvertiserAssistant *)advertiserAssistant
{
    NSLog(@"dismiss");
}
-(void)advertiserAssistantWillPresentInvitation:(MCAdvertiserAssistant *)advertiserAssistant
{
    NSLog(@"present");
}
-(void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL))certificateHandler
{
    certificateHandler(YES);
}

@end
