//
// Created by Jörg Polakowski on 23/11/13.
// Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface JPVimeoEngine : MKNetworkEngine

/**
* Triggers an video request to the vimeo API for the specified 'albumId'.
*
* @param albumId - The ID of the vimeo album.
* @param page - The number of the page which should be requested or -1 if not used.
* @param success - Response block, called when the API call returns successfully. Or nil if not needed
* @param fail - Response block, called in case the API call fails, API returns 4xx status code. Or nil if not needed
* @param error - Response block, called in case of an error, e.g. network down. Or nil if not needed
*/
- (MKNetworkOperation *)queryVideosForAlbumId:(NSString *)albumId
                                         page:(NSUInteger)page
                                    onSuccess:(MKNKResponseBlock)success
                                       onFail:(MKNKResponseBlock)fail
                                      onError:(MKNKErrorBlock)error;

@end
