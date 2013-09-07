//
//  WalletWindowController.h
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Character;

@interface WalletWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSProgressIndicator *spinner;

- (id)initWithCharacter:(Character *)character;
@end
