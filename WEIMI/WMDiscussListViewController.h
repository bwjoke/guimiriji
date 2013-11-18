//
//  WMDiscussListViewController.h
//  WEIMI
//
//  Created by steve on 13-6-28.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMMTopic.h"
#import "WMDiscussCell.h"
#import "WMDiscussDetailViewController.h"
#import "WMNewTopicViewController.h"

@interface WMDiscussListViewController : WMTableViewController<NKSegmentControlDelegate,WMNewTopicViewDelegate,UIActionSheetDelegate>

@property(nonatomic,assign)WMMTopicBoard *topicboard;
@property (nonatomic, assign) NKSegmentControl *seg;
@end
