//
//  WMCoverViewController.m
//  WEIMI
//
//  Created by steve on 13-6-28.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMCoverViewController.h"
#import "WMCoverPageViewController.h"

@interface WMCoverViewController ()
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
@end

@implementation WMCoverViewController

@synthesize currentPage;
@synthesize kNumberOfPages;
//@synthesize scrollView = scrollView;
//@synthesize viewControllers;

static CGFloat SWITCH_FOCUS_PICTURE_INTERVAL = 7.0;

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
    self.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    //NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:kNumberOfPages];
    
    viewControllers = [[NSMutableArray alloc] initWithCapacity:kNumberOfPages];
    //[self.view addSubview:pageControl];
    //kNumberOfPages = [viewControllers count];
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
		[viewControllers addObject:[NSNull null]];
    }
    //viewControllers = controllers;
    scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)] autorelease];
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
    [self scrolTo:currentPage];
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages,scrollView.frame.size.height);
    
    if (kNumberOfPages>1) {
        pageControl = [[[UIPageControl alloc] initWithFrame:CGRectMake(0, 136, 320, 10)] autorelease];
        [self.view insertSubview:pageControl aboveSubview:scrollView];
        pageControl.numberOfPages = kNumberOfPages;
        pageControl.currentPage = 0;
    }
    
    //[self.view addSubview:pageControl];
    
	[self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
}

-(void)scrolTo:(int)page
{
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page +1];
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
}

-(void)reloadAllData
{
    NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:kNumberOfPages];
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    viewControllers = controllers;
}

-(void)removeTimer
{
    scrollView.scrollEnabled = YES;
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    
    if (page >= kNumberOfPages) {
        return;
    }
    
    
    // replace the placeholder if necessary
    WMCoverPageViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[[WMCoverPageViewController alloc] initWithPageNumber:page] autorelease];
        controller.dataSource = _dataSource;
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



- (IBAction)changePage:(id)sender
{
    int page = currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    
}

- (void)switchFocusImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = scrollView.contentOffset.x + scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    
    [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
    
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
    //NSLog(@"moveToTargetPosition : %f" , targetX);
    if (targetX >= scrollView.contentSize.width) {
        targetX = 0.0;
        [scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO] ;
    }else {
        [scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES] ;
    }
    pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
