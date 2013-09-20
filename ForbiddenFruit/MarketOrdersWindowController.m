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

#import "MarketOrdersWindowController.h"
#import "MarketOrders.h"
#import "Character.h"
#import "EveSDE.h"

@interface MarketOrdersWindowController ()

@property MarketOrders *marketOrders;

@end

@implementation MarketOrdersWindowController

- (id)initWithCharacter:(Character *)character
{
    self = [super initWithWindowNibName:@"MarketOrdersWindow"];
    if (self) {
        _marketOrders = [[MarketOrders alloc] initWithCharacter:character];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.window.title = [NSString stringWithFormat:@"Market Orders — %@", self.marketOrders.character.name];
    
    [self refresh:self];
}

- (IBAction)refresh:(id)sender
{
    [self.spinner startAnimation:self];
    self.refreshButton.enabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.marketOrders refresh];
        [self.tableView reloadData];
        [self.spinner stopAnimation:self];
        self.refreshButton.enabled = YES;
    });
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.marketOrders.orders.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *identifier = [tableColumn identifier];
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
    
    if ([identifier isEqualToString:@"_station"])
    {
        cellView.textField.stringValue = [[EveSDE sharedInstance] stationNameForID:self.marketOrders.orders[row][@"_stationID"]];
    }
    else if ([identifier isEqualToString:@"_type"])
    {
        cellView.textField.stringValue = [[EveSDE sharedInstance] typeNameForID:self.marketOrders.orders[row][@"_typeID"]];
    }
    else if ([identifier isEqualToString:@"_orderState"])
    {
        if ([self.marketOrders.orders[row][identifier] isEqualToString:@"0"])
        {
            cellView.textField.stringValue = @"open";
        }
        else if ([self.marketOrders.orders[row][identifier] isEqualToString:@"1"])
        {
            cellView.textField.stringValue = @"closed";
        }
        else if ([self.marketOrders.orders[row][identifier] isEqualToString:@"2"])
        {
            cellView.textField.stringValue = @"fulfilled";
        }
        else if ([self.marketOrders.orders[row][identifier] isEqualToString:@"3"])
        {
            cellView.textField.stringValue = @"cancelled";
        }
        else if ([self.marketOrders.orders[row][identifier] isEqualToString:@"4"])
        {
            cellView.textField.stringValue = @"pending";
        }
        else
        {
            cellView.textField.stringValue = self.marketOrders.orders[row][identifier];
        }
    }
    else if ([identifier isEqualToString:@"_volume"])
    {
        if ([self.marketOrders.orders[row][@"_orderState"] isEqualToString:@"0"])
        {
            cellView.textField.stringValue = [NSString stringWithFormat:@"%@/%@", self.marketOrders.orders[row][@"_volRemaining"], self.marketOrders.orders[row][@"_volEntered"]];
        }
        else
        {
            cellView.textField.stringValue = self.marketOrders.orders[row][@"_volEntered"];
        }
    }
    else if ([identifier isEqualToString:@"_range"])
    {
        if ([self.marketOrders.orders[row][@"_bid"] isEqualToString:@"1"])
        {
            if ([self.marketOrders.orders[row][@"_range"] isEqualToString:@"-1"])
            {
                 cellView.textField.stringValue = @"Station";
            }
            else
            {
                 cellView.textField.stringValue = self.marketOrders.orders[row][@"_range"];
            }
        }
        else
        {
            cellView.textField.stringValue = @"";
        }
    }
    else if ([identifier isEqualToString:@"_bid"])
    {
        if ([self.marketOrders.orders[row][@"_bid"] isEqualToString:@"1"])
        {
            cellView.textField.stringValue = @"Buy";
        }
        else
        {
            cellView.textField.stringValue = @"Sell";            
        }
    }
    else
    {
        cellView.textField.stringValue = self.marketOrders.orders[row][identifier];
    }
    
    //[cellView.textField sizeToFit];
    //tableColumn.minWidth = MAX(tableColumn.minWidth, [cellView.textField intrinsicContentSize].width);
    
    return cellView;
}

@end
