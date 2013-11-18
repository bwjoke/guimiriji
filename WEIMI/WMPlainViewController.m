//
//  WMPlainViewController.m
//  WEIMI
//
//  Created by steve on 13-4-27.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMPlainViewController.h"

@interface WMPlainViewController ()

@end

#define PLAIN_URL @"http://www.weimi.com/plain_term"

@implementation WMPlainViewController

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
    self.titleLabel.text = @"用户协议";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    [self addBackButton];
    
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] autorelease] atIndex:0];
    [self addHeadShadow];
    CGRect frame = self.view.frame;
    frame.origin.y += 43;
    frame.size.height -= 43;
    UIWebView *appView = [[UIWebView alloc] initWithFrame:frame];
    [appView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PLAIN_URL]]];
    [self.contentView addSubview:appView];
    [appView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
