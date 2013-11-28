//
// Created by Jörg Polakowski on 25/11/13.
// Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#import <objc/runtime.h>
#import "JPVimeoImageEngine.h"

//***************************************************************************************
// private protocol
//***************************************************************************************
@interface JPVimeoImageEngine ()

@property(nonatomic, strong) NSString *cacheName;

@end


//***************************************************************************************
// public implementation
//***************************************************************************************
@implementation JPVimeoImageEngine

- (id)initWith:(NSString *)cacheName {
    self = [super init];
    if (self) {
        self.cacheName = cacheName;
        [self useCache];
    }
    return self;
}

- (NSString *)cacheDirectoryName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:self.cacheName];
    return cacheDirectoryName;
}

- (int)cacheMemoryCost {
    return 0;
}

- (NSString *)cacheName {
    return _cacheName ? _cacheName : NSStringFromClass([self class]);
}

@end
