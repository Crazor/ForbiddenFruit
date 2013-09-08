//
//  Wallet.h
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

@class EveAPI;

@interface WalletJournal : NSObject;

@property (readonly) Character *character;
@property (readonly) EveAPI *api;
@property (readonly) NSMutableArray *journal;
@property (readonly) NSString *fromID;

- (id)initWithCharacter:(Character *)character;
- (BOOL)refresh;

@end
