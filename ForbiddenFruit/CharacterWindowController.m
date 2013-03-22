//
//  CharacterWindowController.m
//  ForbiddenFruit
//
//  Created by Crazor on 22.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "CharacterWindowController.h"
#import "Character.h"

@interface CharacterWindowController ()

@end

@implementation CharacterWindowController

- (id)initWithCharacterID:(NSNumber *)characterID
{
    self = [super initWithWindowNibName:@"CharacterWindow"];
    if (self) {
        _characterID = characterID;
        _character = [[Character alloc] initWithCharacterID:characterID];
    }

    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    _portrait.image = _character.portrait;
    _name.stringValue = _character.name;

    if ([_character.race isEqualToString:_character.bloodline])
    {
        _race.stringValue = _character.race;
    }
    else
    {
        _race.stringValue = [NSString stringWithFormat:@"%@ (%@)", _character.race, _character.bloodline];
    }

    _corporation.stringValue = _character.corporation;
    _corporationDate.stringValue = _character.corporationDate;
    _securityStatus.floatValue = _character.securityStatus.floatValue;
    _skillPoints.intValue = _character.skillPoints.intValue;
    _lastLocation.stringValue = _character.lastLocation;
}

@end
