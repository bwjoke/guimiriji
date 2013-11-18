//
//  WMBookViewController.m
//  WEIMI
//
//  Created by King on 2/25/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMBookViewController.h"
#import "WMHoneyViewController.h"
#import "WMMenWikiViewController.h"
#import "WMHomeViewController.h"

enum BookSwitchState {
    RedBookState = 0,
    BlueBookState,
};

enum BookViewAnimationType {
    BookViewFadein = 0,
    BookViewFadeout,
};

@interface WMBookViewController ()

@property (nonatomic, assign) enum BookSwitchState currentBookState;
@property (nonatomic, retain) WMHomeViewController *hvc;
@property (nonatomic, retain) WMMenWikiViewController *mwvc;

- (void)switchBookWithState:(enum BookSwitchState)state;
- (CGRect)bookTagFrameWithState:(enum BookSwitchState)state;
- (UIImage*)bookTagImageWithState:(enum BookSwitchState)state;

- (void)tapRedBookTag:(UITapGestureRecognizer *)gesture;
- (void)tapBlueBookTag:(UITapGestureRecognizer *)gesture;

- (void)hvcAnimation:(enum BookViewAnimationType)fadeinOrFadeout;
- (void)mwvcAnimation:(enum BookViewAnimationType)fadeinOrFadeout;

@end

@implementation WMBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        _currentBookState = BlueBookState;
    }
    return self;
}

- (void)dealloc {
    [_hvc release];
    _hvc = nil;
    
    [_mwvc release];
    _mwvc = nil;
    
    [_redBookTagImageView release];
    [_blueBookTagImageView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.headBar removeFromSuperview];
    self.headBar = nil;
    
    self.redBookTagImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redClosedBook"]] autorelease];
    [self.view addSubview:_redBookTagImageView];
    _redBookTagImageView.userInteractionEnabled = YES;
    CGRect redBookFrame = _redBookTagImageView.frame;
    redBookFrame.origin.y = ((NKMainHeight>460)?48:44) - redBookFrame.size.height;
    _redBookTagImageView.frame = redBookFrame;
    
    self.blueBookTagImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueClosedBook"]] autorelease];
    [self.view addSubview:_blueBookTagImageView];
    CGRect blueBookFrame = _blueBookTagImageView.frame;
    blueBookFrame.origin.y = NKMainHeight - ((NKMainHeight>460)?40:36);
    _blueBookTagImageView.frame = blueBookFrame;
    _blueBookTagImageView.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *redTapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(tapRedBookTag:)];
    [self.redBookTagImageView addGestureRecognizer:redTapGesture];
    [redTapGesture release];
    
    UITapGestureRecognizer *blueTapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(tapBlueBookTag:)];
    [self.blueBookTagImageView addGestureRecognizer:blueTapGesture];
    [blueTapGesture release];
    
    [self switchBookWithState:self.currentBookState];
}

