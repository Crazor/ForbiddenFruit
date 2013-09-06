//
//  AccountWindowController.h
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Account;

@interface AccountWindowController : NSWindowController

@property (weak) IBOutlet NSTextField *paidUntil;
@property (weak) IBOutlet NSTextField *creationDate;
@property (weak) IBOutlet NSTextField *logonCount;
@property (weak) IBOutlet NSTextField *logonMinutes;

- (id)initWithAccount:(Account *)account;

@end
