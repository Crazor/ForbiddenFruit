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

#import "ApiKeysWindowController.h"
#import "EveAPI.h"
#import "Character.h"
#import "AppDelegate.h"


@interface ApiKeysWindowController ()

@end


@implementation ApiKeysWindowController

#pragma mark - NSObject

- (id)init
{
    self = [super initWithWindowNibName:@"ApiKeysWindow"];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


#pragma mark - NSWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.tableView.target = self;
    self.tableView.doubleAction = @selector(editTableRow:);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    _apiKeys = [defaults mutableArrayValueForKey:DefaultApiKeyArray];
    if (_apiKeys.count == 0)
    {
        [self showAddAPIKeySheet:self];
    }
    [_tableView reloadData];
}


#pragma mark - IBActions

- (IBAction)showAddAPIKeySheet:(id)sender {
    if (!_addAPIKeySheet)
    {
        [NSBundle loadNibNamed:@"AddAPIKeySheet" owner:self];
    }
    
    [NSApp beginSheet:_addAPIKeySheet modalForWindow:_apiKeysWindow modalDelegate:self didEndSelector:@selector(didEndAddAPIKeySheet:returnCode:contextInfo:) contextInfo:nil];

    if (self.tableView.clickedRow >= 0)
    {
        self.name.stringValue = self.apiKeys[self.tableView.clickedRow][DefaultAccountName];
        self.keyID.stringValue = self.apiKeys[self.tableView.clickedRow][DefaultKeyID];
        self.vCode.stringValue = self.apiKeys[self.tableView.clickedRow][DefaultVCode];
        self.addButton.title = @"Update";
        
        [self verifyAuthentication];
    }
}

- (IBAction)addKey:(id)sender
{
    [_apiKeys addObject:@{DefaultAccountName: self.name.stringValue, DefaultKeyID: self.keyID.stringValue, DefaultVCode: self.vCode.stringValue}];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [_tableView reloadData];
                        
    [NSApp endSheet:self.addAPIKeySheet];
    [[NSApp delegate] updateAPIKeys];
}

- (IBAction)cancelAddKey:(id)sender
{
    [NSApp endSheet:_addAPIKeySheet];
}

- (IBAction)removeKey:(id)sender
{
    if (_tableView.selectedRow >= 0)
    {
        [_apiKeys removeObjectAtIndex:_tableView.selectedRow];
        [_tableView reloadData];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSApp delegate] updateAPIKeys];
    }
}

- (IBAction)openAPIWebsite:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://support.eveonline.com/api/Key/CreatePredefined/268435455"]];
}


#pragma mark - Sheet callback

- (void)didEndAddAPIKeySheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [_addAPIKeySheet orderOut:self];
    _addAPIKeySheet = nil;
}


#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (!_apiKeys)
    {
        return 0;
    }
    
    return _apiKeys.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return _apiKeys[row][tableColumn.identifier];
}

- (void)editTableRow:(id)object
{
    [self showAddAPIKeySheet:self];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    if (_tableView.selectedRow < 0)
    {
        _removeButton.enabled = NO;
    }
    else
    {
        _removeButton.enabled = YES;
    }
}


#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)notification
{
    if ([_keyID.stringValue isNotEqualTo:@""]
        && [_vCode.stringValue isNotEqualTo:@""])
    {
        [self verifyAuthentication];
    }
    else
    {
        _messageField.stringValue = @"";
        _portrait.image = [NSImage imageNamed:@"NSUser"];
    }
}


#pragma mark - Authentication

- (void)verifyAuthentication
{
    EveAPI *api = [[EveAPI alloc] initWithName:_name.stringValue andKeyID:_keyID.stringValue andVCode:_vCode.stringValue];
    
    [self.spinner startAnimation:self];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void){
        if ([api credentialsAreValid])
        {
            _messageField.stringValue = @"Authentication verified.";
            _addButton.enabled = YES;
            _portrait.image = [api mainCharacter].portrait;
        }
        else
        {
            _messageField.stringValue = [NSString stringWithFormat:@"Error %@: %@", [api.response valueForKeyPath:@"error._code"], [api.response valueForKeyPath:@"error.__text"]];
            _addButton.enabled = NO;
        }
        [self.spinner stopAnimation:self];
    });
}

@end
