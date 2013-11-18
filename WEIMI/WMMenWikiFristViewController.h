//
//  WMMenWikiFristViewController.h
//  WEIMI
//
//  Created by steve on 13-7-22.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMMenWikiListViewController.h"

@interface WMMenWikiFristViewController : WMTableViewController<NKSegmentControlDelegate,WMMenWikiListDelegate>
{
    BOOL shouldChangeDataPage;
}
@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) UIView *segLine;

@property (nonatomic, strong) NKSegmentControl *tabSeg;

@property (nonatomic, strong) NKBadgeView *feedBadge;

-(void)showNearView;
@end
