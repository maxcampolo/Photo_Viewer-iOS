//
//  HashtagHelper.m
//  PhotoViewer
//
//  Created by Max Campolo on 9/4/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import "HashtagHelper.h"

@implementation HashtagHelper

+ (NSString*)getRandomHashtag {
    NSArray *hashtagArray = @[@"love", @"TagsForLikes", @"Summer", @"tweegram", @"photooftheday", @"amazing", @"smile", @"fashion", @"look", @"friends", @"picoftheday", @"chill", @"style", @"sunset", @"beach", @"night", @"yum", @"animals", @"music", @"books", @"videogames"];
    
    uint32_t rnd = arc4random_uniform([hashtagArray count]);
    NSString *randomTag = [hashtagArray objectAtIndex:rnd];
    
    return randomTag;

}

@end
