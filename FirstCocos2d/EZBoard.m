//
//  EZBoard.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZBoard.h"
#import "Constants.h"
#import "EZTouchHelper.h"
#import "ImageResources.h"

@interface EZBoard()
{
    CCSprite* board;
    CCSprite* virtualWhite;
    CCSprite* virtualBlack;
}

@end

@implementation EZBoard


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [[CCScene alloc] init];
	
	// 'layer' is an autorelease object.
	EZBoard *layer = [[EZBoard alloc] init];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
//When this will get called
- (void) onEnterTransitionDidFinish
{
    EZDEBUG(@"onEnterTransitionDidFinish");
    [[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:2];
}

- (void) onExit
{
    EZDEBUG(@"onExit");
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		CGSize size = [CCDirector sharedDirector].winSize;
        //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"firstalas.plist" textureFilename:@"firstalas.png"];
        //CCSpriteBatchNode* bNode = [CCSpriteBatchNode batchNodeWithFile:@"firstalas.png"];
        //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:<#(CCSpriteFrame *)#> name:<#(NSString *)#>];
        
        
        board = [CCSprite spriteWithFile:BoardFileName];
        //whiteBtn = [CCSprite spriteWithSpriteFrameName:@"white-btn.png"];//[CCSprite spriteWithFile:@"white-btn.png"];
        //blackBtn = [CCSprite spriteWithFile:@"black-btn.png"];
        //blackBtn = [CCSprite spriteWithSpriteFrameName:@"black-btn.png"];
        virtualWhite = [CCSprite spriteWithFile:WhiteBtnName];
        virtualBlack = [CCSprite spriteWithFile:BlackBtnName];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:virtualWhite.displayFrame name:WhiteBtnName];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:virtualBlack.displayFrame name:BlackBtnName];
        
        //platform.boundingBox.size
        [board setPosition:ccp(size.width/2, size.height/2)];
        [board setZOrder:-1];
        
        
        //[whiteBtn setPosition:ccp(size.width/2+36, size.height/2)];
        [virtualBlack setZOrder:FloatingZOrder];
        [virtualWhite setZOrder:FloatingZOrder];
        
        virtualWhite.opacity = 128;
        virtualBlack.opacity = 128;
        virtualBlack.scale = 2.0;
        virtualBlack.scale = 2.0;
        //[blackBtn setPosition:ccp(size.width/2 - 36, size.height/2)];
        //[blackBtn setZOrder:15];
        //[virtualBlack release];
        [self addChild:board];
        //[self addChild:whiteBtn];
        //[self addChild:blackBtn];
        //self.isTouchEnabled = true;
        NSLog(@"Is Touch enabled:%@", self.isTouchEnabled?@"Yes":@"No");
        
        
	}
	return self;
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch begin, touched point:%i", touches.count);
    UITouch* touchPoint = touches.anyObject;
    CGPoint globalPoint = [touchPoint locationInGL];
    CGPoint localPoint = [self locationInSelf:touchPoint];
    EZDEBUG(@"global GL:%@, local GL:%@", NSStringFromCGPoint(globalPoint), NSStringFromCGPoint(localPoint));
    [virtualBlack setPosition:localPoint];
    [self addChild:virtualBlack];
    
}
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch moved");
    UITouch* touchPoint = touches.anyObject;
    CGPoint localPoint = [self locationInSelf:touchPoint];
    [virtualBlack setPosition:localPoint];
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch* touchPoint = touches.anyObject;
    CGPoint localPoint = [self locationInSelf:touchPoint];
    EZDEBUG(@"Touch ended at:%@", NSStringFromCGPoint(localPoint));
    [virtualBlack removeFromParentAndCleanup:YES];
    //CCSprite* addedBtn = [CCSprite spriteWithSpriteFrameName:BlackBtnName];
    
    CCSprite* addedBtn = [CCSprite spriteWithFile:BlackBtnName];
    //[addedBtn setZOrder:FixedZOrder];
    [addedBtn setPosition:localPoint];
    [self addChild:addedBtn];
    
}
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch cancelled.");
    [virtualBlack removeFromParentAndCleanup:YES];
}

@end
