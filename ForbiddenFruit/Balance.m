//
//  Balance.m
//  ForbiddenFruit
//
//  Created by Crazor on 12.09.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "Balance.h"
#import "EveAPI.h"
#import "Character.h"

@implementation Balance

- (id)initWithCharacter:(Character *)character
{
    if (self = [super init])
    {
        _character = character;
        _api = [character.api copy];
        [self refresh];
    }
    
    return self;
}

- (void)refresh
{
    [self.api authenticatedApiRequestWithString:[NSString stringWithFormat:AccountBalanceAPIURL, self.character.characterID]];
}

- (NSNumber *)accountID
{
    return self.api.result[@"rowset"][@"row"][@"_accountID"];
}

- (NSNumber *)accountKey
{
    return self.api.result[@"rowset"][@"row"][@"_accountKey"];
}

- (NSNumber *)balance
{
    return self.api.result[@"rowset"][@"row"][@"_balance"];
}

@end
