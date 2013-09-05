//
//  CharacterAPI.m
//  ForbiddenFruit
//
//  Created by Crazor on 22.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

// TODO: Employment History

#import "Character.h"

@implementation Character

- (id)initWithCharacterID:(NSNumber *)characterID andAPI:(EveAPI *)api
{
    self = [super init];

    if (self)
    {
        _characterID = characterID;
        _api = api;
        
        [self apiRequest];
        
        //self.result = [self.response valueForKeyPath:@"result"];
    }

    return self;
}

- (BOOL)apiRequest
{
    return [self.api authenticatedApiRequestWithString:[NSString stringWithFormat:CharacterInfoAPIURL, _characterID]];
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
