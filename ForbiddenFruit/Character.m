//
//  CharacterAPI.m
//  ForbiddenFruit
//
//  Created by Crazor on 22.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

// TODO: Employment History

#import "Character.h"
#import "XMLDictionary.h"

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
    return [self authenticatedApiRequestWithString:[NSString stringWithFormat:CharacterInfoAPIURL, _characterID]];
}

- (NSImage *)portrait
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://image.eveonline.com/character/%@_128.jpg", _characterID]];

    return [[NSImage alloc] initWithContentsOfURL:url];
}

- (NSString *)name
{
    return self.result[@"characterName"];
}

- (NSString *)corporationName
{
    return self.result[@"corporation"];
}

- (NSNumber *)corporationID
{
    return self.result[@"corporationID"];
}

- (NSDate *)corporationDate
{
    return [NSDate dateWithEveDate:self.result[@"corporationDate"]];
}

- (NSString *)race
{
    return self.result[@"race"];
}

- (NSString *)bloodline
{
    return self.result[@"bloodline"];
}

- (NSNumber *)skillPoints
{
    return self.result[@"skillPoints"];
}

- (NSNumber *)securityStatus
{
    return self.result[@"securityStatus"];
}

- (NSString *)lastLocation
{
    return self.result[@"lastKnownLocation"];
}

- (NSNumber *)accountBalance
{
    return self.result[@"accountBalance"];
}

- (NSDate *)nextTrainingEnds
{
    return [NSDate dateWithEveDate:self.result[@"nextTrainingEnds"]];
}

@end
