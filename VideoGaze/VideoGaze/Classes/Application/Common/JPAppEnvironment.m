//
//  JPAppEnvironment.m
//
//  Created by Jörg Polakowski on 23/11/13.
//  Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#import "JPAppEnvironment.h"
#import "MKNetWorkEngine.h"

@implementation JPAppEnvironment

#pragma mark - Networking

+ (id)engineWithClass:(Class)engineClass {
    return [self engineWithClass:engineClass hostName:[JPAppEnvironment hostName] customHeaderFields:nil];
}

+ (id)engineWithClass:(Class)engineClass hostName:(NSString *)hostName customHeaderFields:(NSDictionary *)headers {
    return [[engineClass alloc] initWithHostName:hostName customHeaderFields:headers];
}

+ (NSString *)protocol {
    return @"http";
}

+ (NSString *)hostName {
    return @"vimeo.com";
}

+ (NSString *)host {
    return [NSString stringWithFormat:@"%@://%@", [self protocol], [self hostName]];
}

@end
