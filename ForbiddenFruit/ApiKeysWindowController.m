//
//  ApiKeysWindowController.m
//  ForbiddenFruit
//
//  Created by Crazor on 26.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "ApiKeysWindowController.h"
#import "EveAPI.h"
#import "Character.h"
#import "AppDelegate.h"

#import "XMLDictionary.h"

@interface ApiKeysWindowController ()

@end

@implementation ApiKeysWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"ApiKeysWindow"];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    _apiKeys = [defaults mutableArrayValueForKey:DefaultApiKeyArray];
    if (_apiKeys.count == 0)
    {
        [self showAddAPIKeySheet:self];
    }
    [_tableView reloadData];
}

- (IBAction)showAddAPIKeySheet:(id)sender {
    /*
    [_apiKeys addObject:@{DefaultKeyID: @"", DefaultVCode: @""}];
    [_tableView reloadData];
    [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:_apiKeys.count-1] byExtendingSelection:NO];
    [_tableView editColumn:0 row:_apiKeys.count-1 withEvent:nil select:NO];
     */
    
    if (!_addAPIKeySheet)
    {
        [NSBundle loadNibNamed:@"AddAPIKeySheet" owner:self];
    }
    
    [NSApp beginSheet:_addAPIKeySheet modalForWindow:_apiKeysWindow modalDelegate:self didEndSelector:@selector(didEndAddAPIKeySheet:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)addKey:(id)sender
{
    [_apiKeys addObject:@{DefaultKeyID: _keyID.stringValue, DefaultVCode: _vCode.stringValue}];
    [_tableView reloadData];
                        
    [NSApp endSheet:_addAPIKeySheet];
    [[NSApp delegate] updateAPIKeys];
    /*
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setValue:[_keyID stringValue] forKey:DefaultKeyID];
     [defaults setValue:[_vCode stringValue] forKey:DefaultVCode];
     */
}

- (IBAction)cancelAddKey:(id)sender
{
    [NSApp endSheet:_addAPIKeySheet];
}

- (void)didEndAddAPIKeySheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [_addAPIKeySheet orderOut:self];
    _addAPIKeySheet = nil;
}

- (IBAction)removeKey:(id)sender
{
    if (_tableView.selectedRow >= 0)
    {
        [_apiKeys removeObjectAtIndex:_tableView.selectedRow];
        [_tableView reloadData];
    }
}

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

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSMutableDictionary *dict = [_apiKeys[row] mutableCopy];
    dict[tableColumn.identifier] = anObject;
    _apiKeys[row] = dict;
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

- (IBAction)openAPIWebsite:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://support.eveonline.com/api/Key/CreatePredefined/268435455"]];
}

- (void)verifyAuthentication
{
    EveAPI *api = [[EveAPI alloc] initWithKeyID:_keyID.stringValue andVCode:_vCode.stringValue];
    
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
    

}

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

@end
