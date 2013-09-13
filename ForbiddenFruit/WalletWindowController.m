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

#import "WalletWindowController.h"
#import "EveAPI.h"
#import "WalletJournal.h"
#import "Character.h"
#import "Balance.h"

@interface WalletWindowController ()

@property WalletJournal *walletJournal;

@end

@implementation WalletWindowController

- (id)initWithCharacter:(Character *)character
{
    self = [super initWithWindowNibName:@"WalletWindow"];
    if (self) {
        _walletJournal = [[WalletJournal alloc] initWithCharacter:character];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.window.title = [NSString stringWithFormat:@"Wallet — %@", self.walletJournal.character.name];
    [self refresh:self];
}

- (IBAction)refresh:(id)sender
{
    [self.spinner startAnimation:self];
    self.refreshButton.enabled = NO;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        self.balance.stringValue = [NSString stringWithFormat:@"%@ ISK", self.walletJournal.character.balance.balance];
        
        while ([self.walletJournal refresh])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        [self.spinner stopAnimation:self];
        self.refreshButton.enabled = YES;
    });
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.walletJournal.journal.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *identifier = tableColumn.identifier;
    
    // Hide your own name from the transaction by returning the other owner column
    if ([identifier isEqualToString:@"_ownerName1"]
        && [self.walletJournal.journal[row][identifier] isEqualToString:self.walletJournal.character.name])
    {
        return self.walletJournal.journal[row][@"_ownerName2"];
    }
    // Not necessary, but will put your name in the _ownerName2 column if it were currently used
    if ([identifier isEqualToString:@"_ownerName2"]
        && [self.walletJournal.journal[row][identifier] isEqualToString:self.walletJournal.character.name])
    {
        return self.walletJournal.journal[row][@"_ownerName1"];
    }
    
    // Resolve refTypes
    if ([identifier isEqualToString:@"_refType"])
    {
        return [EveAPI refTypeFromID:self.walletJournal.journal[row][@"_refTypeID"]];
    }
    
    // Hide reason code for bountys
    if ([identifier isEqualToString:@"_reason"]
        && [self.walletJournal.journal[row][@"_refTypeID"] isEqualToString:@"85"])
    {
        return nil;
    }
    
    // Everything else
    return self.walletJournal.journal[row][identifier];
}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTextFieldCell *cell = [tableColumn dataCell];
    NSString *identifier = tableColumn.identifier;

    // Colorize amounts red or green
    if([identifier isEqualToString:@"_amount"])
    {
       if ([self.walletJournal.journal[row][@"_amount"] intValue] < 0)
       {
           [cell setTextColor: [NSColor redColor]];
       }
       else
       {
           [cell setTextColor: [NSColor greenColor]];
       }
    }
    else
    {
        [cell setTextColor: [NSColor blackColor]];
    }

    return cell;
}

@end
