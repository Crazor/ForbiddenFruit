//
//  NSDate+EveDate.m
//  ForbiddenFruit
//
//  Created by Crazor on 23.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "NSDate+EveDate.h"

@implementation NSDate (EveDate)

+ (NSDate *)dateWithEveDate:(NSString *)eveDate
{
    return [NSDate dateWithString:[NSString stringWithFormat:@"%@ +0000", eveDate]];
}

@end
