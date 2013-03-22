//
//  SettingsWindowController.m
//  ForbiddenFruit
//
//  Created by Crazor on 21.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "SettingsWindowController.h"
#import "XMLDictionary.h"
#import "EveAPI.h"

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

        [self verifyAuthentication];
    }
}

- (void)verifyAuthentication
{
    NSError *error;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:CharacterURL, [_keyID stringValue], [_vCode stringValue]]];
    NSDictionary *response = [NSDictionary dictionaryWithXMLString:[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error]];

    if ([response valueForKeyPath:@"error"] != nil)
    {
        [_messageField setStringValue:[NSString stringWithFormat:@"Error %@: %@", [response valueForKeyPath:@"error._code"], [response valueForKeyPath:@"error.__text"]]];
    }
    else
    {
        [_messageField setStringValue:@"Authentication verified."];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:[_keyID stringValue] forKey:DefaultKeyID];
        [defaults setValue:[_vCode stringValue] forKey:DefaultVCode];
    }

    [_portrait setImage:[[EveAPI api] portraitForCharacter:@"93114718"]];
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    if ([[_keyID stringValue] isNotEqualTo:@""]
        && [[_vCode stringValue] isNotEqualTo:@""])
    {
        [self verifyAuthentication];
    }
    else
    {
        [_messageField setStringValue:@""];
        [_portrait setImage:[NSImage imageNamed:@"NSUser"]];
    }
}

@end
