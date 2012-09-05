//
//  EZBoardStatus.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZBoardStatus.h"
#import "EZBoardCoord.h"


@interface EZBoardStatus()
{
    //Will calculate the real rect.
    CGRect boardRect;
}

- (CGRect) calcInnerRect;

- (EZBoardCoord*) pointToBC:(CGPoint)pt;

- (CGPoint) bcToPoint:(EZBoardCoord*)bd;

- (short) lengthToGap:(CGFloat)len gap:(CGFloat)gap lines:(NSInteger)lines;


@end

@implementation EZBoardStatus
@synthesize lineGap, totalLines, bounds;

//I made an assumption, that is the board is center aligned.
//And the board are smaller or equal with the bounds. 
//If this assumption are voilated, something wired may happen.\
//Assume each cell is cubic.
- (id) initWithSize:(CGRect)bd lineGap:(CGFloat)gap totalLines:(NSInteger)tl
{
    self = [super init];
    if(self){
        lineGap = gap;
        bounds = bd;
        totalLines = tl;
        boardRect = [self calcInnerRect];
    }
    return self;
}

- (CGRect) calcInnerRect
{
    CGFloat width = (totalLines-1)* lineGap;
    return CGRectMake(bounds.origin.x + (bounds.size.width - width)/2, bounds.origin.y + (bounds.size.height - width)/2, width, width);
}

//Cool, Let's test it later.
//Feed my rabbit now.
- (CGPoint) adjustLocation:(CGPoint)point
{
    CGPoint adjusted = CGPointMake(point.x - boardRect.origin.x, point.y - boardRect.origin.y);
    return [self bcToPoint:[self pointToBC:adjusted]];
}


- (short) lengthToGap:(CGFloat)len gap:(CGFloat)gap lines:(NSInteger)lines
{
    short wd = len/gap;
    //NSInteger xInt = len;
    short remain = (NSInteger)len % (NSInteger)gap;
    if(remain > (gap/2)){
        ++wd; 
    }
    if(wd < 0){
        wd = 0;
    }else if(wd >= lines){
        wd = lines - 1;
    }
    return wd;
}

- (EZBoardCoord*) pointToBC:(CGPoint)pt
{
    short wd = [self lengthToGap:pt.x gap:lineGap lines:totalLines];
    short ht = [self lengthToGap:pt.y gap:lineGap lines:totalLines];
    return [[EZBoardCoord alloc] init:wd height:ht];
}

- (CGPoint) bcToPoint:(EZBoardCoord*)bd
{
    return CGPointMake(boardRect.origin.x + bd.width * lineGap, boardRect.origin.y + bd.height * lineGap);
}


@end
