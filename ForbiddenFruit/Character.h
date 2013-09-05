//
//  CharacterAPI.h
//  ForbiddenFruit
//
//  Created by Crazor on 22.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "EveAPI.h"

@interface Character : EveAPI

@property (readonly) EveAPI *api;
@property (readonly) NSNumber *characterID;
@property (readonly) NSImage *portrait;
@property (readonly) NSString *name;
@property (readonly) NSString *corporationName;
@property (readonly) NSNumber *corporationID;
@property (readonly) NSDate *corporationDate;
@property (readonly) NSString *race;
@property (readonly) NSString *bloodline;
@property (readonly) NSNumber *skillPoints;
@property (readonly) NSNumber *securityStatus;
@property (readonly) NSString *lastLocation;
@property (readonly) NSNumber *accountBalance;
@property (readonly) NSDate *nextTrainingEnds;

- (id)initWithCharacterID:(NSNumber *)characterID andAPI:(EveAPI *)api;


@end
