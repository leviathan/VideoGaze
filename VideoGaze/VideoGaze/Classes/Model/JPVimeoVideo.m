//
// Created by Jörg Polakowski on 24/11/13.
// Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#import "JPVimeoVideo.h"
#import "NSObject+ModelAdditions.h"

@implementation JPVimeoVideo

+ (JPVimeoVideo *)videoFromDictionary:(NSDictionary *)dict {
    JPVimeoVideo *video = [[JPVimeoVideo alloc] init];

    // todo parse the dict values

    video.videoId = [self numberForKey:@"id" fromDictionary:dict];
    video.videoTitle = [self stringForKey:@"title" fromDictionary:dict];
    video.videoDescription = [self stringForKey:@"description" fromDictionary:dict];
//    video.videoUploadDate = [self ] todo data parsing "upload_date"  -- 2007-09-21 20:36:30
    video.videoDuration = [self numberForKey:@"duration" fromDictionary:dict];

    NSString *thumbnailLarge = [self stringForKey:@"thumbnail_large" fromDictionary:dict];
    video.thumbnailLargeURL = [NSURL URLWithString:thumbnailLarge];

    return video;
}

@end
