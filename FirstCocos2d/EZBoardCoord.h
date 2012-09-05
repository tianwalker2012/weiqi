//
//  EZBoardCoord.h
//  FirstCocos2d
//
//  Created by Apple on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZBoardCoord : NSObject


@property(assign, nonatomic) short width;
@property(assign, nonatomic) short height;

- (id) init:(short)width height:(short)height;

@end
