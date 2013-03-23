//
//  Account.h
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "EveAPI.h"

@interface Account : EveAPI

@property (readonly) NSDate *paidUntil;
@property (readonly) NSDate *creationDate;
@property (readonly) NSNumber *logonCount;
@property (readonly) NSNumber *logonMinutes;

+ (Account *)account;

@end
