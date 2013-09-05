//
//  Account.m
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "Account.h"

@interface Account ()

@property EveAPI *api;

@end

@implementation Account

- (id)initWithAPI:(EveAPI *)api
{
    if (self = [super init])
    {
        _api = api;
        [self apiRequest];
    }
    return self;
}

- (BOOL)apiRequest
{
    return [_api authenticatedApiRequestWithString:AccountAPIURL];
}

- (NSDate *)paidUntil
{
    return [NSDate dateWithEveDate:_api.result[@"paidUntil"]];
}

- (NSDate *)creationDate
{
    return [NSDate dateWithEveDate:_api.result[@"createDate"]];
}

- (NSNumber *)logonCount
{
    return _api.result[@"logonCount"];
}

- (NSNumber *)logonMinutes
{
    return _api.result[@"logonMinutes"];
}


@end
