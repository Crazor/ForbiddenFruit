//
//  EveAPI.h
//  ForbiddenFruit
//
//  Created by Crazor on 22.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Character;

@interface EveAPI : NSObject

@property NSString *keyID;
@property NSString *vCode;

+ (EveAPI *)api;

- (void)defaultsChanged:(NSNotification *)notification;

- (BOOL)credentialsAreValid;
- (NSNumber *)mainCharacterID;
- (Character *)mainCharacter;

@end
