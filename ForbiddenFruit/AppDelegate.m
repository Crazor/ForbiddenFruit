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
#import "WalletWindowController.h"
#import "ApiKeysWindowController.h"
#import "EveAPI.h"

static SettingsWindowController *settingsWindowController;
static CharacterWindowController *characterWindowController;
static AccountWindowController *accountWindowController;
static WalletWindowController *walletWindowController;
static ApiKeysWindowController *apiKeysWindowController;

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    settingsWindowController = [[SettingsWindowController alloc] init];
    apiKeysWindowController = [[ApiKeysWindowController alloc] init];

    if ([[EveAPI alloc] init].credentialsAreValid)
    {
        characterWindowController = [[CharacterWindowController alloc] initWithCharacterID:EveAPI.api.mainCharacterID];
        accountWindowController = [[AccountWindowController alloc] init];
        walletWindowController = [[WalletWindowController alloc] initWithCharacterID:EveAPI.api.mainCharacterID];
        //[walletWindowController showWindow:self];
        [apiKeysWindowController showWindow:self];
    }
    else
    {
        [settingsWindowController showWindow:self];
    }
}

- (IBAction)showSettingsWindow:(id)sender {
    [settingsWindowController showWindow:self];
}

- (IBAction)showAccountWindow:(id)sender {
    [accountWindowController showWindow:self];
}

- (IBAction)showCharacterWindow:(id)sender {
    [characterWindowController showWindow:self];
}

- (IBAction)showWalletWindow:(id)sender {
    [walletWindowController showWindow:self];
}

@end
