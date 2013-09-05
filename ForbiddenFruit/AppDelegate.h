//
//  AppDelegate.h
//  ForbiddenFruit
//
//  Created by Crazor on 21.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property NSMenu *dockMenu;

@property (weak) IBOutlet NSMenu *characterMenu;

- (IBAction)showSettingsWindow:(id)sender;
- (IBAction)showAccountWindow:(id)sender;
- (IBAction)showCharacterWindow:(id)sender;
- (IBAction)showWalletWindow:(id)sender;

@end
