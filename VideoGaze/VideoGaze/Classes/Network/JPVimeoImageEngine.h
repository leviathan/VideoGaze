//
// Created by Jörg Polakowski on 25/11/13.
// Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//
// A image engine, which persists downloaded images to the documents directory.
//
//

#import <MKNetworkKit/MKNetworkEngine.h>

@interface JPVimeoImageEngine : MKNetworkEngine

/**
* Returns a newly created engine with the provided cache-name
*
* @params cacheName - The name of the cache directory that will be used by the engine.
* When nil, a default name will be used.
*/
- (id)initWith:(NSString *)cacheName;

@end
