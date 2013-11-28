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
#import "SSLabel.h"
#import "NSString+HTML.h"

//***************************************************************************************
// private protocol
//***************************************************************************************
@interface JPVideoTableViewCell ()

@property(nonatomic, strong) NSString *loadingVideoImageURLString;

@property(nonatomic, strong) NSString *loadingUserImageURLString;

@property(nonatomic, strong) MKNetworkOperation *videoImageLoadingOperation;

@property(nonatomic, strong) MKNetworkOperation *userImageLoadingOperation;

@property(strong) JPVimeoImageEngine *videoImageEngine;

@property(strong) JPVimeoImageEngine *userImageEngine;

@property(strong) UIImageView *videoImageView;

@property(strong) UIImageView *userImageView;

@property(strong) UILabel *videoTitleLabel;

@property(strong) SSLabel *videoDescriptionLabel;

@property(strong) UILabel *usernameLabel;

@property(strong) UILabel *videoUploadDateLabel;

@end


//***************************************************************************************
// public implementation
//***************************************************************************************
@implementation JPVideoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.contentView.backgroundColor = self.backgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.videoImageEngine = [[JPVimeoImageEngine alloc] initWith:@"VimeoImages"];
        self.userImageEngine = [[JPVimeoImageEngine alloc] initWith:@"UserImages"];
        self.clipsToBounds = YES;

        // Create video image view & add to content container
        self.videoImageView = [[UIImageView alloc] initWithFrame:CGRectNull];
        self.videoImageView.backgroundColor = [UIColor lightGrayColor];
        self.videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.videoImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.videoImageView];

        // video title label & add to image view
        self.videoTitleLabel = [[UILabel alloc] init];
        self.videoTitleLabel.backgroundColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
        self.videoTitleLabel.numberOfLines = 2;
        self.videoTitleLabel.textAlignment = NSTextAlignmentRight;
        self.videoTitleLabel.textColor = [UIColor whiteColor];
        self.videoTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:21.0];
        [self.videoImageView addSubview:self.videoTitleLabel];

        // user profile image
        self.userImageView = [[UIImageView alloc] initWithFrame:CGRectNull];
        self.userImageView.backgroundColor = [UIColor lightGrayColor];
        self.userImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.userImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.userImageView];

        // user name
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        self.usernameLabel.backgroundColor = self.backgroundColor;
        self.usernameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
        [self.contentView addSubview:self.usernameLabel];

        // video description
        self.videoDescriptionLabel = [[SSLabel alloc] initWithFrame:CGRectNull];
        self.videoDescriptionLabel.backgroundColor = self.backgroundColor;
        self.videoDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
        self.videoDescriptionLabel.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
        self.videoDescriptionLabel.numberOfLines = 0;
        [self.contentView addSubview:self.videoDescriptionLabel];

        // video upload date
        self.videoUploadDateLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        self.videoUploadDateLabel.backgroundColor = self.backgroundColor;
        self.videoUploadDateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
        self.videoUploadDateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.videoUploadDateLabel];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // video image
    self.videoImageView.image = nil;
    if (self.videoImageLoadingOperation) {
        [self.videoImageLoadingOperation cancel];
    }
    // user image
    self.userImageView.image = nil;
    if (self.userImageLoadingOperation) {
        [self.userImageLoadingOperation cancel];
    }
    // title
    self.videoTitleLabel.text = @"";
    // user name
    self.usernameLabel.text = @"";
    // video description
    self.videoDescriptionLabel.text = @"";
    // upload date
    self.videoUploadDateLabel.text = @"";
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // update video image view, when sizing demands it
    self.videoImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 130.0f);

    CGFloat spacing = 5.0;
    CGFloat minSpacing = 3.0;
    self.userImageView.frame = CGRectMake(spacing,
            CGRectGetMaxY(self.videoImageView.frame) + spacing, 25.0, 25.0);

    // update video title label
    self.videoTitleLabel.frame = self.videoImageView.frame;
    [self.videoTitleLabel sizeToFit];

    // update username label
    self.usernameLabel.frame = CGRectMake(CGRectGetMaxX(self.userImageView.frame) + spacing, self.userImageView.y,
            150.0f, self.userImageView.height);

    // update video upload date label
    self.videoUploadDateLabel.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - (70.0 + spacing),
            self.usernameLabel.y, 70.0, self.usernameLabel.height);

    // update video description label
    self.videoDescriptionLabel.frame = CGRectMake(spacing, CGRectGetMaxY(self.userImageView.frame) + minSpacing,
            CGRectGetWidth(self.contentView.frame) - 2 * spacing,
            CGRectGetHeight(self.contentView.frame) - CGRectGetMaxY(self.userImageView.frame) - 2 * minSpacing);
}

