//
//  NSObject+ModelAdditions.m
//
//  Created by Jörg Polakowski on 27/02/13.
//  Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#import "NSObject+ModelAdditions.h"

@implementation NSObject (ModelAdditions)

+ (NSNumber *)numberForKey:(NSString *)key fromDictionary:(NSDictionary *)dict {
    id returnValue = nil;
    id obj = [dict objectForKey:key];
    if (obj && [obj isKindOfClass:[NSNumber class]]) {
        returnValue = obj;
    }
    else if (obj && [obj isKindOfClass:[NSString class]]) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        returnValue = [formatter numberFromString:obj];
    }
    return returnValue;
}

+ (NSString *)stringForKey:(NSString *)key fromDictionary:(NSDictionary *)dict {
    id returnValue = @"";
    id obj = [dict objectForKey:key];
    if (obj && [obj isKindOfClass:[NSString class]]) {
        returnValue = obj;
    }
    return returnValue;
}

+ (BOOL)boolForKey:(NSString *)key fromDictionary:(NSDictionary *)dict {
    id obj = [dict objectForKey:key];
    if (obj && [obj isKindOfClass:[NSNumber class]]) {
        return [obj boolValue];
    }
    return NO;
}

@end
