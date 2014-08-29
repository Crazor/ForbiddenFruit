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

#import "EveSDE.h"
#import "FMDatabase.h"
#import "DownloadWindowController.h"

@implementation EveSDE
{
    FMDatabase *db;
    NSString *_dbPath;
    BOOL _downloading;
    long long _totalBytesReceived;
    NSDate *_speedLastCalculated;
    long long _bytesReceivedSinceLastSpeedCalculation;
    int _speed;
    NSURLResponse *_response;
    DownloadWindowController *_downloadWindowController;
}

+ (EveSDE *)sharedInstance
{
    static EveSDE *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[EveSDE alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _dbPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]] stringByAppendingPathComponent:@"sqlite-latest.sqlite"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            BOOL ready = NO;
            while (!ready)
            {
                [self downloadDBIfNecessary];
                if ([self checkDB])
                {
                    db = [[FMDatabase alloc] initWithPath:_dbPath];
                    [db openWithFlags:SQLITE_OPEN_READONLY];
                    if ([db goodConnection])
                    {
                        ready = YES;
                    }
                }
            }
        });
    }
    
    return self;
}

- (void)downloadDBIfNecessary
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:_dbPath])
    {
        NSURL *url = [NSURL URLWithString:EveSDEDownloadURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        _downloading = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLDownload *download = [[NSURLDownload alloc] initWithRequest:request delegate:self];
            download.deletesFileUponFailure = YES;
            [download setDestination:[_dbPath stringByAppendingString:@".bz2"] allowOverwrite:YES];
            _downloadWindowController = [[DownloadWindowController alloc] init];
            [_downloadWindowController showWindow:self];
        });

        while(_downloading);
    }
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response
{
    _response = response;
    _totalBytesReceived = 0;
    [_downloadWindowController.progressBar setIndeterminate:YES];
    [_downloadWindowController.progressBar startAnimation:self];
}

- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length
{
    _totalBytesReceived += length;
    _bytesReceivedSinceLastSpeedCalculation += length;
    
    if (!_speedLastCalculated)
    {
        _speedLastCalculated = [NSDate date];
    }
    
    if (abs((int)_speedLastCalculated.timeIntervalSinceNow) >= 1)
    {
        _speed = abs((int)(_bytesReceivedSinceLastSpeedCalculation / _speedLastCalculated.timeIntervalSinceNow));
        
        _speedLastCalculated = [NSDate date];
        _bytesReceivedSinceLastSpeedCalculation = 0;
    }
    
    if ([_response expectedContentLength] != NSURLResponseUnknownLength)
    {
        double percentComplete = (_totalBytesReceived/(double)[_response expectedContentLength])*100.0;
        _downloadWindowController.progressLabel.stringValue = [NSString stringWithFormat:@"%d%% %@/s", (int)percentComplete, [NSByteCountFormatter stringFromByteCount:_speed countStyle:NSByteCountFormatterCountStyleDecimal]];
        [_downloadWindowController.progressBar setIndeterminate:NO];
        _downloadWindowController.progressBar.doubleValue = percentComplete;
    }
    else
    {
        _downloadWindowController.progressLabel.stringValue = [NSString stringWithFormat:@"%@/s", [NSByteCountFormatter stringFromByteCount:_speed countStyle:NSByteCountFormatterCountStyleDecimal]];
    }
    
}

- (void)downloadDidFinish:(NSURLDownload *)download
{
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/bunzip2";
    task.arguments = @[[_dbPath stringByAppendingString:@".bz2"]];
    _downloadWindowController.progressLabel.stringValue = @"Unpacking...";
    [_downloadWindowController.progressBar setIndeterminate:YES];
    [_downloadWindowController.progressBar startAnimation:self];
    [task launch];
    [task waitUntilExit];
    [_downloadWindowController close];
    _downloading = NO;
}

- (BOOL)checkDB
{
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/sbin/md5";
    task.arguments = @[@"-q", _dbPath];
    task.standardOutput = [NSPipe pipe];
    [task launch];
    [task waitUntilExit];
    NSString *md5 = [[[NSString alloc] initWithData:[[task.standardOutput fileHandleForReading] readDataToEndOfFile] encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (![md5 isEqualToString:EveSDEMD5])
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"The SDE SQLite database file appears to be corrupt.";
            [alert addButtonWithTitle:@"Delete and redownload"];
            [alert addButtonWithTitle:@"Quit"];
            NSInteger ret = [alert runModal];
            if (ret == NSAlertFirstButtonReturn)
            {
                [[NSFileManager defaultManager] removeItemAtPath:_dbPath error:nil];
            }
            else if (ret == NSAlertSecondButtonReturn)
            {
                [NSApp terminate:self];
            }
        });
        return NO;
    }
    return YES;
}

- (NSString *)stationNameForID:(NSString *)stationID
{
    FMResultSet *r = [db executeQuery:@"SELECT stationName FROM stastations WHERE stationID=(?)", stationID];
    if ([r next])
    {
        return [r stringForColumn:@"stationName"];
    }
    return [NSString stringWithFormat:@"Unknown Station (ID %@)", stationID];
}

- (NSString *)typeNameForID:(NSString *)typeID
{
    FMResultSet *r = [db executeQuery:@"SELECT typeName FROM invtypes WHERE typeID=(?)", typeID];
    if ([r next])
    {
        return [r stringForColumn:@"typeName"];
    }
    return [NSString stringWithFormat:@"Unknown Type (ID %@)", typeID];
}

@end
