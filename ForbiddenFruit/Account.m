/*
 * This file is part of ForbiddenFruit.
 *
 * Copyright 2013 Crazor <crazor@gmail.com>
 *
 * ForbiddenFruit is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * ForbiddenFruit is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with ForbiddenFruit.  If not, see <http://www.gnu.org/licenses/>.
 */

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
