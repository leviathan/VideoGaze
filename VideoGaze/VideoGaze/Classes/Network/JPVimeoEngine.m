//
// Created by Jörg Polakowski on 23/11/13.
// Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//


#import "JPVimeoEngine.h"
#import "MKNetworkEngine+EngineAdditions.h"

// Constants
static NSString *const kJPVimeoAlbumRequestApiBaseURLPath = @"api/v2/album/:album_id/videos.json";


@implementation JPVimeoEngine

- (MKNetworkOperation *)queryVideosForAlbumId:(NSString *)albumId
                                         page:(NSUInteger)page
                                    onSuccess:(MKNKResponseBlock)success
                                       onFail:(MKNKResponseBlock)fail
                                      onError:(MKNKErrorBlock)error {

    NSString *queryPath = [kJPVimeoAlbumRequestApiBaseURLPath stringByReplacingOccurrencesOfString:@":album_id"
                                                                                        withString:albumId];
    if (page != -1) {
        queryPath = [queryPath stringByAppendingFormat:@"?page=%d", page];
    }

    MKNetworkOperation *op = [self operationWithPath:queryPath
                                              params:nil
                                          httpMethod:@"GET"
                                                 ssl:NO];
    DLog(@"%@", [op url]);

    [self setupOperation:op withSuccess:success fail:fail error:error];
    [self enqueueOperation:op];
    return op;
}

@end
