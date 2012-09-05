//
//  Constants.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef SqueezitProto_Constants_h
#define SqueezitProto_Constants_h
#import <math.h>

#ifdef DEBUG
#define EZCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
EZDEBUG(xx, ##__VA_ARGS__); \
} \
} ((void)0)
#else
#define EZCONDITIONLOG(condition, xx, ...) ((void)0)
#endif // #ifdef DEBUG


#ifdef DEBUG
#define EZDEBUG(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define EZDEBUG(xx, ...)  ((void)0)
#endif // #ifdef DEBUG

#endif
