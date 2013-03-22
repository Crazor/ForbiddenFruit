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

- (id)initWithCharacterID:(NSNumber *)characterID
{
    self = [super init];

    if (self)
    {
        _characterID = characterID;
        
        NSError *error;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:CharacterInfoAPIURL, self.keyID, self.vCode, _characterID]];
        _response = [NSDictionary dictionaryWithXMLString:[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error]];
        if ([_response valueForKeyPath:@"error"] != nil)
        {
            log(@"API Error\n%@", _response);
            return nil;
        }
        
        _result = [_response valueForKeyPath:@"result"];
    }

    return self;
}

- (NSImage *)portrait
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://image.eveonline.com/character/%@_128.jpg", _characterID]];

    return [[NSImage alloc] initWithContentsOfURL:url];
}

- (NSString *)name
{
    return _result[@"characterName"];
}

- (NSString *)corporationName
{
    return _result[@"corporation"];
}

- (NSNumber *)corporationID
{
    return _result[@"corporationID"];
}

- (NSDate *)corporationDate
{
    return [NSDate dateWithString:[NSString stringWithFormat:@"%@ +0000", _result[@"corporationDate"]]];
}

- (NSString *)race
{
    return _result[@"race"];
}

- (NSString *)bloodline
{
    return _result[@"bloodline"];
}

- (NSNumber *)skillPoints
{
    return _result[@"skillPoints"];
}

- (NSNumber *)securityStatus
{
    return _result[@"securityStatus"];
}

- (NSString *)lastLocation
{
    return _result[@"lastKnownLocation"];
}

- (NSNumber *)accountBalance
{
    return _result[@"accountBalance"];
}

- (NSDate *)nextTrainingEnds
{
    return [NSDate dateWithString:[NSString stringWithFormat:@"%@ +0000", _result[@"nextTrainingEnds"]]];
}

@end
