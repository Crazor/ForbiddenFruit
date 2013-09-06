//
//  Account.h
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "EveAPI.h"

@interface Account : NSObject

@property (readonly) NSString *name;
@property (readonly) NSDate *paidUntil;
@property (readonly) NSDate *creationDate;
@property (readonly) NSNumber *logonCount;
@property (readonly) NSNumber *logonMinutes;

- (id)initWithName:(NSString *)name andAPI:(EveAPI *)api;

@end
