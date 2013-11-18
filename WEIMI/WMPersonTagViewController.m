//
//  WMPersonTagViewController.m
//  WEIMI
//
//  Created by mzj on 13-2-26.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMPersonTagViewController.h"
#import "NKKVOImageView.h"
#import "WMPersonTagView.h"

#define kPersonTagViewIndexStart 1001
#define kPersonImageCount 5
#define kPersonImageMoveYOffset 5

@interface WMPersonTagViewController ()

@property (assign, nonatomic) UIView *currentSelectedPersonView;

- (void)initImageViewGestureRecognizers;
- (void)switchSelectedPersonView:(UIView *)selectedPersonView;

- (void)tapPersonImageView:(UITapGestureRecognizer *)gesture;


@end

@implementation WMPersonTagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initImageViewGestureRecognizers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark -- Private Functions
#pragma mark -

- (void)initImageViewGestureRecognizers {
    NSUInteger imageViewIndex = kPersonTagViewIndexStart;
    NSUInteger imageViewEndIndex = (kPersonTagViewIndexStart + kPersonImageCount) - 1;
    
    for (; imageViewIndex <= imageViewEndIndex; ++imageViewIndex) {
        UIView *imageView = [self.view viewWithTag:imageViewIndex];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(tapPersonImageView:)];
        [imageView addGestureRecognizer:tapGesture];
        [tapGesture release];
    }
}

- (void)switchSelectedPersonView:(UIView *)selectedPersonView {
    if (self.currentSelectedPersonView != nil) {
        self.currentSelectedPersonView.center = CGPointApplyAffineTransform(self.currentSelectedPersonView.center,
                                                                            CGAffineTransformMakeTranslation(0, kPersonImageMoveYOffset));
    }
    
    selectedPersonView.center = CGPointApplyAffineTransform(selectedPersonView.center,
                                                            CGAffineTransformMakeTranslation(0, -(kPersonImageMoveYOffset)));
    
    self.currentSelectedPersonView = selectedPersonView;
}

#pragma mark -
#pragma mark -- Gesture Recognizer Functions
#pragma mark -

- (void)tapPersonImageView:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self switchSelectedPersonView:gesture.view];
        
        // todo:call target action
        [self.target performSelector:self.selectTagAction withObject:nil];
    }
}

@end
