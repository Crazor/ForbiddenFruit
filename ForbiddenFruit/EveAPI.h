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

+ (EveAPI *)api;

- (void)defaultsChanged:(NSNotification *)notification;

- (BOOL)authenticatedApiRequestWithString:(NSString *)urlString;

- (BOOL)credentialsAreValid;
- (NSNumber *)mainCharacterID;
- (Character *)mainCharacter;

- (NSString *)refTypeFromID:(NSString *)refTypeId;

@end
