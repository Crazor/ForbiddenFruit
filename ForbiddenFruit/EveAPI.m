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
    NSUserDefaults *defaults = (NSUserDefaults *)notification.object;

    _keyID = [defaults stringForKey:DefaultKeyID];
    _vCode = [defaults stringForKey:DefaultVCode];
}

- (BOOL)authenticatedApiRequestWithString:(NSString *)urlString
{
    NSError *error;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:urlString, _keyID, _vCode]];
    _response = [NSDictionary dictionaryWithXMLString:[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error]];

    if (error)
    {
        log(@"NSString stringWithContentsOfURL error: %@", error);
        return false;
    }
    
    if ([_response valueForKeyPath:@"error"] != nil)
    {
        log(@"API Error %@: %@", [_response valueForKeyPath:@"error._code"], [_response valueForKeyPath:@"error.__text"]);
        return false;
    }

    _result = [_response valueForKeyPath:@"result"];
    
    return true;
}

- (BOOL)credentialsAreValid
{
    [self authenticatedApiRequestWithString:CharacterAPIURL];
    return [_response valueForKeyPath:@"error"] == nil;
}

- (NSNumber *)mainCharacterID
{
    [self authenticatedApiRequestWithString:CharacterAPIURL];

    NSDictionary *dict = (NSDictionary *)[[_response valueForKeyPath:@"result.rowset"] childNodes];
    return dict[@"row"][@"_characterID"];
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

- (NSDictionary *)fetchRefTypes
{
    NSError *error;
    NSURL *url = [NSURL URLWithString:RefTypesAPIURL];
    NSDictionary *refTypes = [NSDictionary dictionaryWithXMLString:[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error]];

    if (error)
    {
        log(@"Error fetching RefTypes");
        return nil;
    }

    //log(@"%@", refTypes[@"result"][@"rowset"][@"row"]);
    return refTypes[@"result"][@"rowset"][@"row"];
}

- (NSString *)refTypeFromID:(NSString *)refTypeId
{
    static NSDictionary *refTypes;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        refTypes = [self fetchRefTypes];
    });

    for (NSDictionary *d in refTypes)
    {
        if ([d[@"_refTypeID"] isEqualToString:refTypeId])
        {
            return d[@"_refTypeName"];
        }
    }

    return nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
