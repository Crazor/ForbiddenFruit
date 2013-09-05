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

/*
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
*/




@end
