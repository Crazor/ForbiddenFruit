//
//  EveAPI.h
//  ForbiddenFruit
//
//  Created by Crazor on 22.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EveAPI : NSObject

@property NSString *keyID;
@property NSString *vCode;

+ (id)api;

- (NSImage *)portraitForCharacter:(NSString *)characterID;

@end
