//
//  DownloadWindowController.h
//  ForbiddenFruit
//
//  Created by Crazor on 19.09.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DownloadWindowController : NSWindowController

@property (weak) IBOutlet NSProgressIndicator *progressBar;
@property (weak) IBOutlet NSTextField *progressLabel;

@end
