//
//  CategoriesTableViewController.m
//  PhotoViewer
//
//  Created by Max Campolo on 9/2/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

// This table view controller serves as the main view for the app. It contains cells which will each be
// responsible for their own category of images. The table view has paging functionality instead of
// smooth scroll.

// Controller
#import "CategoriesTableViewController.h"
// View
#import "CategoryTableViewCell.h"
#import "CollectionContainerView.h"
// Pod
#import <Toast/UIView+Toast.h>
// Service
#import "InstagramService.h"
#import "HashtagHelper.h"

@interface CategoriesTableViewController () <CollectionContainerViewDelegate>

// Create array to hold image categories
@property (nonatomic, strong) NSMutableArray *categoriesArray;

// These are for expanding an image to full screen
@property (nonatomic, strong) UIImageView *cloneImageView;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation CategoriesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the navigation bar style
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:53.0/255.0 green:70.0/255.0 blue:92.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"#hashtags";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]}];
    
    // Register custom table view cell nib for use within the table view
    UINib *categoryCellNib = [UINib nibWithNibName:@"CategoryTableViewCell" bundle: nil];
    [self.tableView registerNib:categoryCellNib forCellReuseIdentifier:@"CategoryTableViewCell"];
    
    // Here we load the category array
    [self loadCategoryArray];
    
    // Set the background of the tableView to black to match the UI
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // And set paging enabled - Our cells will be the correct height for paging
    [self.tableView setPagingEnabled:YES];
    // But we have to start tableview underneath the nav bar
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // And set scrolls to top to no so user only navigates by swiping
    [self.tableView setScrollsToTop:NO];
    
}

#pragma mark - Helper

- (void)loadCategoryArray {
    if (!_categoriesArray) {
        _categoriesArray = [[NSMutableArray alloc] init];
    }
    // Add categories
    [self.categoriesArray addObject:@"Cats"];
    [self.categoriesArray addObject:@"Sports"];
    [self.categoriesArray addObject:@"Landscape"];
    [self.categoriesArray addObject:@"Food"];
    [self.categoriesArray addObject:@"Cocktail"];
    [self.categoriesArray addObject:@"Family"];
    [self.categoriesArray addObject:@"Taylorswift"];
    [self.categoriesArray addObject:@"Fun"];
    [self.categoriesArray addObject:@"Party"];
    [self.categoriesArray addObject:@"Selfie"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.categoriesArray.count;
}

#pragma mark - Table View Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a category table view cell
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupCellWithTag:[self.categoriesArray objectAtIndex:indexPath.row]];
    // Set the collection view delegate so we can register cell selection from this view controller
    cell.collectionView.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 504;
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Get index path of visible table row - this should only return one path after a page scroll
    NSArray *visible = [self.tableView indexPathsForVisibleRows];
    NSIndexPath *indexpath = (NSIndexPath*)[visible objectAtIndex:0];
    // Get category from array and make toast to display new category
    NSString *category = [self.categoriesArray objectAtIndex:indexpath.row];
    NSString *toastTitle = [NSString stringWithFormat:@"#%@", [category lowercaseString]];
    NSLog(@"making toast");
    [self.view.superview makeToast:toastTitle duration:0.8 position:@"center" title:@"viewing hashtag: "];
}

#pragma mark - CollectionContainerViewDelegate

// This method is for expanding an image to full screen
- (void)didSelectCollectionViewItem:(CollectionContainerView *)containerView withImage:(UIImage *)currentImage {
    NSLog(@"Collection view cell selected");
    // First create a new image view on top of the original image view and set its image to currentImage
    self.cloneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(containerView.collectionView.frame.origin.x + (containerView.collectionView.frame.size.width / 2), containerView.collectionView.frame.origin.y + (containerView.collectionView.frame.size.height / 2), 0, 0)];
    [self.cloneImageView setImage:currentImage];
    [self.cloneImageView setContentMode:UIViewContentModeScaleAspectFit];
    // Then we also create a background view for a nice effect to hide the rest of the app
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.window.frame.size.width, self.view.window.frame.size.height)];
    [self.bgView setBackgroundColor:[UIColor blackColor]];
    [self.bgView setAlpha:0];
    // Add gesture recognizer to the new image view so that we can remove it
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlargedImageTapped:)];
    [self.cloneImageView addGestureRecognizer:tap];
    [self.cloneImageView setUserInteractionEnabled:YES];
    // Add the views as subviews to our current window
    [self.view.window addSubview:self.bgView];
    [self.view.window addSubview:self.cloneImageView];
    // And animate that imageview to full screen
    [UIView animateWithDuration:.5 animations:^{
        [self.cloneImageView setFrame:CGRectMake(0, 0, self.view.window.frame.size.width, self.view.window.frame.size.height)];
        [self.bgView setAlpha:1];
    }];
    
    
}

// Called when collection view in container view is scrolled
- (void)collectionViewDidScroll:(CollectionContainerView *)containerView {
    // Get index path of visible item - again, there is only one item so it should return one path
    NSArray *visible = [containerView.collectionView indexPathsForVisibleItems];
    NSIndexPath *indexPath = (NSIndexPath*)[visible objectAtIndex:0];
    // Get value of index path, add 1 and set it as the position number of the containerView
    [containerView.positionLabel setText:[NSString stringWithFormat:@"%ld/20", (long)indexPath.row + 1]];
    NSLog(@"Collection view did scroll");
    // Set arrows to display which direction(s) user can scroll
    if (indexPath.row + 1 == 1) {
        [containerView.previousImageView setHidden:YES];
    } else if (indexPath.row + 1 == 20) {
        [containerView.nextImageView setHidden:YES];
    } else {
        [containerView.previousImageView setHidden:NO];
        [containerView.nextImageView setHidden:NO];
    }
}

#pragma mark - Action

-(void)enlargedImageTapped:(id)sender {
    // This action is for removing the enlarged image. Just do the opposite of what we did before
    [UIView animateWithDuration:.5 animations:^{
        [self.cloneImageView setFrame:CGRectMake(self.view.window.frame.origin.x + (self.view.window.frame.size.width / 2), self.view.window.frame.origin.y + (self.view.window.frame.size.height / 2), 0, 0)];
        [self.bgView setAlpha:0];
    } completion:^(BOOL finished) {
        [self.cloneImageView removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
}

#pragma mark - Shake Motion Event Required Methods

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

-(void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"Shake detected");
        
        // Get index path of visible table row - this should only return one path after a page
        NSArray *visible = [self.tableView indexPathsForVisibleRows];
        NSIndexPath *indexpath = (NSIndexPath*)[visible objectAtIndex:0];
        // Get the new category - This is a random hashtag from the array
        NSString *newTag = [HashtagHelper getRandomHashtag];
        // Replace the original category string object with the new category string in the array
        [self.categoriesArray replaceObjectAtIndex:indexpath.row withObject:newTag];
        // Reload only the specific cell that has been changed
        [self.tableView reloadRowsAtIndexPaths:visible withRowAnimation:UITableViewRowAnimationFade];
        // Make toast to alert user of the new category they are in
        [self.view.superview makeToast:[NSString stringWithFormat:@"#%@", newTag] duration:0.8 position:@"center" title:@"new hashtag: "];
    }
}


@end
