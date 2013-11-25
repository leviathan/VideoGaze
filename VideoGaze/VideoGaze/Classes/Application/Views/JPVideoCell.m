//
//  JPVideoCell.m
//  VideoGaze
//
//  Created by Jörg Polakowski on 25/11/13.
//  Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#import "JPVideoCell.h"

//***************************************************************************************
// private protocol
//***************************************************************************************
@interface JPVideoCell ()

@property(strong) UIImageView *videoImageView;

@end


//***************************************************************************************
// public implementation
//***************************************************************************************
@implementation JPVideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Create video image view & add to content container
        self.videoImageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        self.videoImageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.videoImageView];

        self.backgroundColor = [UIColor lightGrayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // update video image view, when sizing demands it
    if (!CGRectEqualToRect(self.contentView.frame, self.videoImageView.frame)) {
        self.videoImageView.frame = self.contentView.frame;
    }
}

@end
