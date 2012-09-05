//
//  EZBoard.h
//  FirstCocos2d
//
//  Created by Apple on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#define FloatingZOrder 100
#define FixedZOrder 15
//What's the purpose of this class?
//Why I create a layer for the board?
//When user touch this board, the lay button logic check will get invoked.
//1. Whether we lay white button or black button?
//2. Where to put that button?
//3. What will happen after that button have laid?
//This is like a UI for all the lay button funtionality.
//For current stage, I will put all the logic here, later I will refactor them 
//Out to place suitable for them.
@interface EZBoard : CCLayer<CCTouchDelegate>

+(CCScene *) scene;

@end
