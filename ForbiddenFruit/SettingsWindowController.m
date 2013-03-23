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
#import "Character.h"

@interface SettingsWindowController ()

@end

@implementation SettingsWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"SettingsWindow"];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;

    if ([defaults stringForKey:DefaultKeyID] != nil
        && [defaults stringForKey:DefaultVCode] != nil)
    {
        _keyID.stringValue = [defaults stringForKey:DefaultKeyID];
        _vCode.stringValue = [defaults stringForKey:DefaultVCode];

        [self verifyAuthentication];
    }
}

- (void)verifyAuthentication
{
    NSError *error;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:CharacterAPIURL, _keyID.stringValue, _vCode.stringValue]];
    NSDictionary *response = [NSDictionary dictionaryWithXMLString:[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error]];

    if ([response valueForKeyPath:@"error"] != nil)
    {
        _messageField.stringValue = [NSString stringWithFormat:@"Error %@: %@", [response valueForKeyPath:@"error._code"], [response valueForKeyPath:@"error.__text"]];
    }
    else
    {
        _messageField.stringValue = @"Authentication verified.";
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:[_keyID stringValue] forKey:DefaultKeyID];
        [defaults setValue:[_vCode stringValue] forKey:DefaultVCode];
    }

    _portrait.image = [[EveAPI api] mainCharacter].portrait;
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    if ([_keyID.stringValue isNotEqualTo:@""]
        && [_vCode.stringValue isNotEqualTo:@""])
    {
        [self verifyAuthentication];
    }
    else
    {
        _messageField.stringValue = @"";
        _portrait.image = [NSImage imageNamed:@"NSUser"];
    }
}

@end
