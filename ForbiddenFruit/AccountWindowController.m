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
    
    [self refresh:self];
}

- (IBAction)refresh:(id)sender
{
    self.refreshButton.enabled = NO;
    [self.spinner startAnimation:self];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.account refresh];
        
        self.window.title = [NSString stringWithFormat:@"Account — %@", self.account.name];
        
        self.paidUntil.stringValue = [NSDateFormatter localizedStringFromDate:self.account.paidUntil dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
        self.creationDate.stringValue = [NSDateFormatter localizedStringFromDate:self.account.creationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
        self.logonCount.intValue = self.account.logonCount.intValue;
        
        int minutesPlayed = self.account.logonMinutes.intValue;
        self.logonMinutes.stringValue = [NSString stringWithFormat:@"%dh %dm", minutesPlayed/60, minutesPlayed%60];
        
        [self.spinner stopAnimation:self];
        
        self.refreshButton.toolTip = [NSString stringWithFormat:@"Last refreshed at %@\nCached until %@", [NSDateFormatter localizedStringFromDate:self.account.api.lastRefresh dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle], [NSDateFormatter localizedStringFromDate:self.account.api.cachedUntil dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle]];
        int64_t delta = (int64_t)(1.0e9 * self.account.api.cachedUntil.timeIntervalSinceNow);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), ^{
            self.refreshButton.enabled = YES;
            self.refreshButton.toolTip = [NSString stringWithFormat:@"Last refresh at %@", [NSDateFormatter localizedStringFromDate:self.account.api.lastRefresh dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle]];
        });
    });
}

@end
