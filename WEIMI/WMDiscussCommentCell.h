//
//  WMDiscussCommentCell.h
//  WEIMI
//
//  Created by steve on 13-7-9.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//
@protocol WMDiscussCommentCellDelegate <NSObject>

@optional
-(void)replyTopic:(int)index;

@end

#import "NKTableViewCell.h"
#import "WMMTopic.h"
#import "WMCustomLabel.h"
@class WMAudioPlayer;

@interface WMDiscussCommentCell : NKTableViewCell
{
    UIView *commentContentView;
    WMAudioPlayer *player;
}
@property(nonatomic,strong)WMMTopicComment *showComment;
@property(nonatomic,strong)WMCustomLabel *nameLabel,*replyContentLabel,*contentLabel,*dateLabel;
@property(nonatomic,strong)UIImageView *replySep,*cellSep;;
@property(nonatomic,strong)UIButton *commentIcon;
@property(nonatomic)NSInteger currentIndex;
@property(nonatomic)NSInteger commentCount;
@property(nonatomic)BOOL orderNew;
@property(nonatomic,unsafe_unretained)id<WMDiscussCommentCellDelegate>delegate;
@end
