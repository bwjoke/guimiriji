//
//  WMMenWikiViewController.h
//  WEIMI
//
//  Created by King on 10/24/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMHelpView.h"
#import "WMBaoliaoXiangqingViewController.h"
#import "WMManFeedCell.h"

@interface WMMenWikiViewController : WMTableViewController <NKSegmentControlDelegate, UITextFieldDelegate,WMBaoliaoXiangqingDelegate,WMManFeedCellDelegate,UIActionSheetDelegate>

@property (nonatomic, assign) UIButton *actionButton;
@property (nonatomic, retain) NSString *category;

@property (nonatomic, assign) UIView *segLine;


@property (nonatomic, assign) UITextField *searchFiled;

@property (nonatomic, assign) NKSegmentControl *tabSeg;

@property (nonatomic, assign) UILabel *topLabel;

@property (nonatomic, retain) NSMutableArray *showDataSource;
@property (nonatomic, retain) NSMutableArray *searchResults;

@property (nonatomic, assign) NKBadgeView *feedBadge;


-(IBAction)logout:(id)sender;

@end
