//
//  CategoryTableViewCell.m
//  PhotoViewer
//
//  Created by Max Campolo on 9/2/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

// This class provides the logic for the cell. Each cell has to be able to set up its own collection view.

#import "CategoryTableViewCell.h"
#import "InstagramService.h"
#import "HorizontalCollectionViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "InstaPhoto.h"
#import "CollectionContainerView.h"


@implementation CategoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Cell setup

// This method sets up a cell with a given tag. The cell passes the tag to the Collection container view to set up the collection view.
- (void)setupCellWithTag:(NSString*)tag {
    // Calls method to set up collection view
    _collectionView = [[NSBundle mainBundle] loadNibNamed:@"CollectionContainerView" owner:self options:nil][0];
    [_collectionView setupViewWithTag:tag];
    
    // Add the collection view as a subview of the cell's content view
    [self.contentView addSubview:_collectionView];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
