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

@class EveAPI;
@class Balance;

@interface Character : NSObject

@property (readonly) EveAPI *api;
@property (readonly) Balance *balance;

@property (readonly) NSString *characterID;
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

- (id)initWithCharacterID:(NSString *)characterID andAPI:(EveAPI *)api;
- (void)refresh;

@end
