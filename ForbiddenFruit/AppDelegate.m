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
#import "Character.h"

static SettingsWindowController *settingsWindowController;
static CharacterWindowController *characterWindowController;
static AccountWindowController *accountWindowController;
static WalletWindowController *walletWindowController;
static ApiKeysWindowController *apiKeysWindowController;

@implementation AppDelegate

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    _dockMenu = [[NSMenu alloc] init];
    [self updateAPIKeys];
}

- (void)updateAPIKeys
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *keys = [defaults arrayForKey:DefaultApiKeyArray];

    if (keys.count == 0)
    {
        [self showSettingsWindow:self];
    }

    [_characterMenu removeAllItems];
    [_dockMenu removeAllItems];

    for (NSDictionary *k in keys)
    {
        EveAPI *api = [[EveAPI alloc] initWithKeyID:k[DefaultKeyID] andVCode:k[DefaultVCode]];

        if (api.credentialsAreValid)
        {
            [EveAPI accounts][k[DefaultKeyID]] = api;

            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@", [api mainCharacter].name] action:@selector(characterClicked:) keyEquivalent:@""];
            item.target = self;
            item.representedObject = [api mainCharacter];
            NSMenuItem *item2 = [item copy];
            [_characterMenu addItem:item];
            [_dockMenu addItem:item2];
        }
    }
}

- (NSMenu *)applicationDockMenu:(NSApplication *)sender
{
    return _dockMenu;
}

- (IBAction)characterClicked:(id)sender
{
    NSMenuItem *item = (NSMenuItem *)sender;
    Character *character = (Character *)item.representedObject;
    
    [[[CharacterWindowController alloc] initWithCharacter:character] showWindow:self];
}

- (IBAction)showSettingsWindow:(id)sender {
    apiKeysWindowController = [[ApiKeysWindowController alloc] init];
    [apiKeysWindowController showWindow:self];
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
