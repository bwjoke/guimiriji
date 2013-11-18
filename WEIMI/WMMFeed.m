//
//  WMMFeed.m
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMMFeed.h"


NSString *const WMFeedTypeCommon = @"common";
NSString *const WMFeedTypeBaoliao = @"baoliao";
NSString *const WMFeedTypeDafen = @"score";



@implementation WMMComment

-(void)dealloc{
    
    [_content release];
    [_sender release];
    [_createTime release];
    [_prefix release];
    [_content_orgin release];
    [super dealloc];
}

+(id)modelFromDic:(NSDictionary *)dic{
    
    WMMComment *comment = [super modelFromDic:dic];
    
    NKBindValueWithKeyForParameterFromDic(@"content", comment.content, dic);
    NKBindValueWithKeyForParameterFromDic(@"reply_user", comment.prefix, dic);
    NKBindValueWithKeyForParameterFromDic(@"content_origin", comment.content_orgin, dic);
    
    NSDictionary *user = [dic objectOrNilForKey:@"user"];
    if (user) {
        comment.sender = [WMMUser modelFromDic:user];
    }
    
    comment.createTime = [NSDate dateWithTimeIntervalSince1970:[[dic objectOrNilForKey:@"time"] longLongValue]];
    
    return comment;
    
}


@end

@implementation WMMFeed

-(void)dealloc{
    
    [_sender release];
    [_man release];
    [_title release];
    [_content release];
    
    [_type release];
    
    [_isAnonymous release];
    [_purview release];
    
    [_commentCount release];
    
    [_client release];
    [_distance release];
    [_dist release];
    [_createTime release];
    
    [_attachments release];
    [_comments release];
    
    [_score release];
    
    [_praise release];
    [_praised release];
    
    [_audioURLString release];
    [_audioSecond release];
    
    [super dealloc];
}


+(id)modelFromDic:(NSDictionary *)dic{
    
    WMMFeed *feed = [super modelFromDic:dic];
    
    NSDictionary *user = [dic objectOrNilForKey:@"user"];
    NSDictionary *man = [dic objectOrNilForKey:@"man"];
    if (user) {
        feed.sender = [WMMUser modelFromDic:user];
    }
    
    if (man) {
        feed.man = [WMMMan modelFromDic:man];
    }
    
    NKBindValueWithKeyForParameterFromDic(@"title", feed.title, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"type", feed.type, dic);
    NKBindValueWithKeyForParameterFromDic(@"content", feed.content, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"scores", feed.score, dic);
    
     NKBindValueWithKeyForParameterFromDic(@"distance", feed.distance, dic);
    NKBindValueWithKeyForParameterFromDic(@"dist", feed.dist, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"is_anonymous", feed.isAnonymous, dic);
    NKBindValueWithKeyForParameterFromDic(@"purview", feed.purview, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"client", feed.client, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"comment_count", feed.commentCount, dic);
    //NKBindValueWithKeyForParameterFromDic(@"praise", feed.praise, dic);
    feed.praise = [dic objectOrNilForKey:@"praise"];
    feed.praised = [dic objectOrNilForKey:@"praised"];
    
    NKBindValueWithKeyForParameterFromDic(@"audio", feed.audioURLString, dic);
    NKBindValueWithKeyForParameterFromDic(@"audio_seconds", feed.audioSecond, dic);
    
    // Time
    feed.createTime = [NSDate dateWithTimeIntervalSince1970:[[dic objectOrNilForKey:@"created_at"] longLongValue]];
    
    NSArray *attachments = [dic objectOrNilForKey:@"attachments"];
    if ([attachments isKindOfClass:[NSArray class]] && [attachments count]) {
        feed.attachments = [NSMutableArray arrayWithCapacity:attachments.count];
        for (NSDictionary *attachment in attachments) {
            [feed.attachments addObject:[NKMAttachment modelFromDic:attachment]];
        }
    }
    
    NSArray *comments = [dic objectOrNilForKey:@"comments"];
    if ([comments isKindOfClass:[NSArray class]] && [comments count]) {
        feed.comments = [NSMutableArray arrayWithCapacity:comments.count];
        for (NSDictionary *comment in comments) {
            [feed.comments addObject:[WMMComment modelFromDic:comment]];
        }
    }
    
    return feed;
}



@end
