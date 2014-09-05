//
//  InstagramService.m
//  PhotoViewer
//
//  Created by Max Campolo on 9/2/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

// This class will act as a service for handling all calls to the Instagram API. It uses the AFNetworking
// framework.

// Imports
#import "InstagramService.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "InstaPhoto.h"

// Defines
#define SERVER_ERROR 500
#define BASE_URL @"https://api.instagram.com/v1/"
#define CLIENT_ID @"INSERT CLIENT ID HERE"

@interface InstagramService () {
    AFHTTPRequestOperationManager *manager;
}

- (void)handleErrors:(AFHTTPRequestOperation*)operation;
- (void)configureAPIClient;
- (void)configureRequestOperationManager;
- (void)configureReachability;

@end

// We'll use a shared singleton so create the instance
static InstagramService *instance;

@implementation InstagramService

+ (InstagramService *)sharedService {
    if (!instance) {
        instance = [[InstagramService alloc] init];
        [instance configureAPIClient];
    }
    return instance;
}

# pragma mark - Configuration

- (void)configureAPIClient{
    [self configureRequestOperationManager];
    [self configureReachability];
}

- (void)configureReachability{
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
}

- (void)configureRequestOperationManager{
    AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
}

#pragma mark - Request Methods

// Fetch recent media for a tag. On success we will return the response which is handled in a success block.
- (void)fetchMediaForTag:(NSString*)tag withCount:(NSUInteger)count onSuccess:(void (^)(NSArray *images))success onFailure:(void (^)(void))failure {
    
    NSString *url = [NSString stringWithFormat:@"tags/%@/media/recent?client_id=%@&count=%d", [tag lowercaseString], CLIENT_ID, count];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *images = [[NSArray alloc] init];
        images = [InstaPhoto instaphotosWithArray:[responseObject objectForKey:@"data"]];
        success(images);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleErrors:operation];
        failure();
    }];
}

// Fetch popular hashtag with search query
- (void)fetchTagWithQuery:(NSString*)query onSuccess:(void (^)(NSString *tag))success onFailure:(void(^)(void))failure {
    
    NSString *url = [NSString stringWithFormat:@"tags/search?client_id=%@&q=%@", CLIENT_ID, query];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tags = [[NSArray alloc] init];
        tags = [responseObject objectForKey:@"data"];
        NSString *tag;
        if (!tags.count == 0) {
            tag = [tags[0] objectForKey:@"name"];
        } else {
            tag = nil;
        }
        
        success(tag);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleErrors:operation];
        failure();
    }];
}

#pragma mark - Handler Methods

- (void)handleErrors:(AFHTTPRequestOperation*)operation {
    
    NSString *errorMsg;
    if (operation.response == nil) {
        errorMsg = @"We had a problem trying to fetch the data";
        
    } else if (operation.response.statusCode == SERVER_ERROR) {
        errorMsg = @"Server Error";
    }

    
    [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    
}


@end
