//
//  AppDelegate.m
//  wopiDesk
//
//  Created by Nicholas Peretti on 10/24/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import "AppDelegate.h"
#import "WPPeerHost.h"

@interface AppDelegate () <WPPeerHostDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) WPPeerHost *host;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.host = [[WPPeerHost alloc]init];
    [self.host setDelegate:self];
    [self.host startConnecting];
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)gotAudioLvl:(CGFloat)lvl forChannel:(char)chanel
{
    
}

@end
