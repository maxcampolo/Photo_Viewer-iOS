//
//  HorizontalCollectionViewCell.h
//  PhotoViewer
//
//  Created by Max Campolo on 9/3/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizontalCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *instaphotoImageView;
@property (nonatomic, strong) IBOutlet UILabel *likesLabel;

@end
