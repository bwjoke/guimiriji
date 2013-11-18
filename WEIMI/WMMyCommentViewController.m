//
//  WMMyCommentViewController.m
//  WEIMI
//
//  Created by Tang Tianyong on 8/21/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMMyCommentViewController.h"

@interface WMMyCommentViewController ()

@end

@implementation WMMyCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.titleLabel.text = @"我回复的";
}

- (void)refreshData {
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    
    [[WMTopicService sharedWMTopicService] getMyCommentByOffset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
}

-(void)getMoreData{
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getMoreDataOK:) andFailedSelector:@selector(getMoreDataFailed:)];
    
    [[WMTopicService sharedWMTopicService] getMyCommentByOffset:self.dataSource.count size:DefaultOneRequestSize andRequestDelegate:rd];
}

@end
