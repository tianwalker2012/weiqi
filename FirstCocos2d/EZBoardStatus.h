//
//  EZBoardStatus.h
//  FirstCocos2d
//
//  Created by Apple on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//What's the purpose of this class?
//The checking logic and position conversion logic get processed here. 
//Why decouple the position checking logic with the EZBoard?
//Keey thing simple and stupid.
//Now I assume the responsibility for this class is to check the correct position for the 
@interface EZBoardStatus : NSObject

@property (assign, nonatomic) CGFloat lineGap;

//May have board which support fewer lines
@property (assign, nonatomic) NSInteger totalLines;

@property (assign, nonatomic) CGRect bounds;


- (id) initWithSize:(CGRect)bounds lineGap:(CGFloat)gap totalLines:(NSInteger)totalLines; 

- (CGPoint) adjustLocation:(CGPoint)point;

@end
