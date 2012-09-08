//
//  TestSuites.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TestSuites.h"
#import "Constants.h"
#import "EZBoardStatus.h"
#import "EZBoardCoord.h"


//Without test, without confidence. 
//Without confidence, without trust.
//Without trust, without intimate relationship
//Without initmate relationship, without feeling
//Lack of feeling, you didn't put yourself into your product.
//Without put yourself into your product, your product will die out of mal-nourishment.
@interface TestSuites()

+ (void) testThisSuite;

+ (void) testEZBoardStatus;

+ (void) testCoordConversion;

+ (void) testAvNeighbor;

@end

@implementation TestSuites  



+ (void) runAllTests
{
    //[TestSuites testAvNeighbor];
    //[TestSuites testCoordConversion];
    //[TestSuites testThisSuite];
    //[TestSuites testEZBoardStatus];
}

+ (void) testAvNeighbor
{
    EZBoardStatus* bd = [[EZBoardStatus alloc] initWithSize:CGRectMake(0, 0, 30, 30) lineGap:3 totalLines:10];
    EZBoardCoord* coord = [[EZBoardCoord alloc] init:0 height:0];
    NSArray* neigbors = [bd availableNeigbor:coord];
    EZDEBUG(@"Neigbors count %i", neigbors.count);
    assert(neigbors.count == 2);
    EZBoardCoord* plusX = [neigbors objectAtIndex:0];
    EZBoardCoord* plusY = [neigbors objectAtIndex:1];
    
    assert(plusX.width == 1 && plusX.height == 0);
    assert(plusY.width == 0 && plusY.height == 1);
    
    
    
    coord = [[EZBoardCoord alloc] init:0 height:2];
    neigbors = [bd availableNeigbor:coord];
    assert(neigbors.count == 3);
    EZBoardCoord* minusY = [neigbors objectAtIndex:0];
    EZBoardCoord* minusX = nil;
    plusX = [neigbors objectAtIndex:1];
    plusY = [neigbors objectAtIndex:2];
    
    EZDEBUG(@"org:%@,PlusX:%@, plusY:%@, minusY:%@",coord, plusX, plusY, minusY);
    
    assert(plusX.width == 1 && plusX.height == coord.height);
    assert(plusY.width == 0 && plusY.height == coord.height + 1);
    assert(minusY.width == 0 && minusY.height == coord.height - 1);
    
    
    coord = [[EZBoardCoord alloc] init:9 height:9];
    neigbors = [bd availableNeigbor:coord];
    assert(neigbors.count == 2);
    
    coord = [[EZBoardCoord alloc] init:2 height:9];
    neigbors = [bd availableNeigbor:coord];
    assert(neigbors.count == 3);
    
    coord = [[EZBoardCoord alloc] init:2 height:2];
    neigbors = [bd availableNeigbor:coord];
    assert(neigbors.count == 4);
    
    //Strictly speak, this test case is bad,
    //Because it depends on the internal implementation
    //This is for the convinience of my test
    minusX = [neigbors objectAtIndex:0];
    minusY = [neigbors objectAtIndex:1];
    plusX = [neigbors objectAtIndex:2];
    plusY = [neigbors objectAtIndex:3];
    
    EZDEBUG(@"org:%@,PlusX:%@, plusY:%@, minusY:%@, minuX:%@",coord, plusX, plusY, minusY, minusX);
    
    assert(plusX.width == coord.width+1 && plusX.height == coord.height);
    assert(plusY.width == coord.width && plusY.height == coord.height + 1);
    assert(minusY.width == coord.width && minusY.height == coord.height - 1);
    assert(minusX.width == coord.width-1 && minusX.height == coord.height);
    
    assert(false);
}

+ (void) testCoordConversion
{
    EZBoardCoord* bd = [[EZBoardCoord alloc] init:1 height:2];
    short converted = [bd toNumber];
    EZDEBUG(@"The converted:%i", converted);
    assert(converted == 258);
    
    bd = [EZBoardCoord fromNumber:514];
    assert(bd.width == 2);
    assert(bd.height == 2);
    
   // assert(false);
    
}

//Test is ok.
//Let's integrate with the code and check how's going.
+ (void) testEZBoardStatus
{
    EZBoardStatus* bds = [[EZBoardStatus alloc] initWithSize:CGRectMake(5, 5, 25, 25) lineGap:5 totalLines:4];
    CGPoint adjusted = [bds adjustLocation:CGPointMake(7, 7)];
    EZDEBUG(@"Org:%@ , Adjusted: %@",NSStringFromCGPoint(CGPointMake(7, 7)), NSStringFromCGPoint(adjusted));
    assert(adjusted.x == 10);
    assert(adjusted.y == 10);
    
    adjusted = [bds adjustLocation:CGPointMake(13, 13)];
    EZDEBUG(@"Org:%@, Adjusted: %@", NSStringFromCGPoint(CGPointMake(13, 13)), NSStringFromCGPoint(adjusted));
    
    assert(adjusted.x == 15);
    assert(adjusted.y == 15);
    
    
    adjusted = [bds adjustLocation:CGPointMake(23, 23)];
    EZDEBUG(@"Org:%@, Adjusted: %@", NSStringFromCGPoint(CGPointMake(23, 23)), NSStringFromCGPoint(adjusted));
    assert(adjusted.x == 25);
    assert(adjusted.y == 25);
    
    
    adjusted = [bds adjustLocation:CGPointMake(0, 100)];
    EZDEBUG(@"Org:%@, Adjusted: %@", NSStringFromCGPoint(CGPointMake(0, 100)), NSStringFromCGPoint(adjusted));
    assert(adjusted.x == 10);
    assert(adjusted.y == 25);
    
    assert(false);
    
}

+ (void) testThisSuite
{
    assert(false);
}

@end
