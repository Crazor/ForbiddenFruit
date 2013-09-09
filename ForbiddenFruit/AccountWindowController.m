/*
 * This file is part of ForbiddenFruit.
 *
 * Copyright 2013 Crazor <crazor@gmail.com>
 *
 * ForbiddenFruit is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * ForbiddenFruit is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with ForbiddenFruit.  If not, see <http://www.gnu.org/licenses/>.
 */

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
        self.account = account;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.paidUntil.stringValue = [NSDateFormatter localizedStringFromDate:self.account.paidUntil dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.creationDate.stringValue = [NSDateFormatter localizedStringFromDate:self.account.creationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.logonCount.intValue = self.account.logonCount.intValue;

    int minutesPlayed = self.account.logonMinutes.intValue;
    self.logonMinutes.stringValue = [NSString stringWithFormat:@"%dh %dm", minutesPlayed/60, minutesPlayed%60];
}

@end
