//
//  AppDelegate.m
//  wopiDesk
//
//  Created by Nicholas Peretti on 10/24/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import "AppDelegate.h"
#import <SpriteKit/SpriteKit.h>
#import "WPPlayerScene.h"

@interface AppDelegate (){
    //NSTextView *label;
    SKView *myView;
    WPPlayerScene *playerScene;
}

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) WPPeerHost *host;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.host = [[WPPeerHost alloc]init];
    
    // Insert code here to initialize your application
    
    myView = [[SKView alloc]initWithFrame:self.window.contentView.bounds];
    self.window.delegate = self;
    [self.window.contentView addSubview:myView];
    playerScene = [[WPPlayerScene alloc] initWithSize:self.window.contentView.bounds.size];
    
    [myView presentScene:playerScene];
    
}

-(void)windowDidEndLiveResize:(NSNotification *)notification
{
    [myView setFrameSize:self.window.contentView.bounds.size];
    [playerScene setSize:self.window.contentView.bounds.size];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
