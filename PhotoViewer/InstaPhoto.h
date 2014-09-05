//
//  InstaPhoto.h
//  PhotoViewer
//
//  Created by Max Campolo on 9/3/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstaPhoto : NSObject

// Model properties
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSString *standardURL;
@property (nonatomic, strong) NSString *numberLikes;

// Methods to return models
+ (InstaPhoto*)instaphotoWithDict:(NSDictionary *)dict;
+ (NSArray*)instaphotosWithArray:(NSArray*)array;

@end
