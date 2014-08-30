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
    self.window.title = [NSString stringWithFormat:@"Character — %@", self.character.name];
    [self refresh:self];
}

- (IBAction)refresh:(id)sender
{
    self.refreshButton.enabled = NO;
    [self.spinner startAnimation:self];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        [self.character refresh];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.portrait.image = self.character.portrait;
            self.name.stringValue = self.character.name;
            self.characterID.stringValue = self.character.characterID;
            
            if ([self.character.race isEqualToString:self.character.bloodline])
            {
                self.race.stringValue = self.character.race;
            }
            else
            {
                self.race.stringValue = [NSString stringWithFormat:@"%@ (%@)", self.character.race, self.character.bloodline];
            }
            
            self.corporation.stringValue = self.character.corporationName;
            self.corporationDate.stringValue = [NSDateFormatter localizedStringFromDate:self.character.corporationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
            self.securityStatus.floatValue = self.character.securityStatus.floatValue;
            self.skillPoints.intValue = self.character.skillPoints.intValue;
            self.lastLocation.stringValue = self.character.lastLocation;
            
            self.refreshButton.enabled = YES;
            [self.spinner stopAnimation:self];
        });
    });
}

@end
