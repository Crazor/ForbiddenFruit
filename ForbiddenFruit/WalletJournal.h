//
//  Wallet.h
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "EveAPI.h"

@interface WalletJournal : EveAPI

@property (readonly) NSNumber *characterID;
@property (readonly) NSArray *journal;

- (id)initWithCharacterID:(NSNumber *)characterID;

@end
