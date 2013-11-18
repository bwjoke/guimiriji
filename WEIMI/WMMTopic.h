//
//  WMMTopic.h
//  WEIMI
//
//  Created by steve on 13-6-5.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMModel.h"
#import "WMMUser.h"

@interface WMMTopic : WMModel

@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *iconPath;
@property(nonatomic,retain)UIImage *icon;
@property(nonatomic,retain)NSNumber *comment_count;
@property(nonatomic,retain)NSString *desc;
@property(nonatomic, retain)NSMutableArray *content;
@property(nonatomic,retain)NSNumber *is_top;
@property(nonatomic,retain)NSNumber *hasPic;
@property(nonatomic, retain)NSDate   *createTime;
@property(nonatomic, retain)NSDate   *updateTime;
@property(nonatomic,retain)WMMUser *sender;
@property(nonatomic, retain) NSMutableArray  *comments;
@property(nonatomic, retain) NSMutableArray *titles;

@property (nonatomic, retain) NSString *audioURLString;
@property (nonatomic, retain) NSNumber *audioSecond;

@property (nonatomic, retain) NSNumber *prise;
@property (nonatomic, retain) NSNumber *prised;

@property (nonatomic, retain) NSNumber *fav;

@end

@interface WMMTopicCotent : WMModel

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString   *value;
@property (nonatomic, retain) UIImage *image;

@end

@interface WMMTopicBoard : WMModel

@property(nonatomic,retain)NSNumber *count;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *iconPath;
@property(nonatomic,retain)UIImage *icon;
@property (nonatomic, retain) NSMutableArray *titles;
@property (nonatomic) BOOL doorClose;
@property (nonatomic,retain) NSString *doorCloseMsg;

@end

@interface WMMTopicPicad : WMModel

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *picPath;
@property (nonatomic, retain) UIImage *pic;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *topic_id;

@end

@interface WMMTopicComment : WMModel

@property (nonatomic, retain) WMMUser  *sender;
@property(nonatomic, retain)NSMutableArray *content;
@property (nonatomic, retain) NSDate   *createTime;
@property (nonatomic, retain) NSString *touserid;
@property (nonatomic, retain) NSString *prefix,*reply_commentid,*reply_comment,*reply_content,*reply_title;

@property (nonatomic, retain) NSString *audioURLString;
@property (nonatomic, retain) NSNumber *audioSecond;

- (NSString *)firstTxetReply;

@end

@interface WMMTopicNotification : WMModel

@property (nonatomic, copy) NSString *topicID;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, retain) NSDate *createTime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *reply;
@property (nonatomic, copy) NSString *message;

@end