//
//  AppDelegate.m
//  ForbiddenFruit
//
//  Created by Crazor on 21.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsWindowController.h"

SettingsWindowController *settingsWindowController;

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    settingsWindowController = SettingsWindowController.alloc.init;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([[defaults stringForKey:DefaultKeyID] isEqualToString:@""]
        | [[defaults stringForKey:DefaultVCode] isEqualToString:@""])
    {
        [settingsWindowController showWindow:self];
    }
}

- (IBAction)showSettingsWindow:(id)sender {
    [settingsWindowController showWindow:sender];
}

@end
