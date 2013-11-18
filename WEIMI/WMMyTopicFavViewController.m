//
//  WMMyTopicFavViewController.m
//  WEIMI
//
//  Created by SteveMa on 13-10-29.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMMyTopicFavViewController.h"

@interface WMMyTopicFavViewController ()

@end

@implementation WMMyTopicFavViewController

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
    self.titleLabel.text = @"我的收藏";
}

- (void)refreshData {
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    
    [[WMTopicService sharedWMTopicService] getTopicFavList:@"topic" offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
}

-(void)getMoreData{
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getMoreDataOK:) andFailedSelector:@selector(getMoreDataFailed:)];
    
    [[WMTopicService sharedWMTopicService] getTopicFavList:@"topic" offset:[self.dataSource count] size:DefaultOneRequestSize andRequestDelegate:rd];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
