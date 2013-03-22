//
//  EveAPI.m
//  ForbiddenFruit
//
//  Created by Crazor on 22.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "EveAPI.h"
#import "XMLDictionary.h"

@implementation EveAPI

+ (id)api
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        EveAPI *sharedInstance = [[self alloc] init];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [sharedInstance defaultsChanged:[NSNotification notificationWithName:@"" object:defaults]];

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(defaultsChanged:)
                       name:NSUserDefaultsDidChangeNotification
                     object:nil];

        return sharedInstance;
    });
}

- (void)defaultsChanged:(NSNotification *)notification {
    NSUserDefaults *defaults = (NSUserDefaults *)[notification object];

    self.keyID = [defaults stringForKey:DefaultKeyID];
    self.vCode = [defaults stringForKey:DefaultVCode];
}

- (NSImage *)portraitForCharacter:(NSString *)characterID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://image.eveonline.com/character/%@_128.jpg", characterID]];

    return [[NSImage alloc] initWithContentsOfURL:url];
}

@end
