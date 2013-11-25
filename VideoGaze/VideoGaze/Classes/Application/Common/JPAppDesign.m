//
// Created by Jörg Polakowski on 14/10/13.
// Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//


//***************************************************************************************
// private interface declaration
//***************************************************************************************
@interface JPAppDesign ()

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end


//***************************************************************************************
// public interface implementation
//***************************************************************************************
@implementation JPAppDesign

+ (UIColor *)blue {
    return [JPAppDesign colorWithRed:108 green:175 blue:211];
}

#pragma mark private methods

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
}

@end
