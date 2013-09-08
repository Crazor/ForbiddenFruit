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
        _journal = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)refresh
{
    if (self.fromID == nil)
    {
        _journal = [[NSMutableArray alloc] init];
    }
    
    [self.api authenticatedApiRequestWithString:[NSString stringWithFormat:WalletJournalAPIURL,
                                                 self.character.characterID, self.fromID]];
    
    [self.journal addObjectsFromArray:self.api.result[@"rowset"][@"row"]];
    [self.journal sortUsingComparator:^(id firstObject, id secondObject) {
        NSInteger firstKey = ((NSString *)[firstObject valueForKey:@"_refID"]).integerValue;
        NSInteger secondKey = ((NSString *)[secondObject valueForKey:@"_refID"]).integerValue;
        if (firstKey > secondKey)
            return NSOrderedAscending;
        else if (firstKey == secondKey)
            return NSOrderedSame;
        else
            return NSOrderedDescending;
    }];
    
    _fromID = [self.journal lastObject][@"_refID"];
    
    if (((NSArray *)self.api.result[@"rowset"][@"row"]).count > 0)
    {
        return YES;
    }
    else
    {
        _fromID = nil;
        return NO;
    }
}

@end
