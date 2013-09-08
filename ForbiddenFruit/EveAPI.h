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

@class Character;

@interface EveAPI : NSObject

@property (readonly) NSString *name;
@property (readonly) NSString *keyID;
@property (readonly) NSString *vCode;

@property NSDictionary *response;
@property NSDictionary *result;

+ (NSString *)refTypeFromID:(NSString *)refTypeId;
+ (void)setAccounts:(NSMutableDictionary *)accounts;
+ (NSMutableDictionary *)accounts;

+ (EveAPI *)apiForKeyID:(NSString *)keyID;

- (id)initWithName:(NSString *)name andKeyID:(NSString *)keyID andVCode:(NSString *)vCode;

- (BOOL)authenticatedApiRequestWithString:(NSString *)urlString;

- (BOOL)credentialsAreValid;
- (NSNumber *)mainCharacterID;
- (Character *)mainCharacter;

@end
