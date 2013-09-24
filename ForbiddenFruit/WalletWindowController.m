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

#import "WalletWindowController.h"
#import "EveAPI.h"
#import "WalletJournal.h"
#import "Character.h"
#import "Balance.h"

@interface WalletWindowController ()

@property WalletJournal *walletJournal;
@property (weak) IBOutlet CPTGraphHostingView *graphView;

@end

@implementation WalletWindowController

- (id)initWithCharacter:(Character *)character
{
    self = [super initWithWindowNibName:@"WalletWindow"];
    if (self) {
        _walletJournal = [[WalletJournal alloc] initWithCharacter:character];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.window.title = [NSString stringWithFormat:@"Wallet — %@", self.walletJournal.character.name];
    
    self.tableView.cornerView = [[NSButton alloc] init];
    ((NSButton *)self.tableView.cornerView).image = [NSImage imageNamed:@"NSColumnViewTemplate"];
    ((NSButton *)self.tableView.cornerView).target = self;
    ((NSButton *)self.tableView.cornerView).action = @selector(autoResizeColumns:);
    ((NSButton *)self.tableView.cornerView).bordered = YES;
    
    [self refresh:self];
    
    [self initGraph];
}

- (void)initGraph
{
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    [graph applyTheme:[CPTTheme themeNamed:kCPTSlateTheme]];
    graph.plotAreaFrame.masksToBorder = NO;
    graph.paddingLeft = 100.f;
    graph.paddingBottom = 30.f;
    self.graphView.hostedGraph = graph;
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTAxis *xAxis = axisSet.xAxis;
    xAxis.majorIntervalLength = CPTDecimalFromInt(0);
    xAxis.minorTicksPerInterval = 0;
    
    
    CPTScatterPlot *linePlot = [[CPTScatterPlot alloc] init];
    linePlot.identifier = @"BalanceChart";
    
    CPTMutableLineStyle *lineStyle = [linePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth = 1.f;
    lineStyle.lineColor = [CPTColor greenColor];
    
    linePlot.dataLineStyle = lineStyle;
    linePlot.dataSource = self;
    
    [graph addPlot:linePlot];
}

- (IBAction)refresh:(id)sender
{
    [self.spinner startAnimation:self];
    self.refreshButton.enabled = NO;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        self.balance.stringValue = [NSString stringWithFormat:@"%@ ISK", self.walletJournal.character.balance.balance];
        
        while ([self.walletJournal refresh])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                
                NSInteger __block maxISK = 0;
                [self.walletJournal.journal enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    maxISK = MAX(maxISK, [obj[@"_balance"] integerValue]);
                }];
                
                CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graphView.hostedGraph.defaultPlotSpace;
                plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromInteger(maxISK)];
                plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromInteger(self.walletJournal.journal.count)];
                
                int mag = (int)floor(log10(maxISK));
                int majorInterval = (int)pow(10, mag);
                
                CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graphView.hostedGraph.axisSet;
                CPTAxis *yAxis = axisSet.yAxis;
                yAxis.majorIntervalLength = CPTDecimalFromInt(majorInterval);
                yAxis.minorTicksPerInterval = 1;
               
                [self.graphView.hostedGraph reloadData];
            });
        }
        [self.spinner stopAnimation:self];
        self.refreshButton.enabled = YES;
    });
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.walletJournal.journal.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *identifier = tableColumn.identifier;
    
    // Hide your own name from the transaction by returning the other owner column
    if ([identifier isEqualToString:@"_ownerName1"]
        && [self.walletJournal.journal[row][identifier] isEqualToString:self.walletJournal.character.name])
    {
        return self.walletJournal.journal[row][@"_ownerName2"];
    }
    // Not necessary, but will put your name in the _ownerName2 column if it were currently used
    if ([identifier isEqualToString:@"_ownerName2"]
        && [self.walletJournal.journal[row][identifier] isEqualToString:self.walletJournal.character.name])
    {
        return self.walletJournal.journal[row][@"_ownerName1"];
    }
    
    // Resolve refTypes
    if ([identifier isEqualToString:@"_refType"])
    {
        return [EveAPI refTypeFromID:self.walletJournal.journal[row][@"_refTypeID"]];
    }
    
    // Hide reason code for bountys
    if ([identifier isEqualToString:@"_reason"]
        && [self.walletJournal.journal[row][@"_refTypeID"] isEqualToString:@"85"])
    {
        return nil;
    }
    
    // Everything else
    return self.walletJournal.journal[row][identifier];
}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTextFieldCell *cell = [tableColumn dataCell];
    NSString *identifier = tableColumn.identifier;

    // Colorize amounts red or green
    if([identifier isEqualToString:@"_amount"])
    {
       if ([self.walletJournal.journal[row][@"_amount"] intValue] < 0)
       {
           [cell setTextColor: [NSColor redColor]];
       }
       else
       {
           [cell setTextColor: [NSColor greenColor]];
       }
    }
    else
    {
        [cell setTextColor: [NSColor blackColor]];
    }
    
    //tableColumn.minWidth = MAX(tableColumn.minWidth, cell.cellSize.width);

    return cell;
}

#pragma mark - CPTPlotDataSource

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.walletJournal.journal.count;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    NSNumber *n;
    switch (fieldEnum)
    {
        case CPTScatterPlotFieldX:
            return [NSDecimalNumber numberWithUnsignedInteger:idx];
        case CPTScatterPlotFieldY:
            n = [NSNumber numberWithFloat:[(NSString *)(self.walletJournal.journal[idx][@"_balance"]) floatValue]];
            return n;
    }

    return nil;
}

#pragma mark -

- (IBAction)autoResizeColumns:(id)sender
{
    CGFloat oldWidth =0.0;
    for (int i=0; i<self.walletJournal.journal.count; i++)
    {
        for (int j=0; j<self.tableView.tableColumns.count; j++)
        {
            NSCell *dataCell=[self.tableView preparedCellAtColumn:j row:i];
            CGFloat  newWidth=[dataCell cellSize].width;
            if (newWidth > oldWidth)
            {
                oldWidth=newWidth;
            }
            [[[self.tableView tableColumns] objectAtIndex:j] setWidth:newWidth];
        }
    }
}

@end
