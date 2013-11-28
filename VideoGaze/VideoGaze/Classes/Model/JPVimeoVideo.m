//
// Created by Jörg Polakowski on 24/11/13.
// Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#import "JPVimeoVideo.h"
#import "NSObject+ModelAdditions.h"

@implementation JPVimeoVideo

+ (JPVimeoVideo *)videoFromDictionary:(NSDictionary *)dict {
    JPVimeoVideo *video = [[JPVimeoVideo alloc] init];

    video.videoId = [self numberForKey:@"id" fromDictionary:dict];
    video.videoTitle = [self stringForKey:@"title" fromDictionary:dict];
    video.videoDescription = [self stringForKey:@"description" fromDictionary:dict];
    video.videoDuration = [self numberForKey:@"duration" fromDictionary:dict];

    // date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    video.videoUploadDate = [formatter dateFromString:[self stringForKey:@"upload_date" fromDictionary:dict]];

    // video thumbnails
    NSString *thumbnailLarge = [self stringForKey:@"thumbnail_large" fromDictionary:dict];
    video.thumbnailLargeURL = [NSURL URLWithString:thumbnailLarge];

    NSString *thumbnailMedium = [self stringForKey:@"thumbnail_medium" fromDictionary:dict];
    video.thumbnailMediumURL = [NSURL URLWithString:thumbnailMedium];

    NSString *thumbnailSmall = [self stringForKey:@"thumbnail_small" fromDictionary:dict];
    video.thumbnailSmallURL = [NSURL URLWithString:thumbnailSmall];

    // user values
    NSString *userPortraitHuge = [self stringForKey:@"user_portrait_huge" fromDictionary:dict];
    video.userPortraitHugeURL = [NSURL URLWithString:userPortraitHuge];

    video.userName = [self stringForKey:@"user_name" fromDictionary:dict];

    return video;
}

@end
