//
//  WMDiscussDetailViewController.h
//  WEIMI
//
//  Created by ZUO on 6/28/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMMTopic.h"
#import "WMReplyTopicViewController.h"
#import "WMDiscussCommentCell.h"

@interface WMDiscussDetailViewController : WMTableViewController<UIActionSheetDelegate, WMReplyTopicViewDelegate, UIAlertViewDelegate,WMDiscussCommentCellDelegate>

@property(nonatomic,strong)WMMTopic *topic;
@property(nonatomic,strong)WMMTopic *showTopic;
@property(nonatomic,strong)NSString *topic_id;

+(id)topicDetailWithTopicid:(NSString *)topic_id;

@end
