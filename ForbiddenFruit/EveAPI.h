//
//  EveAPI.h
//  ForbiddenFruit
//
//  Created by Crazor on 22.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

@class Character;

@interface EveAPI : NSObject

@property (readonly) NSString *keyID;
@property (readonly) NSString *vCode;

@property NSDictionary *response;
@property NSDictionary *result;

+ (NSString *)refTypeFromID:(NSString *)refTypeId;
+ (void)setAccounts:(NSMutableDictionary *)accounts;
+ (NSMutableDictionary *)accounts;

+ (EveAPI *)apiForKeyID:(NSString *)keyID;

- (id)initWithKeyID:(NSString *)keyID andVCode:(NSString *)vCode;

- (BOOL)authenticatedApiRequestWithString:(NSString *)urlString;

- (BOOL)credentialsAreValid;
- (NSNumber *)mainCharacterID;
- (Character *)mainCharacter;

@end
