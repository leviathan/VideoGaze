//
//  JPAppEnvironment.h
//
//  Created by Jörg Polakowski on 23/11/13.
//  Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

@interface JPAppEnvironment : NSObject

// Networking

+ (id)engineWithClass:(Class)engineClass;

+ (id)engineWithClass:(Class)engineClass hostName:(NSString *)hostName customHeaderFields:(NSDictionary *)headers;

+ (NSString *)protocol;
+ (NSString *)hostName;
+ (NSString *)host;

@end
