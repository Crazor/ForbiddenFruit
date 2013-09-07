//
//  AppDelegate.m
//  ForbiddenFruit
//
//  Created by Crazor on 21.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "AppDelegate.h"
#import "CharacterWindowController.h"
#import "AccountWindowController.h"
#import "WalletWindowController.h"
#import "ApiKeysWindowController.h"
#import "EveAPI.h"
#import "Character.h"
#import "Account.h"

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
        EveAPI *api = [[EveAPI alloc] initWithName:k[DefaultAccountName] andKeyID:k[DefaultKeyID] andVCode:k[DefaultVCode]];

        if (api.credentialsAreValid)
        {
            //Account Entry
            [EveAPI accounts][k[DefaultKeyID]] = api;

            AccountWindowController *a = [[AccountWindowController alloc] initWithAccount:[[Account alloc] initWithName:k[DefaultAccountName] andAPI:[api copy]]];

            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:k[DefaultAccountName]
                                                          action:@selector(showWindow:)
                                                   keyEquivalent:@""];
            item.target = a;
            item.representedObject = a;

            NSMenuItem *item2 = [item copy];
            [_characterMenu addItem:item];
            [_dockMenu addItem:item2];

            // Character Entries
            CharacterWindowController *c= [[CharacterWindowController alloc] initWithCharacter:api.mainCharacter];

            item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@", api.mainCharacter.name]
                                                          action:@selector(showWindow:)
                                                   keyEquivalent:@""];
            item.indentationLevel = 1;
            item.target = c;
            item.representedObject = c;

            item2 = [item copy];
            [_characterMenu addItem:item];
            [_dockMenu addItem:item2];

            // Seperator
            [_characterMenu addItem:[NSMenuItem separatorItem]];
            [_dockMenu addItem:[NSMenuItem separatorItem]];
        }
    }

    // Remove last seperator
    [_characterMenu removeItemAtIndex:_characterMenu.numberOfItems -1];
    [_dockMenu removeItemAtIndex:_dockMenu.numberOfItems -1];
}

- (IBAction)characterClicked:(id)sender
{
    NSMenuItem *item = (NSMenuItem *)sender;
    [(CharacterWindowController *)item.representedObject showWindow:self];
}

- (NSMenu *)applicationDockMenu:(NSApplication *)sender
{
    return _dockMenu;
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
