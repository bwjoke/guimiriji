//
//  WMHoneyPersonFeedCell.h
//  WEIMI
//
//  Created by mzj on 13-2-28.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKKVOImageView.h"

@interface WMHoneyPersonFeedCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *dayLabel;
@property (retain, nonatomic) IBOutlet UILabel *monthLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet UIImageView *commentImageView;
@property (retain, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (retain, nonatomic) IBOutlet NKKVOImageView *feedPictureImageView;

@end
