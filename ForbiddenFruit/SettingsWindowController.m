//
//  SettingsWindowController.m
//  ForbiddenFruit
//
//  Created by Crazor on 21.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "SettingsWindowController.h"

@interface SettingsWindowController ()

@end

@implementation SettingsWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"Settings"];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([[NSUserDefaults standardUserDefaults] stringForKey:DefaultKeyID] != nil
        && [[NSUserDefaults standardUserDefaults] stringForKey:DefaultVCode] != nil)
    {
        [_keyID setStringValue:[defaults stringForKey:DefaultKeyID]];
        [_vCode setStringValue:[defaults stringForKey:DefaultVCode]];
    }
}

- (IBAction)testAPIKey:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[_keyID stringValue] forKey:DefaultKeyID];
    [defaults setValue:[_vCode stringValue] forKey:DefaultVCode];

    NSError *error;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:CharacterURL, [_keyID stringValue], [_vCode stringValue]]];
    NSString *response = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];

    NSLog(@"Error: %@", error);
    NSLog(@"Response: %@", response);
}

@end
