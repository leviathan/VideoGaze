//
//  JPAppDelegate.m
//  VideoGaze
//
//  Created by Jörg Polakowski on 23/11/13.
//  Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#import "JPAppDelegate.h"
#import "JPAlbumTableViewController.h"

@implementation JPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // setup navigation bar app-wide appearance
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
            [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0], NSForegroundColorAttributeName,
            shadow, NSShadowAttributeName,
            [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [[UINavigationBar appearance] setBarTintColor:[JPAppDesign blue]];
    }
    else {
        [[UINavigationBar appearance] setTintColor:[JPAppDesign blue]];
    }

    // setup user interface --------------------------------------------------------------------------------
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    JPAlbumTableViewController *albumTableViewController = [[JPAlbumTableViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumTableViewController];
    self.window.rootViewController = navigationController;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
