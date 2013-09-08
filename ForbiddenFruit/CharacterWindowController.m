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

#import "CharacterWindowController.h"
#import "Character.h"

@interface CharacterWindowController ()

@end

@implementation CharacterWindowController

- (id)initWithCharacter:(Character *)character
{
    self = [super initWithWindowNibName:@"CharacterWindow"];
    if (self) {
        _character = character;
    }

    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    [self refresh:self];
}

- (IBAction)refresh:(id)sender
{
    self.refreshButton.enabled = NO;
    [self.spinner startAnimation:self];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        [self.character refresh];
        
        _portrait.image = _character.portrait;
        _name.stringValue = _character.name;
        self.window.title = _character.name;
        
        if ([_character.race isEqualToString:_character.bloodline])
        {
            _race.stringValue = _character.race;
        }
        else
        {
            _race.stringValue = [NSString stringWithFormat:@"%@ (%@)", _character.race, _character.bloodline];
        }
        
        _corporation.stringValue = _character.corporationName;
        _corporationDate.stringValue = [NSDateFormatter localizedStringFromDate:_character.corporationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
        _securityStatus.floatValue = _character.securityStatus.floatValue;
        _skillPoints.intValue = _character.skillPoints.intValue;
        _lastLocation.stringValue = _character.lastLocation;
        
        self.refreshButton.enabled = YES;
        [self.spinner stopAnimation:self];
    });
}

@end
