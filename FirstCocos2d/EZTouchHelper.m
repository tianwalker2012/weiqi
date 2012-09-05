//
//  EZTouchHelper.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTouchHelper.h"

@implementation EZTouchHelper

@end

@implementation UITouch(EZWeiqi)


//Return the point in GL
- (CGPoint) locationInGL
{
    return [[CCDirector sharedDirector] convertToGL:[self locationInView:self.view]];
}
@end


@implementation CCNode(EZWeiqi)

- (CGPoint) locationInSelf:(UITouch*)touch
{
    return [self convertToNodeSpace:[touch locationInGL]];
}

@end