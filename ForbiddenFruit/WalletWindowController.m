//
//  WalletWindowController.m
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

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
    [self.walletJournal refresh];
    [self.tableView reloadData];
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