- (void)updateCellWith:(JPVimeoVideo *)video {

    // remember the video URL    to enable checking the URL later on when the real image is retrieved.
    self.loadingVideoImageURLString = [video.thumbnailLargeURL absoluteString];
    self.loadingUserImageURLString = [video.userPortraitHugeURL absoluteString];

    // update title
    self.videoTitleLabel.text = video.videoTitle;
    // update username
    self.usernameLabel.text = video.userName;

    // update video description
    /**
    * JPO: Video description comes along as HTML. Using a simple brute force html parser category here.
    * Another more fancy way would be to use a full-fledged text parser like
    * https://github.com/Cocoanetics/DTCoreText
    * But for now that will do.
    */
    self.videoDescriptionLabel.text = [video.videoDescription stringByConvertingHTMLToPlainText];

    // update video upload date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"mm.dd.yyyy";
    self.videoUploadDateLabel.text = [formatter stringFromDate:video.videoUploadDate];

    self.videoImageView.image = nil;
    self.userImageView.image = nil;

    __block typeof (self) weakSelf = self;
    void (^updateVideoImageBlock)(UIImage *, NSURL *, BOOL) = ^(UIImage *image, NSURL *url, BOOL isInCache) {
        // Assigning an image that has not yet been decoded leads to stuttering in UI animations
        // Forcing image decoding on a background thread fixes this
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {

            // Force image decoding
            UIGraphicsBeginImageContext(image.size);
            [image drawAtPoint:CGPointZero];
            __block UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            // Show image view on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView setAnimationBeginsFromCurrentState:YES];
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.videoImageView.image = img;
                    weakSelf.videoImageView.alpha = 1.0f;
                }];
            });
        });
    };
    void (^updateUserImageBlock)(UIImage *, NSURL *, BOOL) = ^(UIImage *image, NSURL *url, BOOL isInCache) {
        // Assigning an image that has not yet been decoded leads
        // to stuttering in UI animations
        // Forcing image decoding on a background thread fixes this
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {

            // Force image decoding
            UIGraphicsBeginImageContext(image.size);
            [image drawAtPoint:CGPointZero];
            __block UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            // Show image view on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView setAnimationBeginsFromCurrentState:YES];
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.userImageView.image = img;
                    weakSelf.userImageView.alpha = 1.0f;
                }];
            });
        });
    };

    // update video image
    __weak typeof (self.videoImageView) proxyVideoImageView = self.videoImageView;
    self.videoImageLoadingOperation = [self.videoImageEngine imageAtURL:video.thumbnailLargeURL completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        if ([self.loadingVideoImageURLString isEqualToString:[url absoluteString]]) {
            updateVideoImageBlock(fetchedImage, url, isInCache);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        DLog(@"Image Retrieve Error: %@", [error localizedDescription]);
    }];

    // update user image
    __weak typeof (self.userImageView) proxyUserImageView = self.userImageView;
    self.userImageLoadingOperation = [self.userImageEngine imageAtURL:video.userPortraitHugeURL completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        if ([self.loadingUserImageURLString isEqualToString:[url absoluteString]]) {
            updateUserImageBlock(fetchedImage, url, isInCache);
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
