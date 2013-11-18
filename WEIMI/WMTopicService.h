//
//  WMTopicService.h
//  WEIMI
//
//  Created by steve on 13-6-5.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMServiceBase.h"

@interface WMTopicService : WMServiceBase

dshared(WMTopicService);

-(NKRequest*)getTopicBoards:(NKRequestDelegate*)rd;

-(NKRequest*)getTopicPicads:(NKRequestDelegate*)rd;

-(NKRequest*)getTopicList:(NSString *)mid sort:(NSString *)sort offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getTopicCommentList:(NSString *)mid offset:(int)offset size:(int)size order_by:(NSString *)order_by andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getTopicNotificationList:(NKRequestDelegate *)rd offset:(int)offset size:(int)size; // 获取话题通知列表
-(NKRequest*)createTopic:(NKRequestDelegate *)rd withBoardID:(NSString *)boardID andUserInfo:(NSDictionary *)userInfo; // 创建话题

-(NKRequest*)getTopicDetail:(NKRequestDelegate *)rd withTopicID:(NSString *)topicID; // 获取话题显示(详情)

-(NKRequest*)reportTopic:(NSString *)mid content:(NSString *)content andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)createComment:(NKRequestDelegate *)rd withUserInfo:(NSDictionary *)userInfo; // 话题回复

-(NKRequest*)deleteTopic:(NSString *)mid andRequestDelegate:(NKRequestDelegate*)rd; // 删除话题

-(NKRequest*)getMyTopicByOffset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate *)rq;

-(NKRequest*)getMyCommentByOffset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate *)rq;

-(NKRequest *)reportTopicComment:(NSString *)mid content:(NSString *)content andRequestDelegate:(NKRequestDelegate *)rd;

- (NKRequest *)toggleBaobaoWithID:(NSString *)topicID andRequestDelegate:(NKRequestDelegate *)rd;

- (NKRequest *)addTopicFavWithID:(NSString *)topicID andRequestDelegate:(NKRequestDelegate *)rd;

- (NKRequest *)delTopicFavWithID:(NSString *)topicID andRequestDelegate:(NKRequestDelegate *)rd;

-(NKRequest*)getTopicFavList:(NSString *)type offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;
@end
