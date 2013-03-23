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

@end

@implementation AccountWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"AccountWindow"];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    _paidUntil.stringValue = [NSDateFormatter localizedStringFromDate:Account.account.paidUntil dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    _creationDate.stringValue = [NSDateFormatter localizedStringFromDate:Account.account.creationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    _logonCount.intValue = Account.account.logonCount.intValue;

    int minutesPlayed = Account.account.logonMinutes.intValue;
    _logonMinutes.stringValue = [NSString stringWithFormat:@"%dh %dm", minutesPlayed/60, minutesPlayed%60];
}

@end
