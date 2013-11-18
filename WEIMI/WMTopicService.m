//
//  WMTopicService.m
//  WEIMI
//
//  Created by steve on 13-6-5.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTopicService.h"
#import "WMMTopic.h"

@implementation WMTopicService

-(void)dealloc{
    [super dealloc];
}

$singleService(WMTopicService, @"topic");

static NSString *const WMAPIGetTopicBoards = @"/boards_new";
-(NKRequest*)getTopicBoards:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetTopicBoards];
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMTopicBoard class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIGetTopicPicads = @"/picads";
-(NKRequest*)getTopicPicads:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetTopicPicads];
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMTopicPicad class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIGetTopicList = @"/list";
-(NKRequest*)getTopicList:(NSString *)mid sort:(NSString *)sort offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetTopicList];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMTopic class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"boardid"];
    }
    
    if (sort) {
        [newRequest addPostValue:sort forKey:@"sort"];
    }
    
    if (offset) {
        [newRequest addPostValue:[NSNumber numberWithInt:offset] forKey:@"offset"];
    }
    if (size) {
        [newRequest addPostValue:[NSNumber numberWithInt:size] forKey:@"size"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIGetTopicCommentList = @"/get_comment";
-(NKRequest*)getTopicCommentList:(NSString *)mid offset:(int)offset size:(int)size order_by:(NSString *)order_by andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetTopicCommentList];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMTopicComment class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"topicid"];
    }
    
    if (offset) {
        [newRequest addPostValue:[NSNumber numberWithInt:offset] forKey:@"offset"];
    }
    if (size) {
        [newRequest addPostValue:[NSNumber numberWithInt:size] forKey:@"size"];
    }
    
    if (order_by) {
        [newRequest addPostValue:order_by forKey:@"order_by"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIGetTopicFavList = @"/fav/list";
-(NKRequest*)getTopicFavList:(NSString *)type offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetTopicFavList];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMTopic class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (type) {
        [newRequest addPostValue:type forKey:@"type"];
    }
    
    if (offset) {
        [newRequest addPostValue:[NSNumber numberWithInt:offset] forKey:@"offset"];
    }
    if (size) {
        [newRequest addPostValue:[NSNumber numberWithInt:size] forKey:@"size"];
    }

    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIGetTopicNotificationList = @"/notification";
-(NKRequest*)getTopicNotificationList:(NKRequestDelegate *)rd offset:(int)offset size:(int)size {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetTopicNotificationList];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMTopicNotification class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    [newRequest addPostValue:@(offset) forKey:@"offset"];
    [newRequest addPostValue:@(size) forKey:@"size"];
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPICreateTopic = @"/create";
-(NKRequest*)createTopic:(NKRequestDelegate *)rd withBoardID:(NSString *)boardID andUserInfo:(NSDictionary *)userInfo {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPICreateTopic];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (boardID) {
        [newRequest addPostValue:boardID forKey:@"boardid"];
    }
    
    if (userInfo) {
        for (NSString *key in userInfo) {
            if ([key isEqualToString:@"attachments"]) {
                // Currently, only support one image
                NSArray *attachments = userInfo[key];
                if (attachments.count > 0) {
                    [newRequest addData:attachments[0] withFileName:@"fromIphone.jpg" andContentType:@"image/jpeg" forKey:@"attachments_0"];
                }
            } else if ([key isEqualToString:@"audio"]) {
                NSData *audio = userInfo[key];
                if (audio) {
                    NSNumber *audio_seconds = userInfo[@"audio_seconds"];
                    [newRequest addData:audio withFileName:@"fromIphone.amr" andContentType:@"audio/amr" forKey:@"audio"];
                    [newRequest addPostValue:audio_seconds forKey:@"audio_seconds"];
                }
            } else {
                [newRequest addPostValue:userInfo[key] forKey:key];
            }
        }
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIGetTopicShow = @"/show";
-(NKRequest*)getTopicDetail:(NKRequestDelegate *)rd withTopicID:(NSString *)topicID
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetTopicShow];
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMTopic class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (topicID) {
        [newRequest addPostValue:topicID forKey:@"topicid"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIReportTopic = @"/report";
-(NKRequest*)reportTopic:(NSString *)mid content:(NSString *)content andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIReportTopic];
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"id"];
    }
    
    if (content) {
        [newRequest addPostValue:content forKey:@"content"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIReportTopicComment = @"/comment/report";
-(NKRequest *)reportTopicComment:(NSString *)mid content:(NSString *)content andRequestDelegate:(NKRequestDelegate *)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIReportTopicComment];
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"id"];
    }
    
    if (content) {
        [newRequest addPostValue:content forKey:@"content"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPITopicCommentCreate = @"/comment/create";
-(NKRequest*)createComment:(NKRequestDelegate *)rd withUserInfo:(NSDictionary *)userInfo {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPITopicCommentCreate];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (userInfo) {
        for (NSString *key in userInfo) {
            if ([key isEqualToString:@"attachments"]) {
                // Currently, only support one image
                NSArray *attachments = userInfo[key];
                if (attachments.count > 0) {
                    [newRequest addData:attachments[0] withFileName:@"fromIphone.jpg" andContentType:@"image/jpeg" forKey:@"attachments_0"];
                }
            } else if ([key isEqualToString:@"audio"]) {
                NSData *audio = userInfo[key];
                if (audio) {
                    NSNumber *audio_seconds = userInfo[@"audio_seconds"];
                    [newRequest addData:audio withFileName:@"fromIphone.amr" andContentType:@"audio/amr" forKey:@"audio"];
                    [newRequest addPostValue:audio_seconds forKey:@"audio_seconds"];
                }
            } else {
                [newRequest addPostValue:userInfo[key] forKey:key];
            }
        }
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPITopicDelete = @"/delete";
- (NKRequest *)deleteTopic:(NSString *)mid andRequestDelegate:(NKRequestDelegate *)rd {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPITopicDelete];
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"id"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIGetMyTopic = @"/my_topic";
- (NKRequest *)getMyTopicByOffset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate *)rd {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetMyTopic];
    
    urlString = [urlString stringByAppendingFormat:@"?offset=%d&size=%d", offset, size];
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMTopic class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIGetMyComment = @"/my_topic_of_comment";
- (NKRequest *)getMyCommentByOffset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate *)rd {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetMyComment];
    
    urlString = [urlString stringByAppendingFormat:@"?offset=%d&size=%d", offset, size];
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMTopic class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPILike = @"/like";
- (NKRequest *)toggleBaobaoWithID:(NSNumber *)topicID andRequestDelegate:(NKRequestDelegate *)rd {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPILike];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (topicID) {
        [newRequest addPostValue:topicID forKey:@"id"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIAddFav = @"/fav/add";
- (NKRequest *)addTopicFavWithID:(NSString *)topicID andRequestDelegate:(NKRequestDelegate *)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIAddFav];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (topicID) {
        [newRequest addPostValue:topicID forKey:@"topicid"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIDelFav = @"/fav/del";
- (NKRequest *)delTopicFavWithID:(NSString *)topicID andRequestDelegate:(NKRequestDelegate *)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIDelFav];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (topicID) {
        [newRequest addPostValue:topicID forKey:@"topicid"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

@end
