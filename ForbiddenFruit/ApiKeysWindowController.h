//
//  ApiKeysWindowController.h
//  ForbiddenFruit
//
//  Created by Crazor on 26.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ApiKeysWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;

@property (readonly) NSMutableArray *apiKeys;

@end
