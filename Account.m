//
//  Account.m
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "Account.h"

@implementation Account

+ (Account *)account
{
    static Account *account = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        account = [[Account alloc] init];
    });
    return account;
}

- (id)init
{
    if (self = [super init])
    {
        [self apiRequest];
    }
    return self;
}

- (BOOL)apiRequest
{
    return [self authenticatedApiRequestWithString:AccountAPIURL];
}

- (NSDate *)paidUntil
{
    return [NSDate dateWithEveDate:self.result[@"paidUntil"]];
}

- (NSDate *)creationDate
{
    return [NSDate dateWithEveDate:self.result[@"createDate"]];
}

- (NSNumber *)logonCount
{
    return self.result[@"logonCount"];
}

- (NSNumber *)logonMinutes
{
    return self.result[@"logonMinutes"];
}


@end
