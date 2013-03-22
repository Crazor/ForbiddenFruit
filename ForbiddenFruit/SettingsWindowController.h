//
//  SettingsWindowController.h
//  ForbiddenFruit
//
//  Created by Crazor on 21.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SettingsWindowController : NSWindowController

@property (weak) IBOutlet NSTextField *keyID;
@property (weak) IBOutlet NSTextField *vCode;

- (IBAction)testAPIKey:(id)sender;

@end
