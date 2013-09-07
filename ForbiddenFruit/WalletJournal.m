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

- (void)refresh
{
    NSString *fromID;
    _journal = [[NSMutableArray alloc] init];

    [self.api authenticatedApiRequestWithString:[NSString stringWithFormat:WalletJournalAPIURL,
                                                 self.character.characterID, fromID]];
    do {
            [_journal addObjectsFromArray:self.api.result[@"rowset"][@"row"]];
            [_journal sortUsingComparator:^(id firstObject, id secondObject) {
                NSInteger firstKey = ((NSString *)[firstObject valueForKey:@"_refID"]).integerValue;
                NSInteger secondKey = ((NSString *)[secondObject valueForKey:@"_refID"]).integerValue;
                if (firstKey > secondKey)
                    return NSOrderedAscending;
                else if (firstKey == secondKey)
                    return NSOrderedSame;
                else
                    return NSOrderedDescending;
            }];
            fromID = [_journal lastObject][@"_refID"];
            [self.api authenticatedApiRequestWithString:[NSString stringWithFormat:WalletJournalAPIURL,
                                                         self.character.characterID, fromID]];
    } while (((NSArray *)self.api.result[@"rowset"][@"row"]).count > 0);
}

@end
