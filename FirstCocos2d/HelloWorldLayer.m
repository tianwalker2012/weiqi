//
//  HelloWorldLayer.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-3.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

#import "Constants.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "EZTouchHelper.h"

#pragma mark - HelloWorldLayer


@interface HelloWorldLayer()
{
    CCSprite* platform;
    CCSprite* whiteBtn;
    CCSprite* blackBtn;
}

@end

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


- (void) onEnter
{
    EZDEBUG(@"onEnter: thread trace:%@", [NSThread callStackSymbols]);
    //id moveAction = [CCMoveTo actionWithDuration:0.5 position:ccp(0,0)];
    //[platform runAction:moveAction];
    //[whiteBtn runAction:moveAction];
    //[blackBtn runAction:moveAction];
}


//When this will get called
- (void) onEnterTransitionDidFinish
{
    EZDEBUG(@"onEnterTransitionDidFinish:%@", [NSThread callStackSymbols]);
    [[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:1];
}

- (void) onExit
{
    EZDEBUG(@"onExit:%@", [NSThread callStackSymbols]);
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		//CGSize size = [CCDirector sharedDirector].winSize;
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
}
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch moved");
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch ended");
}
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch cancelled.");
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
