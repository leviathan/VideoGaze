//
//  NSObject+ModelAdditions.h
//
//  Created by Jörg Polakowski on 27/02/13.
//  Copyright (c) 2013 Jörg Polakowski. All rights reserved.
//

@interface NSObject (ModelAdditions)

/**
* Fetches the object identified by 'key' from 'dict' and tries to parse this value as a number.
*
* If the object is a number per se (e.g. 179) the number parsing is straight forward.
* If the object is a string (e.g. "179"), then a number formatter with decimal style
* if used to convert the string to a number.
*
* Returns the parsed number or nil, if parsing failed or the identified object simply isn't a number.
*/
+ (NSNumber *)numberForKey:(NSString *)key fromDictionary:(NSDictionary *)dict;

/**
* Returns the string, which can be found for 'key' in the dictionary.
* If no element is found an empty string is returned.
*/
+ (NSString *)stringForKey:(NSString *)key fromDictionary:(NSDictionary *)dict;

+ (BOOL)boolForKey:(NSString *)key fromDictionary:(NSDictionary *)dict;

@end
