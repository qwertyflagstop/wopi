//
//  WPPlayerScene.m
//  Wopi
//
//  Created by Matthew Meehan on 10/24/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import "WPPlayerScene.h"

@implementation WPPlayerScene
{
    CGFloat rollingX;
    CGFloat l;
    CGFloat r;
    CGFloat b;
    SKSpriteNode *point;
}

-(void)didMoveToView:(SKView *)view
{
    self.backgroundColor = [SKColor blueColor];
    l = 20;
    r = 20;
    b = 20;
    point = [SKSpriteNode spriteNodeWithColor:[NSColor whiteColor] size:CGSizeMake(20, 20)];
    [self addChild:point];
    [point setPosition:CGPointMake(view.bounds.size.width*0.5, view.bounds.size.height*0.5)];
    rollingX = view.bounds.size.width*0.5;
}

-(void)update:(NSTimeInterval)currentTime
{
    CGFloat x = ((l/r)*self.size.width)-(self.size.width*0.5);
    rollingX = (rollingX *0.9) + (x*0.1);
    [point setPosition:CGPointMake(rollingX, self.size.height*0.5)];
}

-(void)updateAudioLvl:(CGFloat)lvl forChannel:(char)channel
{
    switch (channel) {
        case 'L':
            l=lvl;
            break;
        case 'R':
            r=lvl;
            break;
        case 'B':
            b=lvl;
            break;
        default:
            break;
    }
}

@end
