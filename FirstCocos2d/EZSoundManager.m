//
//  EZSoundManager.m
//  SpaceViking
//
//  Created by Apple on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZSoundManager.h"

@implementation EZSoundManager
@synthesize isMusicON;
@synthesize isSoundEffectsON;
@synthesize managerSoundState;
@synthesize listOfSoundEffectFiles;
@synthesize soundEffectsState;


static EZSoundManager* _sharedSoundManager = nil;

+(EZSoundManager*)sharedSoundManager {
    if(!_sharedSoundManager) {                                   // 3
        EZDEBUG(@"Initilize soundMgr");
        _sharedSoundManager = [[self alloc] init]; 
    }
    return _sharedSoundManager;                                 // 4
}

/**
 Even alloc could be override. This is a new knowledge.
+(id)alloc 
{
    @synchronized ([EZSoundManager class])                            // 5
    {
        NSAssert(_sharedSoundManager == nil,
                 @"Attempted to allocated a second instance of the Game Manager singleton");                                          // 6
        _sharedSoundManager = [super alloc];
        return _sharedSoundManager;                                 // 7
    }
    return nil;  
}

**/

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

-(void)stopSoundEffect:(ALuint)soundEffectID {
    if (managerSoundState == kAudioManagerReady) {
        [soundEngine stopEffect:soundEffectID];
    }
}

-(ALuint)playSoundEffect:(NSString*)soundEffectKey {
    ALuint soundID = 0;
    if (managerSoundState == kAudioManagerReady) {
        //NSNumber *isSFXLoaded = [soundEffectsState objectForKey:soundEffectKey];
        //if ([isSFXLoaded boolValue] == SFX_LOADED) {
        EZDEBUG(@"Load before playing effect");
        //[soundEngine preloadEffect:soundEffectKey];
        soundID = [soundEngine playEffect:soundEffectKey];
        //} else {
            EZDEBUG(@"Playing: %@",soundEffectKey);
        //}
    } else {
        EZDEBUG(@"GameMgr: Sound Manager is not ready, cannot play %@", soundEffectKey);
    }
    return soundID;
}

-(void)loadSoundEffects:(NSArray*)effectsFiles
{
    EZDEBUG(@"Load sound effects:%i", effectsFiles.count);
    for(NSString* fileName in effectsFiles){
        [soundEngine preloadEffect:fileName];
    }
}

//-(NSDictionary *)getSoundEffectsListForSceneWithID:(SceneTypes)sceneID {
    /*
    NSString *fullFileName = @"SoundEffects.plist";
    NSString *plistPath;
    
    // 1: Get the Path to the plist file
    NSString *rootPath = 
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                         NSUserDomainMask, YES) 
     objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] 
                     pathForResource:@"SoundEffects" ofType:@"plist"];
    }
    
    // 2: Read in the plist file
    NSDictionary *plistDictionary = 
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // 3: If the plistDictionary was null, the file was not found.
    if (plistDictionary == nil) {
        EZDEBUG(@"Error reading SoundEffects.plist");
        return nil; // No Plist Dictionary or file found
    }
    
    // 4. If the list of soundEffectFiles is empty, load it
    if ((listOfSoundEffectFiles == nil) || 
        ([listOfSoundEffectFiles count] < 1)) {
        NSLog(@"Before");
        [self setListOfSoundEffectFiles:
         [[NSMutableDictionary alloc] init]];
        NSLog(@"after");
        for (NSString *sceneSoundDictionary in plistDictionary) {
            [listOfSoundEffectFiles 
             addEntriesFromDictionary:
             [plistDictionary objectForKey:sceneSoundDictionary]];
        }
        EZDEBUG(@"Number of SFX filenames:%d", 
              [listOfSoundEffectFiles count]);
    }
    
    // 5. Load the list of sound effects state, mark them as unloaded
    if ((soundEffectsState == nil) || 
        ([soundEffectsState count] < 1)) {
        [self setSoundEffectsState:[[NSMutableDictionary alloc] init]];
        for (NSString *SoundEffectKey in listOfSoundEffectFiles) {
            [soundEffectsState setObject:[NSNumber numberWithBool:SFX_NOTLOADED] forKey:SoundEffectKey];
        }
    }
    
    // 6. Return just the mini SFX list for this scene
    NSString *sceneIDName = [self formatSceneTypeToString:sceneID];
    NSDictionary *soundEffectsList = 
    [plistDictionary objectForKey:sceneIDName];
    
    return soundEffectsList;
    */
//    return nil;
//}

