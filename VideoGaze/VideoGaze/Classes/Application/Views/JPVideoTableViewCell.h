//
//  JPVideoTableViewCell.h
//  VideoGaze
//
//  A table cell, which represents a video entry.
//
//  Created by Jörg Polakowski on 25/11/13.
//  Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

@class MKNetworkOperation;
@class JPVimeoVideo;

@interface JPVideoTableViewCell : UITableViewCell

@property(nonatomic, strong) MKNetworkOperation *imageLoadingOperation;

/**
* Returns the unique reuse identifier for this table cell.
*/
+ (NSString *)reuseIdentifier;

- (void)updateCellWith:(JPVimeoVideo *)video;

@end
