//
//  EZGameObject.h
//  FirstCocos2d
//
//  Created by Apple on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"

@interface EZGameManager : NSObject
{
    BOOL isMusicON;
    BOOL isSoundEffectsON;
    //BOOL hasPlayerDied;
    //SceneTypes currentScene;
    
    // Added for audio
    BOOL hasAudioBeenInitialized;
    GameManagerSoundState managerSoundState;
    SimpleAudioEngine *soundEngine;
    
    //Keep it simple and stupid.
    //You give a list of files
    //NSMutableDictionary* soundEffectsStates;
}

@property (nonatomic, retain) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, retain) NSMutableDictionary *soundEffectsStates;


+ (EZGameManager*) sharedGameManager;
- (void) setupAudioEngine;
- (ALuint) playSoundEffect:(NSString*)soundEffectFile;
- (void) stopSoundEffect:(ALuint)soundEffectID;
- (void) playBackgroundTrack:(NSString*)trackFileName;

//Will preload the files for later usage.
//The loaded file will stored to the mapping file.
//If not preloaded, I will not play it.
- (void) preloadFiles:(NSArray*)files;


@end