//- (NSString*)formatSceneTypeToString:(SceneTypes)sceneID {
    /**
    NSString *result = nil;
    switch(sceneID) {
        case kNoSceneUninitialized:
            result = @"kNoSceneUninitialized";
            break;
        case kMainMenuScene:
            result = @"kMainMenuScene";
            break;
        case kOptionsScene:
            result = @"kOptionsScene";
            break;
        case kCreditsScene:
            result = @"kCreditsScene";
            break;
        case kIntroScene:
            result = @"kIntroScene";
            break;
        case kLevelCompleteScene:
            result = @"kLevelCompleteScene";
            break;
        case kGameLevel1:
            result = @"kGameLevel1";
            break;
        case kGameLevel2:
            result = @"kGameLevel2";
            break;
        case kGameLevel3:
            result = @"kGameLevel3";
            break;
        case kGameLevel4:
            result = @"kGameLevel4";
            break;
        case kGameLevel5:
            result = @"kGameLevel5";
            break;
        case kCutSceneForLevel2:
            result = @"kCutSceneForLevel2";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected SceneType."];
    }
     **/
//    return nil;
//}


-(void)loadAudioForSceneWithID:(NSNumber*)sceneIDNumber {
    //I can manually release the memory at will.
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    //SceneTypes sceneID = (SceneTypes) [sceneIDNumber intValue];
    // 1
    if (managerSoundState == kAudioManagerInitializing) {
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
    
    if (managerSoundState == kAudioManagerFailed) {
        return; // Nothing to load, CocosDenshion not ready
    }
    
    /**
    NSDictionary *soundEffectsToLoad = 
    [self getSoundEffectsListForSceneWithID:sceneID];
    if (soundEffectsToLoad == nil) { // 2
        EZDEBUG(@"Error reading SoundEffects.plist");
        return;
    }
     **/
    // Get all of the entries and PreLoad // 3
    /**
    for( NSString *keyString in soundEffectsToLoad )
    {
        EZDEBUG(@"\nLoading Audio Key:%@ File:%@", 
              keyString,[soundEffectsToLoad objectForKey:keyString]);
        [soundEngine preloadEffect:
         [soundEffectsToLoad objectForKey:keyString]]; // 3
        // 4
        [soundEffectsState setObject:[NSNumber numberWithBool:SFX_LOADED] forKey:keyString];
        
    }
    **/
    NSString* keyString = @"22k_viking_punchingV1.wav";
    EZDEBUG(@"Loading %@", keyString);
    //[soundEngine preloadEffect:keyString]; // 3
    // 4
    [soundEffectsState setObject:[NSNumber numberWithBool:SFX_LOADED] forKey:keyString];
    
    [pool release];
}

-(void)unloadAudioForSceneWithID:(NSNumber*)sceneIDNumber {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    /**
    SceneTypes sceneID = (SceneTypes)[sceneIDNumber intValue];
    if (sceneID == kNoSceneUninitialized) {
        return; // Nothing to unload
    }
    **/
    
    
    NSDictionary *soundEffectsToUnload = nil;
    /**
    [self getSoundEffectsListForSceneWithID:sceneID];
    if (soundEffectsToUnload == nil) {
        EZDEBUG(@"Error reading SoundEffects.plist");
        return;
    }**/
    if (managerSoundState == kAudioManagerReady) {
        // Get all of the entries and unload
        for( NSString *keyString in soundEffectsToUnload )
        {
            [soundEffectsState setObject:[NSNumber numberWithBool:SFX_NOTLOADED] forKey:keyString];
            [soundEngine unloadEffect:keyString];
            EZDEBUG(@"\nUnloading Audio Key:%@ File:%@", 
                  keyString,[soundEffectsToUnload objectForKey:keyString]);
            
        }
    }
    [pool release];
}




-(void)initAudioAsync {
    // Initializes the audio engine asynchronously
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
        EZDEBUG(@"CocosDenshion failed to init, no audio will play.");
        managerSoundState = kAudioManagerFailed; 
    } else {
        [audioManager setResignBehavior:kAMRBStopPlay autoHandle:YES];
        soundEngine = [SimpleAudioEngine sharedEngine];
        managerSoundState = kAudioManagerReady;
        EZDEBUG(@"CocosDenshion is Ready");
    }
}


-(void)setupAudioEngine {
    if (hasAudioBeenInitialized == YES) {
        return;
    } else {
        hasAudioBeenInitialized = YES; 
        NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
        NSInvocationOperation *asyncSetupOperation = 
        [[NSInvocationOperation alloc] initWithTarget:self 
                                             selector:@selector(initAudioAsync) 
                                               object:nil];
        [queue addOperation:asyncSetupOperation];
        [asyncSetupOperation autorelease];
    }
}

-(id)init {                                                        // 8
    self = [super init];
    if (self != nil) {
        // Game Manager initialized
        EZDEBUG(@"Game Manager Singleton, init");
        isMusicON = YES;
        isSoundEffectsON = YES;
        hasAudioBeenInitialized = NO;
        soundEngine = nil;
        managerSoundState = kAudioManagerUninitialized;
        EZDEBUG(@"Called setupAudioEngine in init method");
        [self setupAudioEngine];
        
    }
    return self;
}




@end
