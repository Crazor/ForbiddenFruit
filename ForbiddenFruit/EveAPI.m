//
//  EveAPI.m
//  ForbiddenFruit
//
//  Created by Crazor on 22.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "EveAPI.h"
#import "XMLDictionary.h"
#import "Character.h"

@implementation EveAPI

+ (EveAPI *)api
{
    static dispatch_once_t pred = 0;
    static EveAPI *api = nil;
    dispatch_once(&pred, ^{
        api = [[EveAPI alloc] init];
    });
    return api;
}

- (id)init
{
    if (self = [super init])
    {
        NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
        [self defaultsChanged:[NSNotification notificationWithName:@"" object:defaults]];

        [NSNotificationCenter.defaultCenter addObserver:self
                   selector:@selector(defaultsChanged:)
                       name:NSUserDefaultsDidChangeNotification
                     object:nil];
    }

    return self;
}

- (void)defaultsChanged:(NSNotification *)notification
{
    //log(@"Reloading defaults...");
    NSUserDefaults *defaults = (NSUserDefaults *)notification.object;

    self.keyID = [defaults stringForKey:DefaultKeyID];
    self.vCode = [defaults stringForKey:DefaultVCode];
}

- (BOOL)credentialsAreValid
{
    NSError *error;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:CharacterAPIURL, _keyID, _vCode]];
    NSDictionary *response = [NSDictionary dictionaryWithXMLString:[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error]];

    return [response valueForKeyPath:@"error"] == nil;
}

- (NSNumber *)mainCharacterID
{
    NSError *error;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:CharacterAPIURL, _keyID, _vCode]];
    NSDictionary *response = [NSDictionary dictionaryWithXMLString:[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error]];

    if ([response valueForKeyPath:@"error"] != nil)
    {
        log(@"API Error\n%@", response);
        return nil;
    }
    else
    {
        //log(@"%@", dict);
        NSDictionary *dict = (NSDictionary *)[[response valueForKeyPath:@"result.rowset"] childNodes];
        return dict[@"row"][@"_characterID"];
    }
}

- (Character *)mainCharacter
{
    static dispatch_once_t pred = 0;
    static Character *mainCharacter = nil;
    dispatch_once(&pred, ^{
        mainCharacter = [[Character alloc] initWithCharacterID:[self mainCharacterID]];
    });

    return mainCharacter;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
