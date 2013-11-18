//
//  WMCoverPageViewController.m
//  WEIMI
//
//  Created by steve on 13-6-28.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMCoverPageViewController.h"
#import "WMMTopic.h"
#import "WMDiscussDetailViewController.h"
#import "WMDiscussWebViewController.h"

@interface WMCoverPageViewController ()

@end

@implementation WMCoverPageViewController

@synthesize photoView = _photoView;
//@synthesize detailViewController = _detailViewController;
@synthesize lastPageView = _lastPageView;
@synthesize isLast = _isLast;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPageNumber:(int)page
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        pageNumber = page;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _photoView = [[NKKVOImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 152)];
    WMMTopicPicad *card = [_dataSource objectAtIndex:pageNumber];
    [_photoView bindValueOfModel:card forKeyPath:@"pic"];
    [self.view addSubview:_photoView];
    
    UIImageView *cover_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 152)];
    cover_img.userInteractionEnabled = YES;
    cover_img.image = [UIImage imageNamed:@"cover_topic_card"];
    [self.view addSubview:cover_img];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoTarget:)];
    [cover_img addGestureRecognizer:singleTap];
}

-(void)gotoTarget:(id)sender
{
    WMMTopicPicad *card = [_dataSource objectAtIndex:pageNumber];
    if ([card.type isEqualToString:@"url"]) {
        WMDiscussWebViewController *webViewController = [[WMDiscussWebViewController alloc] init];
        webViewController.url = card.url;
        [NKNC pushViewController:webViewController animated:YES];
    }else if([card.type isEqualToString:@"topic"]){
        WMDiscussDetailViewController *detailViewController = [[WMDiscussDetailViewController alloc] init];
        detailViewController.topic_id = card.topic_id;
        [NKNC pushViewController:detailViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
