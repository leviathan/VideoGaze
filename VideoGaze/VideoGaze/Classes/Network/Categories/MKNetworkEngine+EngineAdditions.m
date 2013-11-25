//
//  MKNetworkEngine+EngineAdditions.m
//
//  Created by Jörg Polakowski on 23/11/13.
//  Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#import "MKNetworkEngine+EngineAdditions.h"

@implementation MKNetworkEngine (EngineAdditions)

#pragma mark Validation

- (BOOL)isSuccessfulOperation:(MKNetworkOperation *)operation {
    return operation.HTTPStatusCode == 200 || operation.HTTPStatusCode == 201;
}

- (BOOL)failedOperationWithError:(NSError *)anError {
    return anError.code == 400 || anError.code == 401;
}

#pragma mark Operation

- (void)setupOperation:(MKNetworkOperation *)op
           withSuccess:(MKNKResponseBlock)success
                  fail:(MKNKResponseBlock)fail
                 error:(MKNKErrorBlock)error {

    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        if ([self isSuccessfulOperation:completedOperation] || [completedOperation isCachedResponse]) {
            if (success) {
                success(completedOperation);
            }
        }
        else {
            if (fail) {
                fail(completedOperation);
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *anError) {
        if ([self failedOperationWithError:anError]) {
            if (fail) {
                fail(completedOperation);
            }
        }
        else {
            if (error) {
                error(anError);
            }
        }
    }];
}

@end
