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
#import "WalletJournal.h"
#import "Character.h"

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
    return _walletJournal.journal.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *identifier = tableColumn.identifier;
    if ([identifier isEqualToString:@"_ownerName1"]
        && [_walletJournal.journal[row][identifier] isEqualToString:self.walletJournal.character.name])
    {
        return _walletJournal.journal[row][@"_ownerName2"];
    }
    if ([identifier isEqualToString:@"_ownerName2"]
        && [_walletJournal.journal[row][identifier] isEqualToString:self.walletJournal.character.name])
    {
        return _walletJournal.journal[row][@"_ownerName1"];
    }
    if ([identifier isEqualToString:@"_refType"])
    {
        return [EveAPI refTypeFromID:_walletJournal.journal[row][@"_refTypeID"]];
    }
    if ([identifier isEqualToString:@"_reason"]
        && [_walletJournal.journal[row][@"_refTypeID"] isEqualToString:@"85"]) // Bountys
    {
        return nil;
    }
    return _walletJournal.journal[row][identifier];
}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTextFieldCell *cell = [tableColumn dataCell];
    NSString *identifier = tableColumn.identifier;

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
