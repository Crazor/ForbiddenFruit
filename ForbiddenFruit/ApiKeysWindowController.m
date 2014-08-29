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
    
    [self.tableView registerForDraggedTypes:[NSArray arrayWithObject:MovedAPIKeyRowsType]];
    
    self.tableView.target = self;
    self.tableView.doubleAction = @selector(editTableRow:);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.apiKeys = [defaults mutableArrayValueForKey:DefaultApiKeyArray];
    if (self.apiKeys.count == 0)
    {
        [self showAddAPIKeySheet:self];
    }
    [self.tableView reloadData];
}


#pragma mark - IBActions

- (IBAction)showAddAPIKeySheet:(id)sender {
    if (!self.addAPIKeySheet)
    {
        [NSBundle loadNibNamed:@"AddAPIKeySheet" owner:self];
    }
    
    [NSApp beginSheet:self.addAPIKeySheet modalForWindow:self.apiKeysWindow modalDelegate:self didEndSelector:@selector(didEndAddAPIKeySheet:returnCode:contextInfo:) contextInfo:nil];

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
    [self.apiKeys addObject:@{DefaultAccountName: self.name.stringValue, DefaultKeyID: self.keyID.stringValue, DefaultVCode: self.vCode.stringValue}];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self.tableView reloadData];
                        
    [NSApp endSheet:self.addAPIKeySheet];
    [(AppDelegate *)[NSApp delegate] updateAPIKeys];
}

- (IBAction)cancelAddKey:(id)sender
{
    [NSApp endSheet:self.addAPIKeySheet];
}

- (IBAction)removeKey:(id)sender
{
    if (self.tableView.selectedRow >= 0)
    {
        [self.apiKeys removeObjectAtIndex:self.tableView.selectedRow];
        [self.tableView reloadData];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [(AppDelegate *)[NSApp delegate] updateAPIKeys];
    }
}

- (IBAction)openAPIWebsite:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://support.eveonline.com/api/Key/CreatePredefined/268435455"]];
}


#pragma mark - Sheet callback

- (void)didEndAddAPIKeySheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [self.addAPIKeySheet orderOut:self];
    self.addAPIKeySheet = nil;
}


#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (!self.apiKeys)
    {
        return 0;
    }
    
    return self.apiKeys.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return self.apiKeys[row][tableColumn.identifier];
}

- (void)editTableRow:(id)object
{
    [self showAddAPIKeySheet:self];
}


#pragma mark - NSTableViewDelegate

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    if (self.tableView.selectedRow < 0)
    {
        self.removeButton.enabled = NO;
    }
    else
    {
        self.removeButton.enabled = YES;
    }
}

#pragma mark - NSTableViewDelegate - Drag'n'drop

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
    NSData *d = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	[pboard setData:d forType:MovedAPIKeyRowsType];
    
	return YES;
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
    NSDragOperation d = NSDragOperationMove;
    
	[tableView setDropRow:row dropOperation:d];
    
	return d;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation
{
    NSMutableIndexSet* rowIndexSet = [(NSIndexSet *)[NSKeyedUnarchiver unarchiveObjectWithData:[[info draggingPasteboard] dataForType:MovedAPIKeyRowsType]] mutableCopy];

    
	NSInteger index = 0;
    
	while ([rowIndexSet count] > 0) {
		index = [rowIndexSet firstIndex];
		[rowIndexSet removeIndex:index];
        
		NSArray *apiKey = [self.apiKeys objectAtIndex:index];
        [self.apiKeys insertObject:apiKey atIndex:row];
        
		if(index > row) {
            // Move row upwards
            [self.apiKeys removeObjectAtIndex:index+1];
		}
        else
        {
            // Move row downwards
            [self.apiKeys removeObjectAtIndex:index];
		}
	}
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [(AppDelegate *)[NSApp delegate] updateAPIKeys];
    });
    
	return YES;
}


#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)notification
{
    if ([self.keyID.stringValue isNotEqualTo:@""]
        && [self.vCode.stringValue isNotEqualTo:@""])
    {
        [self verifyAuthentication];
    }
    else
    {
        self.messageField.stringValue = @"";
        self.portrait.image = [NSImage imageNamed:@"NSUser"];
    }
}


#pragma mark - Authentication

- (void)verifyAuthentication
{
    EveAPI *api = [[EveAPI alloc] initWithName:self.name.stringValue andKeyID:self.keyID.stringValue andVCode:self.vCode.stringValue];
    
    [self.spinner startAnimation:self];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^(void){
        if ([api credentialsAreValid])
        {
            self.messageField.stringValue = @"Authentication verified.";
            self.addButton.enabled = YES;
            self.portrait.image = [api mainCharacter].portrait;
        }
        else
        {
            self.messageField.stringValue = [NSString stringWithFormat:@"Error %@: %@", [api.response valueForKeyPath:@"error._code"], [api.response valueForKeyPath:@"error.__text"]];
            self.addButton.enabled = NO;
        }
        [self.spinner stopAnimation:self];
    });
}

@end
