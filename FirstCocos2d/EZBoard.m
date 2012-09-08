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
#import "EZBoardStatus.h"
#import "EZBoardCoord.h"
#import "EZResponsiveRegion.h"
#import "EZSoundManager.h"


#define PUT_CHESS_SOUND @"chess-plant.wav"

@interface EZBoard()
{
    CCSprite* board;
    CCSprite* virtualWhite;
    CCSprite* virtualBlack;
    
    //Accoring to it's name, my goal is to keep all the status within this class/
    //Put is simple, the purpose of this class is to decouple the logic with the UI class to simplifying the test.
    EZBoardStatus* status;
    
    EZResponsiveRegion* regretButton;
    
    NSMutableDictionary* coordToButtons;
}

//What's responsibility of this method?
//Make the cursor.
- (void) putCursorButton:(CGPoint)point;

//Remove the cursor as the name implied.
- (void) removeCursorButton;

- (void) moveCursorButton:(CGPoint)point;

- (void) initializeCursor;

- (void) regret;


@end

@implementation EZBoard


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EZBoard *layer = [EZBoard node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    //[scene addChild:<#(CCNode *)#>
	
	// return the scene
	return scene;
}
//When this will get called
- (void) onEnterTransitionDidFinish
{
    EZDEBUG(@"onEnterTransitionDidFinish");
    //Manually call it. 
    //[[EZGameManager sharedGameManager] preloadFiles:[NSArray arrayWithObjects:@"enemy.wav",@"chess-plant.wav", nil]];
    
    //PLAYSOUNDEFFECT(@"chess-plant.wav");
    [[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:2];
     [regretButton onEnterTransitionDidFinish];
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
        coordToButtons = [[NSMutableDictionary alloc] initWithCapacity:100];
        EZDEBUG(@"BoundingBox is:%@", NSStringFromCGRect(self.boundingBox));
        status = [[EZBoardStatus alloc] initWithSize:CGRectMake(0, 0, size.width, size.height) lineGap:36 totalLines:19];
        status.front = self;
        
        board = [CCSprite spriteWithFile:BoardFileName];
        //platform.boundingBox.size
        [board setPosition:ccp(size.width/2, size.height/2)];
        [board setZOrder:-1];
        
        [self addChild:board];
        [self initializeCursor];
        
        //Add a regret button. 
        //Reuse the Chess image for time being, will add 
        
        
        //Add clean all button
        [CCMenuItemFont setFontSize:32];
        CCMenuItem* cleanAllItem = [CCMenuItemFont itemWithString:@"重新开始" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene: [EZBoard scene]];

        }];
        
        CCMenuItem* regretItem = [CCMenuItemFont itemWithString:@"悔棋" block:^(id sender){
            [self regret];
        }];
        
        CCMenu* menu = [CCMenu menuWithItems:cleanAllItem, nil];
        [menu alignItemsVertically];
        menu.position = ccp(60, 700);
        [self addChild:menu z:-2];
        
        CCMenu* regMenu = [CCMenu menuWithItems:regretItem, nil];
        [regMenu alignItemsVertically];
        regMenu.position = ccp(50, 500);
        [self addChild:regMenu z:-2];
        
        [[EZSoundManager sharedSoundManager]loadSoundEffects:[NSArray arrayWithObject:@"chess-plant.wav"]];
        
        NSLog(@"Is Touch enabled:%@", self.isTouchEnabled?@"Yes":@"No");
        
        
	}
	return self;
}

- (void) addRegretButton
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    regretButton = [[EZResponsiveRegion alloc] initWithRect:CGRectMake(0, (size.height - 76)/2, 76, 76)];
    
    regretButton.pressedOps = ^(){
        [self regret];
    };
    regretButton.normal = [CCSprite spriteWithSpriteFrameName:WhiteBtnName];
    regretButton.pressed = [CCSprite spriteWithSpriteFrameName:BlackBtnName];
    regretButton.normal.scale = 2.0;
    regretButton.pressed.scale = 2.0;
    regretButton.normal.position = regretButton.center;
    regretButton.pressed.position = regretButton.center;
    [regretButton addChild:regretButton.normal];
    
    [self addChild:regretButton];
}

- (void) regret
{
    EZDEBUG(@"Regret get called");
    [status regretOneStep];
}

