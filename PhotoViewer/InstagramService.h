//
//  InstagramService.h
//  PhotoViewer
//
//  Created by Max Campolo on 9/2/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramService : NSObject

+ (InstagramService *)sharedService;

- (void)fetchMediaForTag:(NSString*)tag withCount:(NSUInteger)count onSuccess:(void (^)(NSArray *images))success onFailure:(void (^)(void))failure;

- (void)fetchTagWithQuery:(NSString*)query onSuccess:(void (^)(NSString *tag))success onFailure:(void(^)(void))failure;

@end
