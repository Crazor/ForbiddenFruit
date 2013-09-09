/*
 * This file is part of ForbiddenFruit.
 *
 * Copyright 2013 Crazor <crazor@gmail.com>
 *
 * ForbiddenFruit is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * ForbiddenFruit is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with ForbiddenFruit.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "XMLDictionary.h"
#import "EveAPI.h"
#import "Character.h"

@implementation EveAPI

static NSMutableDictionary *accounts;

+ (void)initialize
{
    accounts = [[NSMutableDictionary alloc] init];
}

+ (NSDictionary *)fetchRefTypes
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


+ (NSString *)refTypeFromID:(NSString *)refTypeId
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

+ (void)setAccounts:(NSMutableDictionary *)a
{
    accounts = a;
}

+ (NSMutableDictionary *)accounts
{
    return accounts;
}

+ (EveAPI *)apiForKeyID:(NSString *)keyID
{
    return accounts[keyID];
}

- (id)initWithName:(NSString *)name andKeyID:(NSString *)keyID andVCode:(NSString *)vCode
{
    if (self = [super init])
    {
        _name = name;
        _keyID = keyID;
        _vCode = vCode;
    }

    return self;
}

- (EveAPI *)copy
{
    return [[EveAPI alloc] initWithName:self.name andKeyID:self.keyID andVCode:self.vCode];
}

- (BOOL)authenticatedApiRequestWithString:(NSString *)urlString
{
    NSError *error;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:urlString, self.keyID, self.vCode]];
    _response = [NSDictionary dictionaryWithXMLString:[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error]];

    if (error)
    {
        log(@"NSString stringWithContentsOfURL error: %@", error);
        return false;
    }
    
    if ([self.response valueForKeyPath:@"error"] != nil)
    {
        log(@"API Error %@: %@", [self.response valueForKeyPath:@"error._code"], [self.response valueForKeyPath:@"error.__text"]);
        return false;
    }

    _result = [self.response valueForKeyPath:@"result"];
    
    return true;
}

- (BOOL)credentialsAreValid
{
    [self authenticatedApiRequestWithString:CharacterAPIURL];
    return [self.response valueForKeyPath:@"error"] == nil;
}

- (NSNumber *)mainCharacterID
{
    [self authenticatedApiRequestWithString:CharacterAPIURL];

    NSDictionary *dict = (NSDictionary *)[[self.response valueForKeyPath:@"result.rowset"] childNodes];
    return dict[@"row"][@"_characterID"];
}

- (Character *)mainCharacter
{
    return [[Character alloc] initWithCharacterID:[self mainCharacterID] andAPI:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
