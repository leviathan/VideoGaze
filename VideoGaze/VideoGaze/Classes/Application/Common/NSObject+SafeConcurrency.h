//
// Created by Jörg Polakowski on 15/05/13.
// Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

@interface NSObject (SafeConcurrency)

/**
* Use this to perform a block on the main thread, without worrying about
* what thread the original method was executed on.
* And without risking a deadlock
*
* Usage:
*
* runOnMainQueueWithoutDeadlocking(^{ // Do stuff });
*/
- (void)runOnMainQueueWithoutDeadlocking:(void (^)())block;

@end