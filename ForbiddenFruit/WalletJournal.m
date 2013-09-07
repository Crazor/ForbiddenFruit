//
//  Wallet.m
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "EveAPI.h"
#import "WalletJournal.h"

@implementation WalletJournal

- (id)initWithCharacterID:(NSNumber *)characterID andAPI:(EveAPI *)api
{
    if (self = [super init])
    {
        _characterID = characterID;
        _api = api;
        if (![self apiRequest])
        {
            return nil;
        }
        _journal = self.api.result[@"rowset"][@"row"];
    }
    return self;
}

- (BOOL)apiRequest
{
    return [self.api authenticatedApiRequestWithString:[NSString stringWithFormat:WalletJournalAPIURL, _characterID]];
}

@end
