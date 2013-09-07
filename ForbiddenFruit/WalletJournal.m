//
//  Wallet.m
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "EveAPI.h"
#import "Character.h"
#import "WalletJournal.h"

@implementation WalletJournal

- (id)initWithCharacter:(Character *)character
{
    if (self = [super init])
    {
        _character = character;
        _api = [character.api copy];
    }
    return self;
}

- (BOOL)refresh
{
    if ([self.api authenticatedApiRequestWithString:[NSString stringWithFormat:WalletJournalAPIURL,
                                                     self.character.characterID]])
    {
        _journal = self.api.result[@"rowset"][@"row"];
        return true;
    }
    else
    {
        NSLog(@"Request failed: %@", self.api.result);
        self.api.result = nil;
        return false;
    }
}

@end
