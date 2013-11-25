//
// Created by Jörg Polakowski on 14/10/13.
// Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_RETINA ([UIScreen mainScreen].scale > 1.0)


@interface JPAppDesign : NSObject

// Colors

+ (UIColor *)blue;

@end