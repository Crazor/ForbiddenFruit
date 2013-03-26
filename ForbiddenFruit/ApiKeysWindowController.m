//
//  ApiKeysWindowController.m
//  ForbiddenFruit
//
//  Created by Crazor on 26.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "ApiKeysWindowController.h"

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
    [_tableView reloadData];
}

- (IBAction)addKey:(id)sender
{
    [_apiKeys addObject:@{DefaultKeyID: @"", DefaultVCode: @""}];
    [_tableView reloadData];
    [_tableView editColumn:0 row:_apiKeys.count-1 withEvent:nil select:NO];
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



@end
