//
//  Wallet.m
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "WalletJournal.h"

@implementation WalletJournal

- (id)initWithCharacterID:(NSNumber *)characterID
{
    if (self = [super init])
    {
        _characterID = characterID;
        if (![self apiRequest])
        {
            return nil;
        }
        _journal = self.result[@"rowset"][@"row"];
        //log(@"%@", _journal);
    }
    return self;
}

- (BOOL)apiRequest
{
    return [self authenticatedApiRequestWithString:[NSString stringWithFormat:WalletJournalAPIURL, _characterID]];
}

@end
