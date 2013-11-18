//
//  WMHoneyViewController.m
//  WEIMI
//
//  Created by King on 2/25/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMHoneyViewController.h"
#import "WMPersonTagViewController.h"
#import "WMPersonFeedsViewController.h"
#import "WMInviteHoneyViewController.h"

@interface WMHoneyViewController ()

@property (nonatomic, retain) WMPersonTagViewController *ptvc;
@property (nonatomic, retain) UIViewController *currentShowingVC;


//@property (nonatomic, retain) WMPersonFeedsViewController *pfvc;
//@property (nonatomic, retain) WMInviteHoneyViewController *ihvc;

@property (nonatomic, assign) BOOL isLeftPart;

- (void)swipeBackground:(UISwipeGestureRecognizer *)gesture;
- (BOOL)isCanMoveBookWithSwipeDirection:(UISwipeGestureRecognizerDirection)direction;
- (CGPoint)positionOfBookAnimationWithSwipeDirection:(UISwipeGestureRecognizerDirection)direction;
- (CGPoint)positionOfShowingVCAnimationWithSwipeDirection:(UISwipeGestureRecognizerDirection)direction;

- (void)showNewViewWithViewClass:(Class)viewClass andData:(id)showData;
- (void)setupFeedView:(WMPersonFeedsViewController *)pfvc;

- (void)selectedPersonTagWithPersonInfo:(id)personInfo;

@end

@implementation WMHoneyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isLeftPart = YES;
    }
    return self;
}

- (void)dealloc {
    [_ptvc release];
    _ptvc = nil;
    
//    [_pfvc release];
//    _pfvc = nil;
    
    [_currentShowingVC release];
    _currentShowingVC = nil;
    
    [_bookBackgroundImageView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.ptvc = [[[WMPersonTagViewController alloc] init] autorelease];
    self.ptvc.target = self;
    self.ptvc.selectTagAction = @selector(selectedPersonTagWithPersonInfo:);
    [self.view insertSubview:self.ptvc.view belowSubview:self.bookBackgroundImageView];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(swipeBackground:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGesture];
    [swipeGesture release];
    
    
    swipeGesture = [[UISwipeGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(swipeBackground:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGesture];
    [swipeGesture release];
}

- (void)viewDidUnload {
    [self setBookBackgroundImageView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark -- GestureRecognizer Functions
#pragma mark -

- (void)swipeBackground:(UISwipeGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        UISwipeGestureRecognizerDirection swipeDirection = gesture.direction;
        BOOL isCanMove = [self isCanMoveBookWithSwipeDirection:swipeDirection];
        if (isCanMove) {
            static NSTimeInterval moveDuration = 0.3;
            
            CGPoint toPosition = [self positionOfBookAnimationWithSwipeDirection:swipeDirection];
            CGPoint svcDestPos = [self positionOfShowingVCAnimationWithSwipeDirection:swipeDirection];
            [UIView animateWithDuration:moveDuration
                             animations:^{
                                 self.bookBackgroundImageView.center = toPosition;
                                 self.currentShowingVC.view.center = svcDestPos;
                             }
                             completion:^(BOOL finished) {
                                 if (finished) {
                                     self.isLeftPart = !self.isLeftPart;
                                 }
                             }];
        }
    }
}

#pragma mark -
#pragma mark -- Private Functions
#pragma mark -

- (BOOL)isCanMoveBookWithSwipeDirection:(UISwipeGestureRecognizerDirection)direction {
    BOOL isCanMove = YES;
    
    if (direction == UISwipeGestureRecognizerDirectionLeft) {
        isCanMove = self.isLeftPart;
    }
    else {
        isCanMove = !self.isLeftPart;
    }
    
    return isCanMove;
}

- (CGPoint)positionOfBookAnimationWithSwipeDirection:(UISwipeGestureRecognizerDirection)direction {
    static CGFloat moveXDiffConstant = 15.0;
    
    CGRect screenBound = [UIScreen mainScreen].bounds;
    CGFloat moveXOffset = CGRectGetWidth(screenBound) - moveXDiffConstant;
    
    if (direction == UISwipeGestureRecognizerDirectionLeft) {
        moveXOffset = -moveXOffset;
    }
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(moveXOffset, 0);
    
    CGPoint backgroundCurrentPosition = self.bookBackgroundImageView.center;
    CGPoint toPosition = CGPointApplyAffineTransform(backgroundCurrentPosition,
                                                     transform);
    
    return toPosition;
}

- (CGPoint)positionOfShowingVCAnimationWithSwipeDirection:(UISwipeGestureRecognizerDirection)direction {
    CGRect screenBound = [UIScreen mainScreen].bounds;
    
    CGFloat moveXOffset = CGRectGetWidth(screenBound);
    if (direction == UISwipeGestureRecognizerDirectionLeft) {
        moveXOffset = -moveXOffset;
    }
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(moveXOffset, 0);
    
    CGPoint vcCurrentPosition = self.currentShowingVC.view.center;
    CGPoint toPosition = CGPointApplyAffineTransform(vcCurrentPosition, transform);
    
    return toPosition;
}

- (void)showNewViewWithViewClass:(Class)viewClass andData:(id)showData {
    [self.currentShowingVC.view removeFromSuperview];
    self.currentShowingVC = nil;
    
    self.currentShowingVC = [[[viewClass alloc] init] autorelease];
    self.currentShowingVC.view.center = CGPointMake(self.view.center.x,
                                                    self.bookBackgroundImageView.center.y - 5);
    
    if ([self.currentShowingVC isMemberOfClass:[WMPersonFeedsViewController class]]) {
        WMPersonFeedsViewController *pfvc = (WMPersonFeedsViewController *)self.currentShowingVC;
        [self setupFeedView:pfvc];
    }
    else if ([self.currentShowingVC isMemberOfClass:[WMInviteHoneyViewController class]]) {
        
    }
    
    [self.view addSubview:self.currentShowingVC.view];
}

- (void)setupFeedView:(WMPersonFeedsViewController *)pfvc {
    CGRect feedTableViewBounds = CGRectInset(self.view.bounds, 30, 50);
    pfvc.view.bounds = feedTableViewBounds;
    pfvc.contentView.frame = pfvc.view.bounds;
    pfvc.showTableView.frame = pfvc.contentView.bounds;
    pfvc.delegate = self;
}

- (void)selectedPersonTagWithPersonInfo:(id)personInfo {
    [self showNewViewWithViewClass:[WMInviteHoneyViewController class] andData:nil];
}

#pragma mark -
#pragma mark -- WMPersonFeedsViewControllerDelegate
#pragma mark -

- (void)tableViewDidSwipe:(UISwipeGestureRecognizer *)swipeGesture {
    [self swipeBackground:swipeGesture];
}

@end
