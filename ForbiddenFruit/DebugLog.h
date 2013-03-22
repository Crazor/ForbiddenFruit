//
//  DebugLog.h
//  ForbiddenFruit
//
//  Created by Crazor on 22.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#ifndef ForbiddenFruit_DebugLog_h
#define ForbiddenFruit_DebugLog_h

#ifdef DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
#define log(msg, ...) NSLog((@"%s:%d " msg), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#pragma clang diagnostic pop
#else
#define log(msg, ...)
#endif

#endif