- (void) initializeCursor
{
    virtualWhite = [CCSprite spriteWithFile:WhiteBtnName];
    virtualBlack = [CCSprite spriteWithFile:BlackBtnName];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:virtualWhite.displayFrame name:WhiteBtnName];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:virtualBlack.displayFrame name:BlackBtnName];
    //[whiteBtn setPosition:ccp(size.width/2+36, size.height/2)];
    [virtualBlack setZOrder:FloatingZOrder];
    [virtualWhite setZOrder:FloatingZOrder];
    
    virtualWhite.opacity = 128;
    virtualBlack.opacity = 128;
    virtualBlack.scale = 2.0;
    virtualWhite.scale = 2.0;
}


//Clean all the button on the board, animated or not.
- (void) cleanAllButton:(BOOL)animated
{
    //add later
}

//Coord is better and more stable than point
- (void) clean:(EZBoardCoord*)coord animated:(BOOL)animated
{
    EZDEBUG(@"Will clean the button for coord:%@", coord);
    CCSprite* btn = [coordToButtons objectForKey:coord.getKey];
    [btn removeFromParentAndCleanup:YES];
    [coordToButtons removeObjectForKey:coord.getKey];
}

- (void) putButton:(EZBoardCoord*)coord isBlack:(BOOL)isBlack animated:(BOOL)animated
{
    //Let's check it on iPad

    CGPoint pt = [status bcToPoint:coord];
    EZDEBUG(@"Button on:%@", NSStringFromCGPoint(pt));
    CCSprite* btn = nil;
    if(isBlack){
        btn = [CCSprite spriteWithSpriteFrameName:BlackBtnName];
    }else{
        btn = [CCSprite spriteWithSpriteFrameName:WhiteBtnName];
    }
    [btn setZOrder:FixedZOrder];
    [btn setPosition:pt];
    [coordToButtons setValue:btn forKey:coord.getKey];
    [self addChild:btn];
}

//What's responsibility of this method?
//Make the cursor.
- (void) putCursorButton:(CGPoint)regularizedPt
{
    if(status.isCurrentBlack){
        [virtualBlack setPosition:regularizedPt];
        [self addChild:virtualBlack];
    }else{
        [virtualWhite setPosition:regularizedPt];
        [self addChild:virtualWhite];
    }

}

- (void) moveCursorButton:(CGPoint)point
{
    if(status.isCurrentBlack){
        [virtualBlack setPosition:point];
    }else{
        [virtualWhite setPosition:point];
    }
}


//Remove the cursor as the name implied.
- (void) removeCursorButton
{
    if(status.isCurrentBlack){
        [virtualBlack removeFromParentAndCleanup:YES];
    }else{
        [virtualWhite removeFromParentAndCleanup:YES];
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //EZDEBUG(@"Touch begin, touched point:%i", touches.count);
    UITouch* touchPoint = touches.anyObject;
    CGPoint globalPoint = [touchPoint locationInGL];
    CGPoint localPoint = [self locationInSelf:touchPoint];
    CGPoint regularizedPt = [status adjustLocation:localPoint];
    EZDEBUG(@"Touch begin global GL:%@, local GL:%@, ajusted: %@", NSStringFromCGPoint(globalPoint), NSStringFromCGPoint(localPoint), NSStringFromCGPoint(regularizedPt));
        
    [self putCursorButton:regularizedPt];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //EZDEBUG(@"Touch moved");
    UITouch* touchPoint = touches.anyObject;
    CGPoint localPoint = [self locationInSelf:touchPoint];
    CGPoint regularizedPt = [status adjustLocation:localPoint];
    EZDEBUG(@"Move local GL:%@, ajusted: %@", NSStringFromCGPoint(localPoint), NSStringFromCGPoint(regularizedPt));
    [self moveCursorButton:regularizedPt];
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch* touchPoint = touches.anyObject;
    CGPoint localPoint = [self locationInSelf:touchPoint];
    CGPoint regularizedPt = [status adjustLocation:localPoint];
    EZDEBUG(@"Touch ended at:%@, adjusted: %@", NSStringFromCGPoint(localPoint), NSStringFromCGPoint(regularizedPt));
    [self removeCursorButton];
    [status putButton:localPoint];
    PLAYSOUNDEFFECT(chess-plant.wav);
    
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch cancelled.");
    [virtualBlack removeFromParentAndCleanup:YES];
}

@end
