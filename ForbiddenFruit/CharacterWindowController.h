//
//  CharacterWindowController.h
//  ForbiddenFruit
//
//  Created by Crazor on 22.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

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

- (id)initWithCharacter:(Character *)character;

@end
