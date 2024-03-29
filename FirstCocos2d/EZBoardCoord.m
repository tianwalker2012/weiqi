//
//  EZBoardCoord.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZBoardCoord.h"

@implementation EZBoardCoord
@synthesize width, height;

- (id) init:(short)wd height:(short)ht
{
    self = [super init];
    if(self != nil){
        width = wd;
        height = ht;
    }
    
    return self;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"width:%i, height:%i",width ,height];
}

//Can be stored as a short or convert from short
+ (id) fromNumber:(short)val
{
    return [[EZBoardCoord alloc] init:(val >> 8) height:val & 0xff];
}

- (short) toNumber
{
    return (width << 8) + height;
}

- (NSString*) getKey
{
    return [NSString stringWithFormat:@"%i", [self toNumber]];
}

@end
