//
//  AppDelegate.m
//  ForbiddenFruit
//
//  Created by Crazor on 21.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsWindowController.h"
#import "CharacterWindowController.h"
#import "AccountWindowController.h"
#import "EveAPI.h"

static SettingsWindowController *settingsWindowController;
static CharacterWindowController *characterWindowController;
static AccountWindowController *accountWindowController;

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    settingsWindowController = [[SettingsWindowController alloc] init];

    if ([[EveAPI alloc] init].credentialsAreValid)
    {
        characterWindowController = [[CharacterWindowController alloc] initWithCharacterID:EveAPI.api.mainCharacterID];
        [characterWindowController showWindow:self];
        accountWindowController = [[AccountWindowController alloc] init];
        [accountWindowController showWindow:self];
    }
    else
    {
        [settingsWindowController showWindow:self];
    }
}

- (IBAction)showSettingsWindow:(id)sender {
    [settingsWindowController showWindow:sender];
}

@end
