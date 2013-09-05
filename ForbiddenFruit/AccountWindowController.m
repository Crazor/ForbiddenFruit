//
//  AccountWindowController.m
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "AccountWindowController.h"
#import "Account.h"

@interface AccountWindowController ()

@property Account *account;

@end

@implementation AccountWindowController

- (id)initWithAccount:(Account *)account
{
    self = [super initWithWindowNibName:@"AccountWindow"];
    if (self) {
        _account = account;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    _paidUntil.stringValue = [NSDateFormatter localizedStringFromDate:_account.paidUntil dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    _creationDate.stringValue = [NSDateFormatter localizedStringFromDate:_account.creationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    _logonCount.intValue = _account.logonCount.intValue;

    int minutesPlayed = _account.logonMinutes.intValue;
    _logonMinutes.stringValue = [NSString stringWithFormat:@"%dh %dm", minutesPlayed/60, minutesPlayed%60];
}

@end
