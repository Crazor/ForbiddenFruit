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
        self.response = [NSDictionary dictionaryWithXMLString:[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error]];
        if ([self.response valueForKeyPath:@"error"] != nil)
        {
            log(@"API Error\n%@", self.response);
            return nil;
        }
        
        self.result = [self.response valueForKeyPath:@"result"];
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
