//
//  ApiKeysWindowController.h
//  ForbiddenFruit
//
//  Created by Crazor on 26.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ApiKeysWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTextField *name;
@property (weak) IBOutlet NSTextField *keyID;
@property (weak) IBOutlet NSTextField *vCode;
@property (weak) IBOutlet NSTextField *messageField;
@property (weak) IBOutlet NSImageView *portrait;
@property (weak) IBOutlet NSButton *addButton;

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *removeButton;
@property (strong) IBOutlet NSWindow *apiKeysWindow;
@property (strong) IBOutlet NSWindow *addAPIKeySheet;

@property (readonly) NSMutableArray *apiKeys;

@end
