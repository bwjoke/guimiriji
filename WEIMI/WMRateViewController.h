//
//  WMRateViewController.h
//  WEIMI
//
//  Created by King on 11/21/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMRateCell.h"

@interface WMRateViewController : WMTableViewController <NKSegmentControlDelegate,WMRateCellDelegate>{

}

@property (nonatomic, retain) WMMMan *man;
@property (nonatomic, assign) NKSegmentControl *seg;
@property (nonatomic, assign) UILabel *notice;

-(void)setupUI;
-(void)updateHeaderView;
@end
