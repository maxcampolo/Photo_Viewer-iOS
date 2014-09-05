//
//  InstaPhoto.m
//  PhotoViewer
//
//  Created by Max Campolo on 9/3/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import "InstaPhoto.h"

@implementation InstaPhoto

// Initialize a InstaPhoto object from a dictionary (returned from Instagram API)
- (id)initWithDict:(NSDictionary*)dict {
    self = [super init];
    
    if (self) {
        _thumbnailURL = [[[dict objectForKey:@"images"] objectForKey:@"thumbnail" ] objectForKey:@"url"];
        _standardURL = [[[dict objectForKey:@"images"] objectForKey:@"standard_resolution" ] objectForKey:@"url"];
        _numberLikes = [[dict objectForKey:@"likes"] valueForKey:@"count"];
    }
    
    return self;
}

// Return InstaPhoto model with dictionary
+ (InstaPhoto*)instaphotoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

// Return InstaPhoto models for each dictionary in array of dictionaries
+ (NSArray*)instaphotosWithArray:(NSArray*)array {
    NSMutableArray *instaphotos = [NSMutableArray array];
    for(NSDictionary *dc in array){
        InstaPhoto *instaphoto = [InstaPhoto instaphotoWithDict:dc];
        [instaphotos addObject:instaphoto];
    }
    return [NSArray arrayWithArray:instaphotos];
}

@end
