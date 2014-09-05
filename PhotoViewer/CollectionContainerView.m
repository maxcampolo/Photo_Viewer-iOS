//
//  CollectionContainerView.m
//  PhotoViewer
//
//  Created by Max Campolo on 9/3/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

// Imports
#import "CollectionContainerView.h"
#import "InstagramService.h"
#import "InstaPhoto.h"
#import "HorizontalCollectionViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import <UIImageView+AFNetworking.h>


@implementation CollectionContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupViewWithTag:(NSString*)tag {
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    // Calls method to set up collection view
    [self.titleLabel setText:[NSString stringWithFormat:@"#%@", [tag lowercaseString]]];
    [self setupCollectionView];
    
    // We only want to load new photos if the array is empty (photos haven't been loaded)
    if ([_instaphotoArray count] == 0 || !_instaphotoArray) {
        [[InstagramService sharedService] fetchMediaForTag:tag withCount:20 onSuccess:^(NSArray *images) {
            // Here is where we're going to populate the collection view
            // We'll just update the data source with objects from our array and let the collectionview delegate handle the rest.
            [self updateCollectionViewDataSource:images];
    
        } onFailure:^{
        // Do nothing here
        }];
    }
}

#pragma mark - Helper

// This method updates the data source for the collection view with the new photos
-(void)updateCollectionViewDataSource:(NSArray*)instaphotos{
    if(!_instaphotoArray)
        _instaphotoArray = [NSMutableArray arrayWithCapacity:instaphotos.count];
    [_instaphotoArray addObjectsFromArray:instaphotos];
    [self.collectionView reloadData];
    
    // Stop the activity indicator and hide it
    [self.activityIndicator stopAnimating];
    [self.activityIndicator setHidden:YES];
}

// Load the collection view cell and set datasource and delegate to self. Register the cell nib for the view.
- (void)setupCollectionView {
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    UINib *collectionCellNib = [UINib nibWithNibName:@"HorizontalCollectionViewCell" bundle: nil];
    [_collectionView registerNib:collectionCellNib forCellWithReuseIdentifier:@"HorizontalCollectionViewCell"];
    
}

#pragma mark - CollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.instaphotoArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Get a Horizontal collection view cell
    HorizontalCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"HorizontalCollectionViewCell" forIndexPath:indexPath];
    
    // Get photo object from array containing photo url
    InstaPhoto *photo = [self.instaphotoArray objectAtIndex:indexPath.row];
    
    // Create a black image to use as a placeholder so the old image isn't in the reused cell at first
    CGSize size = CGSizeMake(320, 504);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [[UIColor blackColor] setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Load image in background thread (lazy load)
    [cell.instaphotoImageView setImageWithURL:[NSURL URLWithString:photo.standardURL] placeholderImage:image];
    // Set likes in current container
    if ([photo.numberLikes integerValue] == 1) {
        [cell.likesLabel setText:[NSString stringWithFormat:@"%@ like", photo.numberLikes]];
    } else {
        [cell.likesLabel setText:[NSString stringWithFormat:@"%@ likes", photo.numberLikes]];
    }
    
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HorizontalCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImage *selectedImage = cell.instaphotoImageView.image;
    // Call delegate for collection view item selected and pass the image
    [self.delegate didSelectCollectionViewItem:self withImage:selectedImage];
}


#pragma mark Scroll View Delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.delegate collectionViewDidScroll:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
