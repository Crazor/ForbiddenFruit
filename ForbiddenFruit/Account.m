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

- (id)initWithName:(NSString *)name andAPI:(EveAPI *)api;
{
    if (self = [super init])
    {
        _name = name;
        _api = api;
        
        [self apiRequest];
    }
    return self;
}

- (BOOL)apiRequest
{
    return [self.api authenticatedApiRequestWithString:AccountAPIURL];
}

- (NSDate *)paidUntil
{
    return [NSDate dateWithEveDate:self.api.result[@"paidUntil"]];
}

- (NSDate *)creationDate
{
    return [NSDate dateWithEveDate:self.api.result[@"createDate"]];
}

- (NSNumber *)logonCount
{
    return self.api.result[@"logonCount"];
}

- (NSNumber *)logonMinutes
{
    return self.api.result[@"logonMinutes"];
}


@end
