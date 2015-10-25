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
    SKSpriteNode *playerPaddle;
    SKShapeNode *ball;
    SKSpriteNode *cpuPaddle;
    CGVector ballVelo;
}

-(void)didMoveToView:(SKView *)view
{
    self.backgroundColor = [SKColor blueColor];
    l = 20;
    r = 20;
    b = 20;
    playerPaddle = [SKSpriteNode spriteNodeWithColor:[NSColor whiteColor] size:CGSizeMake(130, 30)];
    [self addChild:playerPaddle];
    [playerPaddle setPosition:CGPointMake(view.bounds.size.width*0.5, 15)];
    rollingX = view.bounds.size.width*0.5;
    ball = [SKShapeNode shapeNodeWithCircleOfRadius:10];
    
    [ball setFillColor:[NSColor whiteColor]];
    [ball setStrokeColor:[NSColor clearColor]];
    [ball setPosition:CGPointMake(self.size.width*0.5, self.size.height*0.5)];
    cpuPaddle = [SKSpriteNode spriteNodeWithColor:[NSColor whiteColor] size:CGSizeMake(130, 30)];
    ballVelo = CGVectorMake(1,1);
    [self addChild:ball];
    [self addChild:cpuPaddle];
    
}

-(void)update:(NSTimeInterval)currentTime
{
    
    //player paddle
    
    CGFloat lr = ((l/r)*self.size.width)-(self.size.width*0.5);
//    CGFloat mids;
//    if (l<r) {
//        CGFloat lb = ((l/b)*self.size.width*0.5)-(self.size.width*0.5);
//        mids = lb;
//    } else {
//        CGFloat br = ((b/r)*self.size.width*0.5)-(self.size.width*0.5);
//        mids = br;
//    }
//    
//    //20 low
//    CGFloat x = (lr * 0.75)+(mids*0.25);
    CGFloat x = lr;
    rollingX = (rollingX *0.99) + (x*0.01);
    [playerPaddle setPosition:CGPointMake(rollingX, 15)];
    
    
    
    
    
    //ball position
    if (ball.position.x+10>=self.size.width)
    {
        ballVelo = CGVectorMake(-ballVelo.dx, ballVelo.dy);
    }
    if (ball.position.x-10<=0) {
        ballVelo = CGVectorMake(-ballVelo.dx, ballVelo.dy);
    }
    if (ball.position.y-10<playerPaddle.position.y+15&&ball.position.y-10>0)
    {
        if(ball.position.x+10>=playerPaddle.position.x-50&&ball.position.x-10<=playerPaddle.position.x+50)
        {
            ballVelo = CGVectorMake(ballVelo.dx, -ballVelo.dy);
        }
    }
    if (ball.position.y+10>cpuPaddle.position.y-15&&ball.position.y+10<self.size.height)
    {
        if(ball.position.x+10>=cpuPaddle.position.x-50&&ball.position.x-10<=cpuPaddle.position.x+50)
        {
            ballVelo = CGVectorMake(ballVelo.dx, -ballVelo.dy);
        }
    }
    ball.position = CGPointMake(ball.position.x+ballVelo.dx, ball.position.y+ballVelo.dy);
    
    [cpuPaddle setPosition:CGPointMake(ball.position.x, self.size.height-15)];
    
    if (ball.position.y>self.size.height+20 || ball.position.y < -20)
    {
        ballVelo = CGVectorMake(0, 0);
        ball.position = CGPointMake(self.size.width*0.5, self.size.height*0.5);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGFloat dx=3;
            CGFloat dy=3;
            if (arc4random()%2<1) {
                dx = -2;
            } else {
                dx = 2;
            }
            
            if (arc4random()%2<1) {
                dy = -2;
            } else {
                dx = 2;
            }
            ballVelo = CGVectorMake(dx, dy);
        });
    }
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
