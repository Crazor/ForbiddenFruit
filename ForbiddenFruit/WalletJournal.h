//
//  Wallet.h
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

@class EveAPI;

@interface WalletJournal : NSObject;

@property (readonly) EveAPI *api;
@property (readonly) NSNumber *characterID;
@property (readonly) NSArray *journal;

- (id)initWithCharacterID:(NSNumber *)characterID andAPI:(EveAPI *)api;

@end