- (void)viewDidUnload {
    [self setRedBookTagImageView:nil];
    [self setBlueBookTagImageView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Private Functions

- (UIImage*)bookTagImageWithState:(enum BookSwitchState)state {
    UIImage *ret = nil;
    switch (state) {
        case RedBookState: {
            ret = [UIImage imageNamed:@"redClosedBook"];
        }break;
        case BlueBookState: {
            ret = [UIImage imageNamed:@"blueClosedBook"];
        }break;
        default: {
            NSLog(@"book tag image is nil, state:%d", state);
        }break;
    }
    
    return ret;
}

- (CGRect)bookTagFrameWithState:(enum BookSwitchState)state {
    CGRect ret = CGRectZero;
    
    UIImage *tagImage = [self bookTagImageWithState:state];
    if (tagImage == nil) return ret;
    
    CGSize imageSize = tagImage.size;
    
    switch (state) {
        case RedBookState: {
            ret = CGRectMake(0, 0, imageSize.width, imageSize.height);
        }break;
        case BlueBookState: {
            CGRect viewBound = self.view.bounds;
            
            CGFloat yPosition = CGRectGetMaxY(viewBound) - imageSize.height;
            ret = CGRectMake(0, yPosition,
                             imageSize.width, imageSize.height);
        }break;
        default: {
        }break;
    }
    
    return ret;
}

- (void)switchBookWithState:(enum BookSwitchState)state {
    switch (state) {
        case RedBookState: {
            [self hvcAnimation:BookViewFadeout];
            [self mwvcAnimation:BookViewFadein];
        }break;
        case BlueBookState: {
            [self hvcAnimation:BookViewFadein];
            [self mwvcAnimation:BookViewFadeout];
        }break;
        default: {
        }break;
    }
}

- (void)hvcAnimation:(enum BookViewAnimationType)fadeinOrFadeout {
    CGFloat destYPosition = 0.0;
    CGFloat startYPosition = 0.0;
    
    if (fadeinOrFadeout == BookViewFadein) {
        [self.redBookTagImageView.superview insertSubview:self.hvc.view belowSubview:self.redBookTagImageView];
        destYPosition = CGRectGetHeight(self.hvc.view.bounds) * 0.5;
        startYPosition = -(CGRectGetHeight(self.hvc.view.bounds) * 0.5);
        
        self.hvc.view.center = CGPointMake(self.view.center.x, startYPosition);
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.hvc.view.center = CGPointMake(self.view.center.x,
                                                                destYPosition);
                             
                             self.redBookTagImageView.alpha = 0.0;
                             
                             
                         }
                         completion:^(BOOL finished) {
                         }];
    }
    else {
        destYPosition = -(CGRectGetHeight(self.hvc.view.bounds) * 0.5);
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.hvc.view.center = CGPointMake(self.view.center.x,
                                                                destYPosition);
                             
                             self.redBookTagImageView.alpha = 1.0;

                         }
                         completion:^(BOOL finished) {
                             [self.hvc.view removeFromSuperview];
                         }];
    }
}

- (void)mwvcAnimation:(enum BookViewAnimationType)fadeinOrFadeout {
    CGFloat destYPosition = 0.0;
    CGFloat startYPosition = 0.0;
    
    if (fadeinOrFadeout == BookViewFadein) {
        [self.blueBookTagImageView.superview insertSubview:self.mwvc.view belowSubview:self.blueBookTagImageView];
        destYPosition = CGRectGetHeight(self.contentView.bounds) - CGRectGetHeight(self.mwvc.view.bounds) * 0.5;
        startYPosition = CGRectGetHeight(self.contentView.bounds) + (CGRectGetHeight(self.mwvc.view.bounds) * 0.5);
        
        self.mwvc.view.center = CGPointMake(self.view.center.x, startYPosition);
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.mwvc.view.center = CGPointMake(self.view.center.x,
                                                                destYPosition);
                             
                             self.blueBookTagImageView.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
    else {
        destYPosition = CGRectGetHeight(self.contentView.bounds) + (CGRectGetHeight(self.mwvc.view.bounds) * 0.5);;
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.mwvc.view.center = CGPointMake(self.view.center.x,
                                                                destYPosition);
                             
                             self.blueBookTagImageView.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             [self.mwvc.view removeFromSuperview];
                         }];
    }
}

#pragma mark -- GestureRecognizer Functions

- (void)tapRedBookTag:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.currentBookState = BlueBookState;
        [self switchBookWithState:self.currentBookState];
    }
}

- (void)tapBlueBookTag:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.currentBookState = RedBookState;
        [self switchBookWithState:self.currentBookState];
    }
}

#pragma mark -- Set/Get Functions

- (WMHomeViewController*)hvc {
    if (_hvc == nil) {
        _hvc = [[WMHomeViewController alloc] init];
    }
    
    return _hvc;
}

- (WMMenWikiViewController*)mwvc {
    if (_mwvc == nil) {
        _mwvc = [[WMMenWikiViewController alloc] init];
    }
    
    return _mwvc;
}

@end
