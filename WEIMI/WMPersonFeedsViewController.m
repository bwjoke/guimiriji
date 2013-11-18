//
//  WMPersonFeedsViewController.m
//  WEIMI
//
//  Created by mzj on 13-2-28.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMPersonFeedsViewController.h"
#import "WMHoneyPostTableCell.h"
#import "WMHoneyPersonFeedCell.h"
#import "WMPersonFeedsViewControllerDelegate.h"

#define kPersonPostCellRowIndex 0

@interface WMPersonFeedsViewController ()

@property (nonatomic, assign) CGFloat postCellHeight;
@property (nonatomic, assign) CGFloat feedCellBaseHeight;
@property (nonatomic, retain) NSMutableDictionary *feedCellsHeightCache;

@property (nonatomic, retain) UINib *postCellNib;
@property (nonatomic, retain) UINib *feedCellNib;

- (void)swipeTableView:(UISwipeGestureRecognizer *)gesture;

- (void)clearRecreateData;
- (void)configFeedCell:(WMHoneyPersonFeedCell *)feedCell withData:(id)feedData;

- (void)clickPostFeedButton:(id)sender;

@end

@implementation WMPersonFeedsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_feedCellsHeightCache release];
    _feedCellsHeightCache = nil;
    
    [self clearRecreateData];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self clearRecreateData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    WMHoneyPostTableCell *cell = [[self.postCellNib instantiateWithOwner:self options:nil] lastObject];
    self.postCellHeight = CGRectGetHeight(cell.bounds);
    
    WMHoneyPersonFeedCell *feedCell = [[self.feedCellNib instantiateWithOwner:self options:nil]
                                       lastObject];
    self.feedCellBaseHeight = CGRectGetHeight(feedCell.bounds);
    
    self.feedCellsHeightCache = [NSMutableArray array];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(swipeTableView:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    [self.showTableView addGestureRecognizer:swipeGesture];
    [swipeGesture release];
    
    
    swipeGesture = [[UISwipeGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(swipeTableView:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.showTableView addGestureRecognizer:swipeGesture];
    [swipeGesture release];
}

#pragma mark -
#pragma mark -- UITableView Datasource
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *ret = nil;
    
    if (indexPath.row == kPersonPostCellRowIndex) {
        static NSString * PostCellIdentifier = @"WMHoneyPostTableCell";
        
        WMHoneyPostTableCell *postCell = (WMHoneyPostTableCell *)[tableView dequeueReusableCellWithIdentifier:PostCellIdentifier];
        if (postCell == nil) {
            postCell = [[self.postCellNib instantiateWithOwner:self options:nil] lastObject];
            [postCell.postButton addTarget:self
                                    action:@selector(clickPostFeedButton:)
                          forControlEvents:UIControlEventTouchUpInside];
        }
        
        ret = postCell;
    }
    else {
        static NSString * FeedCellIdentifier = @"WMHoneyPersonFeedCell";
        
        WMHoneyPersonFeedCell *feedCell = (WMHoneyPersonFeedCell *)[tableView dequeueReusableCellWithIdentifier:FeedCellIdentifier];
        if (feedCell == nil) {
            feedCell = [[self.feedCellNib instantiateWithOwner:self options:nil] lastObject];
        }
        
        id feedData = self.dataSource[indexPath.row - 1];
        [self configFeedCell:feedCell withData:feedData];
        
        ret = feedCell;
    }
    
    return ret;
}

#pragma mark -
#pragma mark -- UITableView Delegate
#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat ret = 0.0;
    
    if (indexPath.row == kPersonPostCellRowIndex) {
        ret = self.postCellHeight;
    }
    else {
        NSNumber *rowIndex = [NSNumber numberWithInteger:indexPath.row];
        NSNumber *cachedHeight = [self.feedCellsHeightCache objectForKey:rowIndex];
        if (cachedHeight != nil) {
            ret = cachedHeight.floatValue;
        }
        else {
            ret = self.feedCellBaseHeight;
        }
    }
    
    return ret;
}

#pragma mark -
#pragma mark -- Private Functions
#pragma mark -

- (void)clearRecreateData {
    [_postCellNib release];
    _postCellNib = nil;
    
    [_feedCellNib release];
    _feedCellNib = nil;
}

- (void)configFeedCell:(WMHoneyPersonFeedCell *)feedCell withData:(id)feedData {
    
}

#pragma mark -
#pragma mark -- Set/Get Functions
#pragma mark -

- (UINib*)postCellNib {
    if (_postCellNib == nil) {
        _postCellNib = [[UINib nibWithNibName:@"WMHoneyPostTableCell"
                                       bundle:nil] retain];
    }
    return _postCellNib;
}

- (UINib*)feedCellNib {
    if (_feedCellNib == nil) {
        _feedCellNib = [[UINib nibWithNibName:@"WMHoneyPersonFeedCell"
                                       bundle:nil] retain];
    }
    return _feedCellNib;
}

#pragma mark -
#pragma mark -- Gesture Recognizer Functions
#pragma mark -

- (void)swipeTableView:(UISwipeGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(tableViewDidSwipe:)]) {
            [self.delegate tableViewDidSwipe:gesture];
        }
    }
}

#pragma mark -
#pragma mark -- UI Actions
#pragma mark -

- (void)clickPostFeedButton:(id)sender {
    
}

@end
