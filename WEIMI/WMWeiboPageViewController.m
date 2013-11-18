//
//  WMWeiboPageViewController.m
//  WEIMI
//
//  Created by steve on 13-5-28.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMWeiboPageViewController.h"

@interface WMWeiboPageViewController ()

@end

@implementation WMWeiboPageViewController

-(void)dealloc
{
    [_man release];
    [super dealloc];
}

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
    [self addBackButton];
    
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",self.man.weiboName];
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    
    CGRect frame = self.view.frame;
    frame.origin.y += 43;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.man.weiboUrl]]];
    [self.contentView addSubview:webView];
    [webView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
