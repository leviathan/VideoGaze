//
//  JPVideoTableViewCell.m
//  VideoGaze
//
//  Created by Jörg Polakowski on 25/11/13.
//  Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#import <MKNetworkKit/MKNetworkOperation.h>
#import "JPVideoTableViewCell.h"
#import "JPVimeoVideo.h"
#import "JPVimeoImageEngine.h"

//***************************************************************************************
// private protocol
//***************************************************************************************
@interface JPVideoTableViewCell ()

@property(nonatomic, strong) NSString *loadingImageURLString;

@property(nonatomic, strong) MKNetworkOperation *imageLoadingOperation;

@property(strong) UIImageView *videoImageView;

@property(strong) UILabel *videoTitleLabel;

@end


//***************************************************************************************
// public implementation
//***************************************************************************************
@implementation JPVideoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Create video image view & add to content container
        self.videoImageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        self.videoImageView.backgroundColor = [UIColor lightGrayColor];
        self.videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        [self.contentView addSubview:self.videoImageView];

        // video title label & add to image view
        self.videoTitleLabel = [[UILabel alloc] init];
        self.videoTitleLabel.backgroundColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
        self.videoTitleLabel.numberOfLines = 2;
        self.videoTitleLabel.textAlignment = NSTextAlignmentRight;
        self.videoTitleLabel.textColor = [UIColor whiteColor];
        self.videoTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:21.0];
        [self.videoImageView addSubview:self.videoTitleLabel];

        self.backgroundColor = [UIColor lightGrayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // image
    self.videoImageView.image = nil;
    if (self.imageLoadingOperation) {
        [self.imageLoadingOperation cancel];
    }
    // title
    self.videoTitleLabel.text = @"";
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // update video image view, when sizing demands it
    if (!CGRectEqualToRect(self.contentView.frame, self.videoImageView.frame)) {
        self.videoImageView.frame = self.contentView.frame;
    }

    // update video title label
    self.videoTitleLabel.frame = self.videoImageView.frame;
    [self.videoTitleLabel sizeToFit];
}

- (void)updateCellWith:(JPVimeoVideo *)video {
    // remember the video URL to enable checking the URL later on when the real image is retrieved.
    self.loadingImageURLString = [video.thumbnailLargeURL absoluteString];

    // update title
    self.videoTitleLabel.text = video.videoTitle;

    // update image
    self.videoImageView.image = nil;
    __weak typeof (self.videoImageView) proxyVideoImageView = self.videoImageView;
    JPVimeoImageEngine *engine = [[JPVimeoImageEngine alloc] init];
    self.imageLoadingOperation = [engine imageAtURL:video.thumbnailLargeURL completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        if ([self.loadingImageURLString isEqualToString:[url absoluteString]]) {
            proxyVideoImageView.image = fetchedImage;
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        DLog(@"Image Retrieve Error: %@", [error localizedDescription]);
    }];
}

#pragma mark - Class-Level Definitions

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([JPVideoTableViewCell class]);
    });

    return __reuseIdentifier;
}

@end
