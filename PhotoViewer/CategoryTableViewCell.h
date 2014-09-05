//
//  CategoryTableViewCell.h
//  PhotoViewer
//
//  Created by Max Campolo on 9/2/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionContainerView;

@interface CategoryTableViewCell : UITableViewCell

// UI Component outlets
@property (nonatomic, strong) CollectionContainerView *collectionView;

// Cell methods
- (void)setupCellWithTag:(NSString*)tag;

@end
