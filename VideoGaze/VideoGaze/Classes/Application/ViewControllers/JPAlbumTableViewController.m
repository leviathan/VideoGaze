//
//  JPAlbumTableViewController.m
//  VideoGaze
//
//  Created by Jörg Polakowski on 24/11/13.
//  Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#import "JPAlbumTableViewController.h"
#import "JPVimeoEngine.h"
#import "NSObject+SafeConcurrency.h"
#import "JPVimeoVideo.h"
#import "JPVideoTableViewCell.h"

//***************************************************************************************
// private protocol
//***************************************************************************************
@interface JPAlbumTableViewController ()

@property(strong) JPVimeoEngine *vimeoEngine;

@property(strong) NSMutableArray *vimeoVideos; // Array[JPVimeoVideo]

@property(assign) NSUInteger currentPage;

- (void)loadAlbumList:(NSString *)albumId page:(NSUInteger)page clear:(BOOL)clear viewReference:(UIView *)viewReference;

- (void)initializeVimeoEngine;

/**
* Returns the vimeo album-id, which should be loaded from the server.
* Note: currently fixed to "58"
*/
- (NSString *)albumId;

- (NSInteger)fetchCurrentPage:(BOOL)increment;

@end


//***************************************************************************************
// public implementation
//***************************************************************************************
@implementation JPAlbumTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark view lifecycle events
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"JPAlbumTableViewController.title", nil);

    [self.tableView registerClass:[JPVideoTableViewCell class] forCellReuseIdentifier:[JPVideoTableViewCell reuseIdentifier]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    if (self.vimeoVideos == nil) {
        self.vimeoVideos = [NSMutableArray array];
    }

    [self initializeVimeoEngine];

    // Set the page value for queries to the vimeo API, we start at index = 1 and increment by 1
    self.currentPage = 1;

    [self loadAlbumList:[self albumId] page:[self fetchCurrentPage:NO] clear:NO viewReference:self.view];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger rowCount = [self.vimeoVideos count];

    if (rowCount == 0) { // show "empty" search results hint
        UILabel *emptyHintLabel = [[UILabel alloc] init];
        emptyHintLabel.backgroundColor = [UIColor clearColor];
        emptyHintLabel.text = NSLocalizedString(@"JPAlbumTableViewController.noVideosAvailableYet", nil);
        emptyHintLabel.numberOfLines = 0;
        emptyHintLabel.textAlignment = NSTextAlignmentCenter;
        self.tableView.backgroundView = emptyHintLabel;
    }
    else {
        self.tableView.backgroundView = nil;
    }

    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JPVideoTableViewCell *videoTableViewCell = [tableView dequeueReusableCellWithIdentifier:[JPVideoTableViewCell reuseIdentifier]];

    JPVimeoVideo *video = self.vimeoVideos[(NSUInteger) indexPath.row];
    [videoTableViewCell updateCellWith:video];

    return videoTableViewCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.vimeoVideos && ((self.vimeoVideos.count - 1) == indexPath.row)) {
        // we're displaying the last cell in the table-view, load more data from server
        NSInteger nextPage = [self fetchCurrentPage:YES];
        if (nextPage != -1) {
            [self loadAlbumList:[self albumId] page:nextPage clear:NO viewReference:self.view];
        }
    }

    // 1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation((90.0 * M_PI) / 180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0 / -600;

    // 2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;

    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);

    // 3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

#pragma mark private methods

- (void)loadAlbumList:(NSString *)albumId page:(NSUInteger)page clear:(BOOL)clear viewReference:(UIView *)viewReference {

    __weak typeof(self) proxySelf = self;
    [self.vimeoEngine queryVideosForAlbumId:albumId page:page onSuccess:^(MKNetworkOperation *completedOperation) {

        NSMutableArray *videoArray = [NSMutableArray array];
        NSArray *resultsArray = [completedOperation responseJSON];
        [resultsArray each:^(NSDictionary *videoDictionary) {
            [videoArray addObject:[JPVimeoVideo videoFromDictionary:videoDictionary]];
        }];

        [proxySelf runOnMainQueueWithoutDeadlocking:^{
            // update table data cache and refresh
            if (clear) {
                [proxySelf.vimeoVideos removeAllObjects];
            }

            // 1. update data source
            NSUInteger offset = proxySelf.vimeoVideos.count - 1;
            [proxySelf.vimeoVideos addObjectsFromArray:videoArray];

            // 2. update user interface
            if (clear) {
                [proxySelf.tableView reloadData];
            }
            else {
                [proxySelf.tableView beginUpdates];
                NSMutableArray *indexPathArray = [NSMutableArray array];
                for (int i = 0; i < videoArray.count; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(i + offset) inSection:0];
                    [indexPathArray addObject:indexPath];
                }
                [proxySelf.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                [proxySelf.tableView endUpdates];
            }
        }];
    } onFail:^(MKNetworkOperation *completedOperation) {
        DLog(@"Failed to load images: %@", completedOperation.responseJSON);
    } onError:^(NSError *error) {
        DLog(@"Error loading images: %@", error.localizedDescription);
    }];
}

#pragma mark - Engine

- (void)initializeVimeoEngine {
    __weak typeof(self) proxySelf = self;
    self.vimeoEngine = [JPAppEnvironment engineWithClass:[JPVimeoEngine class]];
    self.vimeoEngine.reachabilityChangedHandler = ^(NetworkStatus ns) {
        if (ns == NotReachable) {
            /**
            * We could inform the user here with a short android-like-toast message
            */
            DLog(@"No Internet connection to the Vimeo API server ....");
        }
    };
}

- (NSString *)albumId {
    return @"58";
}

- (NSInteger)fetchCurrentPage:(BOOL)increment {
    NSInteger page = -1;
    NSUInteger maximumPageNumber = 3;
    if (!increment) {
        page = self.currentPage;
    }
    else {
        if (self.currentPage >= maximumPageNumber) {
            self.currentPage = maximumPageNumber;
        }
        else {
            self.currentPage++;
            page = self.currentPage;
        }
    }
    return page;
}

@end
