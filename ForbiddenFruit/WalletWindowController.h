//
//  WalletWindowController.h
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WalletWindowController : NSWindowController <NSTableViewDataSource>

- (id)initWithCharacterID:(NSNumber *)characterID;

@end