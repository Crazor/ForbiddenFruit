//
//  EveSDE.m
//  ForbiddenFruit
//
//  Created by Crazor on 18.09.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "EveSDE.h"
#import "FMDatabase.h"

@implementation EveSDE
{
    FMDatabase *db;
    long long _bytesReceived;
    NSURLResponse *_response;
}

+ (EveSDE *)sharedInstance
{
    static EveSDE *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[EveSDE alloc] init];
        //[sharedInstance downloadDB];
        //[sharedInstance openDB];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *dbPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]] stringByAppendingPathComponent:@"ody110-sqlite3-v1.db"];
        
        db = [[FMDatabase alloc] initWithPath:dbPath];
        
        [db openWithFlags:SQLITE_OPEN_READONLY];
        if (![db goodConnection])
        {
            NSLog(@"Failed to open the SDE SQLite database at %@", dbPath);
        }
    }
    
    return self;
}

- (void)openDB
{
    [db openWithFlags:SQLITE_OPEN_READONLY];
    if (![db goodConnection])
    {
        NSLog(@"Failed to open the SDE SQLite database.");
    }
}

- (void)downloadDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]] stringByAppendingPathComponent:@"ody110-sqlite3-v1.db"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath])
    {
        //http://pozniak.pl/dbdump/ody110-sqlite3-v1.db.bz2
        NSURL *url = [NSURL URLWithString:@"http://pozniak.pl/dbdump/ody110-sqlite3-v1.db.bz2"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSURLDownload *download = [[NSURLDownload alloc] initWithRequest:request delegate:self];
        if (download)
        {
            [download setDestination:[dbPath stringByAppendingString:@".bz2"] allowOverwrite:NO];
        }
        else
        {
            NSLog(@"Failed to download the SDE SQLite database from %@", url);
        }
    }
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response
{
    _response = response;
    _bytesReceived = 0;
    NSLog(@"Download response: %@", response);
}

- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length
{
    long long expectedLength = [_response expectedContentLength];
    _bytesReceived += length;
    
    if (expectedLength != NSURLResponseUnknownLength)
    {
        double percentComplete = (_bytesReceived/(double)expectedLength)*100.0;
        NSLog(@"%f Percent complete", percentComplete);
    }
    else
    {
        NSLog(@"%lld Bytes received", _bytesReceived);
    }
    
}

- (void)downloadDidFinish:(NSURLDownload *)download
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]] stringByAppendingPathComponent:@"ody110-sqlite3-v1.db"];
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/bunzip2";
    task.arguments = @[[dbPath stringByAppendingString:@".bz2"]];
    NSLog(@"Unpacking...");
    [task launch];
    [task waitUntilExit];
    NSLog(@"Unpacking complete.");
}

@end
