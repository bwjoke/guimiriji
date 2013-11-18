//
//  WMMenWikiListViewController.m
//  WEIMI
//
//  Created by steve on 13-7-19.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMMenWikiListViewController.h"
#import "WMMenWikiPageViewController.h"
#import "WMMenWikiViewController.h"

@interface WMMenWikiListViewController ()

@end

@implementation WMMenWikiListViewController
@synthesize viewControllers;
@synthesize currentPage;
@synthesize kNumberOfPages;

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
	// Do any additional setup after loading the view.
    viewControllers = [[NSMutableArray alloc] initWithCapacity:kNumberOfPages];
    //[self.view addSubview:pageControl];
    //kNumberOfPages = [viewControllers count];
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
		[viewControllers addObject:[NSNull null]];
    }
    //viewControllers = controllers;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    scrollView.userInteractionEnabled = YES;
    scrollView.pagingEnabled=YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    
    [self.view addSubview:scrollView];
    
    CGFloat pageWidth = scrollView.frame.size.width;
    currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages,scrollView.frame.size.height);
    [self scrolTo:currentPage];
}


-(void)scrolTo:(int)page
{
    [self loadScrollViewWithPage:page];
    //[self loadScrollViewWithPage:page +1];
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:NO];
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    
    if (page >= kNumberOfPages) {
        return;
    }

    WMMenWikiPageViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[WMMenWikiPageViewController alloc] initWithPageNumber:page];
        controller.category = [_dataSource objectAtIndex:page];
        controller.shouldAutoRefreshData = NO;
        [viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page>0) {
        WMMenWikiPageViewController *controller = [viewControllers objectAtIndex:0];
        [controller hideKeybord];
    }
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    [_delegate didScrollViewStartScrollTo:page];
    // A possible optimization would be to unload the views+controllers which are no longer visible
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
