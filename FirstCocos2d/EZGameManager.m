//
//  EZGameObject.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZGameManager.h"


@implementation EZGameManager
@synthesize soundEffectsStates;

static EZGameManager* _sharedGameManager;

+ (EZGameManager*) sharedGameManager
{
    if(_sharedGameManager == nil){
        _sharedGameManager = [[EZGameManager alloc] init];
    }
    
    return _sharedGameManager;
}

/**
-(void)playBackgroundTrack:(NSString*)trackFileName {
    // Wait to make sure soundEngine is initialized
    if ((managerSoundState != kAudioManagerReady) && 
        (managerSoundState != kAudioManagerFailed)) {
        
        int waitCycles = 0;
        while (waitCycles < AUDIO_MAX_WAITTIME) {
            [NSThread sleepForTimeInterval:0.1f];
            if ((managerSoundState == kAudioManagerReady) || 
                (managerSoundState == kAudioManagerFailed)) {
                break;
            }
            waitCycles = waitCycles + 1;
        }
    }
    
    if (managerSoundState == kAudioManagerReady) {
        if ([soundEngine isBackgroundMusicPlaying]) {
            [soundEngine stopBackgroundMusic];
        }
        [soundEngine preloadBackgroundMusic:trackFileName];
        [soundEngine playBackgroundMusic:trackFileName loop:YES];
    }
}
**/
 
 
-(void)stopSoundEffect:(ALuint)soundEffectID {
    if (managerSoundState == kAudioManagerReady) {
        [soundEngine stopEffect:soundEffectID];
    }
}

//Will preload the files for later usage.
//The loaded file will stored to the mapping file.
//If not preloaded, I will not play it.
- (void) preloadFiles:(NSArray*)files
{
    for(NSString* fileName in files){
        EZDEBUG(@"Loaded sound file:%@, soundEngine:%i", fileName, (int)soundEngine);
        [soundEngine preloadEffect:fileName];
        [soundEffectsStates setValue:[[NSNumber alloc] initWithInt:SFX_LOADED] forKey:fileName];
    }
    
}

-(ALuint)playSoundEffect:(NSString*)soundEffectKey {
    ALuint soundID = 0;
    if (managerSoundState == kAudioManagerReady) {
        NSNumber *isSFXLoaded = [soundEffectsStates objectForKey:soundEffectKey];
        //if ([isSFXLoaded boolValue] == SFX_LOADED) {
            soundID = [soundEngine playEffect:soundEffectKey];
        //} else {
            EZDEBUG(@"GameMgr: SoundEffect %@  played, id:%i, soundEngine:%i",soundEffectKey, soundID, (int)soundEngine);
        //}
    } else {
        EZDEBUG(@"GameMgr: Sound Manager is not ready, cannot play %@", soundEffectKey);
    }
    return soundID;
}


-(void)initAudioAsync {
    // Initializes the audio engine asynchronously
    EZDEBUG(@"start initialize the audio");
    managerSoundState = kAudioManagerInitializing; 
    // Indicate that we are trying to start up the Audio Manager
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    
    //Init audio manager asynchronously as it can take a few seconds
    //The FXPlusMusicIfNoOtherAudio mode will check if the user is
    // playing music and disable background music playback if 
    // that is the case.
    [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
    
    //Wait for the audio manager to initialise
    while ([CDAudioManager sharedManagerState] != kAMStateInitialised) 
    {
        [NSThread sleepForTimeInterval:0.1];
    }
    
    //At this point the CocosDenshion should be initialized
    // Grab the CDAudioManager and check the state
    CDAudioManager *audioManager = [CDAudioManager sharedManager];
    if (audioManager.soundEngine == nil || 
        audioManager.soundEngine.functioning == NO) {
        CCLOG(@"CocosDenshion failed to init, no audio will play.");
        managerSoundState = kAudioManagerFailed; 
    } else {
        [audioManager setResignBehavior:kAMRBStopPlay autoHandle:YES];
        soundEngine = [SimpleAudioEngine sharedEngine];
        managerSoundState = kAudioManagerReady;
        CCLOG(@"CocosDenshion is Ready");
    }
}


-(void)setupAudioEngine {
    if (hasAudioBeenInitialized == YES) {
        return;
    } else {
        hasAudioBeenInitialized = YES; 
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *asyncSetupOperation = 
        [[NSInvocationOperation alloc] initWithTarget:self 
                                             selector:@selector(initAudioAsync) 
                                               object:nil];
        [queue addOperation:asyncSetupOperation];
        //[asyncSetupOperation autorelease];
    }
}

-(id)init {                                                        // 8
    self = [super init];
    if (self != nil) {
        // Game Manager initialized
        CCLOG(@"Game Manager Singleton, init");
        isMusicON = YES;
        isSoundEffectsON = YES;
        //hasPlayerDied = NO;
        //currentScene = kNoSceneUninitialized;
        hasAudioBeenInitialized = NO;
        soundEngine = nil;
        managerSoundState = kAudioManagerUninitialized;
        soundEffectsStates = [[NSMutableDictionary alloc] init];
        [self setupAudioEngine];
        
    }
    return self;
}




@end
