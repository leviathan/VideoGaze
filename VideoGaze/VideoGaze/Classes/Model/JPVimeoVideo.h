//
// Created by Jörg Polakowski on 24/11/13.
// Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

@interface JPVimeoVideo : NSObject

// Video properties -----------------------------------------------------------

/** The video ID */
@property(strong) NSNumber *videoId;

/** The video title */
@property(strong) NSString *videoTitle;

/** The video description */
@property(strong) NSString *videoDescription;
/** Duration of the video in seconds */
@property(strong) NSNumber *videoDuration;

/** URL to a small version of the thumbnail */
@property(strong) NSURL *thumbnailSmallURL;

/** URL to a medium version of the thumbnail */
@property(strong) NSURL *thumbnailMediumURL;

/** URL to a large version of the thumbnail */
@property(strong) NSURL *thumbnailLargeURL;

/** The date the video was uploaded on. */
@property(strong) NSDate *videoUploadDate;

// User properties ------------------------------------------------------------

/** The user name of the video’s uploader */
@property(strong) NSString *userName;

/** URL to the small user portrait (30px) */
@property(strong) NSURL *userPortraitSmallURL;

/** URL to the medium user portrait (75px) */
@property(strong) NSURL *userPortraitMediumURL;

/** URL to the huge user portrait (300px) */
@property(strong) NSURL *userPortraitHugeURL;


// Factory

/**
* Returns a newly created video object, which has been initialized with the provided dict's data.
*/
+ (JPVimeoVideo *)videoFromDictionary:(NSDictionary *)dict;

@end
