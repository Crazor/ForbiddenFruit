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

@class Character;

@interface CharacterWindowController : NSWindowController

@property Character *character;

@property (weak) IBOutlet NSImageView *portrait;
@property (weak) IBOutlet NSTextField *name;
@property (weak) IBOutlet NSTextField *corporation;
@property (weak) IBOutlet NSTextField *corporationDate;
@property (weak) IBOutlet NSTextField *race;
@property (weak) IBOutlet NSTextField *securityStatus;
@property (weak) IBOutlet NSTextField *skillPoints;
@property (weak) IBOutlet NSTextField *lastLocation;
@property (weak) IBOutlet NSButton *refreshButton;
@property (weak) IBOutlet NSProgressIndicator *spinner;

- (id)initWithCharacter:(Character *)character;

@end
