//
// Created by Jörg Polakowski on 25/11/13.
// Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#import "JPVimeoImageEngine.h"

@implementation JPVimeoImageEngine

- (id)init {
    self = [super init];
    if (self) {
        [self useCache];
    }
    return self;
}

- (NSString *)cacheDirectoryName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"VimeoImages"];
    return cacheDirectoryName;
}

- (int)cacheMemoryCost {
    return 0;
}

@end
