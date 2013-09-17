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

#import "Character.h"
#import "EveAPI.h"
#import "Balance.h"

@implementation Character

- (id)initWithCharacterID:(NSString *)characterID andAPI:(EveAPI *)api
{
    self = [super init];

    if (self)
    {
        _characterID = characterID;
        _api = [api copy];
        _balance = [[Balance alloc] initWithCharacter:self];
        [self refresh];
    }

    return self;
}

- (void)refresh
{
    [self.api authenticatedApiRequestWithString:[NSString stringWithFormat:CharacterInfoAPIURL, self.characterID]];
}

- (NSImage *)portrait
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://image.eveonline.com/character/%@_128.jpg", self.characterID]];

    return [[NSImage alloc] initWithContentsOfURL:url];
}

- (NSString *)name
{
    return self.api.result[@"characterName"];
}

- (NSString *)corporationName
{
    return self.api.result[@"corporation"];
}

- (NSNumber *)corporationID
{
    return self.api.result[@"corporationID"];
}

- (NSDate *)corporationDate
{
    return [NSDate dateWithEveDate:self.api.result[@"corporationDate"]];
}

- (NSString *)race
{
    return self.api.result[@"race"];
}

- (NSString *)bloodline
{
    return self.api.result[@"bloodline"];
}

- (NSNumber *)skillPoints
{
    return self.api.result[@"skillPoints"];
}

- (NSNumber *)securityStatus
{
    return self.api.result[@"securityStatus"];
}

- (NSString *)lastLocation
{
    return self.api.result[@"lastKnownLocation"];
}

- (NSNumber *)accountBalance
{
    return self.api.result[@"accountBalance"];
}

- (NSDate *)nextTrainingEnds
{
    return [NSDate dateWithEveDate:self.api.result[@"nextTrainingEnds"]];
}

@end
