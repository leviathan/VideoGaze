//
// Created by Jörg Polakowski on 15/05/13.
// Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#import "NSObject+SafeConcurrency.h"

@implementation NSObject (SafeConcurrency)

- (void)runOnMainQueueWithoutDeadlocking:(void (^)())block {
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

@end