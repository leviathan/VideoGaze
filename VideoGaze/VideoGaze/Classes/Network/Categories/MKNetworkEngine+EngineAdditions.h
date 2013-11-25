//
//  MKNetworkEngine+EngineAdditions.h
//
//  Created by Jörg Polakowski on 23/11/13.
//  Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface MKNetworkEngine (EngineAdditions)

#pragma mark Validation

- (BOOL)isSuccessfulOperation:(MKNetworkOperation *)operation;

- (BOOL)failedOperationWithError:(NSError *)anError;

#pragma mark Operation

- (void)setupOperation:(MKNetworkOperation *)op
           withSuccess:(MKNKResponseBlock)success
                  fail:(MKNKResponseBlock)fail
                 error:(MKNKErrorBlock)error;

@end
