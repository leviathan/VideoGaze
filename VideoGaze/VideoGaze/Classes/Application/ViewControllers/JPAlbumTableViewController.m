//
//  JPAlbumTableViewController.m
//  VideoGaze
//
//  Created by Jörg Polakowski on 24/11/13.
//  Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#import "JPAlbumTableViewController.h"
#import "MBProgressHUD.h"
#import "JPVimeoEngine.h"
#import "NSObject+SafeConcurrency.h"
#import "JPVimeoVideo.h"
#import "JPVideoCell.h"

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

    [self.tableView registerClass:[JPVideoCell class] forCellReuseIdentifier:@"JPVideoCellClass"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    if (self.vimeoVideos == nil) {
        self.vimeoVideos = [NSMutableArray array];
    }

    // Set the page value for queries to the vimeo API, we start at index = 1 and increment by 1
    self.currentPage = 1;

    [self initializeVimeoEngine];

    // todo dynamize the page parameter
    [self loadAlbumList:[self albumId] page:[self fetchCurrentPage:NO] clear:NO viewReference:self.view];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger rowCount = [self.vimeoVideos count];
//    NSUInteger rowCount = 0; // todo

    if (rowCount == 0) { // show "empty" search results hint
        UILabel *emptyHintLabel = [[UILabel alloc] init];
        emptyHintLabel.backgroundColor = [UIColor clearColor];
        emptyHintLabel.text = @"Leider gab es zu deiner Suche keine Ergebnisse"; // todo localize
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
    static NSString *CellIdentifier = @"JPVideoCellClass";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];



    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.vimeoVideos && (self.vimeoVideos.count == indexPath.row)) {
        // we're displaying the last cell in the table-view, load more data from server
        NSInteger nextPage = [self fetchCurrentPage:YES];
        if (nextPage != -1) {
            [self loadAlbumList:[self albumId] page:nextPage clear:NO viewReference:self.view];
        }
    }
}


#pragma mark private methods

- (void)loadAlbumList:(NSString *)albumId page:(NSUInteger)page clear:(BOOL)clear viewReference:(UIView *)viewReference {
    // present "wait" dialog
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewReference animated:YES];
    hud.labelText = NSLocalizedString(@"JPAlbumTableViewController.loadAlbumList.waitText", nil);

    __weak typeof(self) proxySelf = self;
    [self.vimeoEngine queryVideosForAlbumId:albumId page:page onSuccess:^(MKNetworkOperation *completedOperation) {

        NSMutableArray *videoArray = [NSMutableArray array];
        NSArray *resultsArray = [completedOperation responseJSON];
        [resultsArray each:^(NSDictionary *videoDictionary) {
            [videoArray addObject:[JPVimeoVideo videoFromDictionary:videoDictionary]];
        }];

        [proxySelf runOnMainQueueWithoutDeadlocking:^{
            [MBProgressHUD hideHUDForView:viewReference animated:YES];

            // update table data cache and refresh
            if (clear) {
                [proxySelf.vimeoVideos removeAllObjects];
            }

            [proxySelf.vimeoVideos addObjectsFromArray:videoArray];
            [proxySelf.tableView reloadData];
        }];
    } onFail:^(MKNetworkOperation *completedOperation) {
        [proxySelf runOnMainQueueWithoutDeadlocking:^{
            [MBProgressHUD hideHUDForView:viewReference animated:YES];
        }];
    } onError:^(NSError *error) {
        [proxySelf runOnMainQueueWithoutDeadlocking:^{
            [MBProgressHUD hideHUDForView:viewReference animated:YES];
        }];
    }];
}

#pragma mark - Engine

- (void)initializeVimeoEngine {
    __weak typeof(self) proxySelf = self;
    self.vimeoEngine = [JPAppEnvironment engineWithClass:[JPVimeoEngine class]];
    self.vimeoEngine.reachabilityChangedHandler = ^(NetworkStatus ns) {
        if (ns == NotReachable) {
            // todo
//            [[TRMessageCenter instance] showNotificationInViewController:proxySelf
//                                                               withTitle:$LS(@"Keine Internetverbindung")
//                                                             withMessage:$LS(@"Termine24 ist nicht erreichbar")
//                                                                withType:TSMessageNotificationTypeWarning];
        } else {
            // do nothing
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
