//
//  CollectionContainerView.h
//  PhotoViewer
//
//  Created by Max Campolo on 9/3/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionContainerView;

@protocol CollectionContainerViewDelegate <NSObject>
@optional
- (void)didSelectCollectionViewItem:(CollectionContainerView*)containerView withImage:(UIImage*)currentImage;
- (void)collectionViewDidScroll:(CollectionContainerView*)containerView;

@end

@interface CollectionContainerView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

// UI Component outlets
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *positionLabel;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UIImageView *nextImageView;
@property (nonatomic, strong) IBOutlet UIImageView *previousImageView;

// Delegate
@property (nonatomic, weak) id<CollectionContainerViewDelegate> delegate;

// Data array that will contain our instagram photo objects
@property (nonatomic, strong) NSMutableArray *instaphotoArray;

// Method that will be called to set up the collection view
- (void)setupViewWithTag:(NSString*)tag ;

@end
