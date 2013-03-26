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

- (id)initWithCharacterID:(NSNumber *)characterID
{
    self = [super initWithWindowNibName:@"WalletWindow"];
    if (self) {
        _walletJournal = [[WalletJournal alloc] initWithCharacterID:characterID];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _walletJournal.journal.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *identifier = tableColumn.identifier;
    if ([identifier isEqualToString:@"_ownerName1"]
        && [_walletJournal.journal[row][identifier] isEqualToString:EveAPI.api.mainCharacter.name])
    {
        return _walletJournal.journal[row][@"_ownerName2"];
    }
    if ([identifier isEqualToString:@"_ownerName2"]
        && [_walletJournal.journal[row][identifier] isEqualToString:EveAPI.api.mainCharacter.name])
    {
        return _walletJournal.journal[row][@"_ownerName1"];
    }
    if ([identifier isEqualToString:@"_refType"])
    {
        return [[EveAPI api] refTypeFromID:_walletJournal.journal[row][@"_refTypeID"]];
    }
    return _walletJournal.journal[row][identifier];
}


@end
