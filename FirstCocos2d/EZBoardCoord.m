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


@end
