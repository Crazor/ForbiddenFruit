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

#import "AppDelegate.h"
#import "CharacterWindowController.h"
#import "AccountWindowController.h"
#import "WalletWindowController.h"
#import "ApiKeysWindowController.h"
#import "EveAPI.h"
#import "Character.h"
#import "Account.h"
#import "WalletJournal.h"
#import "MarketOrdersWindowController.h"
#import "MarketOrders.h"
#import "EveSDE.h"

static CharacterWindowController *characterWindowController;
static AccountWindowController *accountWindowController;
static WalletWindowController *walletWindowController;
static ApiKeysWindowController *apiKeysWindowController;

@implementation AppDelegate

- (id)init
{
    if (self = [super init])
    {
        _dockMenu = [[NSMenu alloc] init];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [EveSDE sharedInstance];
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

    [self.characterMenu removeAllItems];
    [self.dockMenu removeAllItems];

    int i = 0;
    for (NSMutableDictionary *key in keys)
    {
        NSMutableDictionary *k = [key mutableCopy];
        EveAPI *api = [[EveAPI alloc] initWithName:k[DefaultAccountName] andKeyID:k[DefaultKeyID] andVCode:k[DefaultVCode]];

        if (api.credentialsAreValid)
        {
            //Account Entry
            [EveAPI accounts][k[DefaultKeyID]] = api;

            AccountWindowController *a = [[AccountWindowController alloc] initWithAccount:[[Account alloc] initWithName:k[DefaultAccountName] andAPI:[api copy]]];

            if (k[DefaultAccountName] == nil || [k[DefaultAccountName] isEqualToString:@""])
            {
                k[DefaultAccountName] = [NSString stringWithFormat:@"Unnamed %d", ++i];
            }
            
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:k[DefaultAccountName]
                                                          action:@selector(showWindow:)
                                                   keyEquivalent:@""];
            item.target = a;
            item.representedObject = a;

            NSMenuItem *item2 = [item copy];
            [self.characterMenu addItem:item];
            [self.dockMenu addItem:item2];


            // Character Entries TODO
            CharacterWindowController *c = [[CharacterWindowController alloc] initWithCharacter:api.mainCharacter];

            item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@", api.mainCharacter.name]
                                                          action:@selector(showWindow:)
                                                   keyEquivalent:@""];
            item.indentationLevel = 1;
            item.target = c;
            item.representedObject = c;

            item2 = [item copy];
            [self.characterMenu addItem:item];
            [self.dockMenu addItem:item2];

            
            // Wallet Entry
            WalletWindowController *w = [[WalletWindowController alloc] initWithCharacter:api.mainCharacter];
            item = [[NSMenuItem alloc] initWithTitle:@"Wallet"
                                              action:@selector(showWindow:)
                                       keyEquivalent:@""];
            item.indentationLevel = 1;
            item.target = w;
            item.representedObject = w;

            item2 = [item copy];
            [self.characterMenu addItem:item];
            [self.dockMenu addItem:item2];
            
            // Market Orders Entry
            MarketOrdersWindowController *m = [[MarketOrdersWindowController alloc] initWithCharacter:api.mainCharacter];
            item = [[NSMenuItem alloc] initWithTitle:@"Market Orders"
                                              action:@selector(showWindow:)
                                       keyEquivalent:@""];
            item.indentationLevel = 1;
            item.target = m;
            item.representedObject = m;
            
            item2 = [item copy];
            [self.characterMenu addItem:item];
            [self.dockMenu addItem:item2];

            // Seperator
            [self.characterMenu addItem:[NSMenuItem separatorItem]];
            [self.dockMenu addItem:[NSMenuItem separatorItem]];
        }
    }

    // Remove last seperator
    if (self.characterMenu.numberOfItems > 0)
    {
        [self.characterMenu removeItemAtIndex:self.characterMenu.numberOfItems -1];
    }
    else
    {
        [self.characterMenu addItemWithTitle:@"No accounts" action:nil keyEquivalent:@""];
    }
    if (self.dockMenu.numberOfItems > 0)
    {
        [self.dockMenu removeItemAtIndex:self.dockMenu.numberOfItems -1];
    }
    else
    {
        [self.dockMenu addItemWithTitle:@"No accounts" action:nil keyEquivalent:@""];
    }
}

- (IBAction)characterClicked:(id)sender
{
    NSMenuItem *item = (NSMenuItem *)sender;
    [(CharacterWindowController *)item.representedObject showWindow:self];
}

- (NSMenu *)applicationDockMenu:(NSApplication *)sender
{
    return self.dockMenu;
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
