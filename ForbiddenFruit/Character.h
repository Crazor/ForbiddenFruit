//
//  CharacterAPI.h
//  ForbiddenFruit
//
//  Created by Crazor on 22.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EveAPI.h"

@interface Character : EveAPI

@property NSNumber *characterID;
@property NSDictionary *result;

- (id)initWithCharacterID:(NSNumber *)characterID;

- (NSImage *)portrait;
- (NSString *)name;
- (NSString *)corporationName;
- (NSNumber *)corporationID;
- (NSDate *)corporationDate;
- (NSString *)race;
- (NSString *)bloodline;
- (NSNumber *)skillPoints;
- (NSNumber *)securityStatus;
- (NSString *)lastLocation;
- (NSNumber *)accountBalance;
- (NSDate *)nextTrainingEnds;

@end
