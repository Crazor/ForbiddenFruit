//
//  Balance.h
//  ForbiddenFruit
//
//  Created by Crazor on 12.09.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Character;
@class EveAPI;

@interface Balance : NSObject

@property (readonly) Character  *character;
@property (readonly) EveAPI     *api;
@property (readonly) NSNumber   *accountID;
@property (readonly) NSNumber   *accountKey;
@property (readonly) NSNumber   *balance;

- (id)initWithCharacter:(Character *)character;
- (void)refresh;

@end

