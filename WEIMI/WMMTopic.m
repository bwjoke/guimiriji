//
//  WMMTopic.m
//  WEIMI
//
//  Created by steve on 13-6-5.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMMTopic.h"
#import "NKDateUtil.h"

@implementation WMMTopic

-(void)dealloc
{
    [_title release];
    [_desc release];
    [_comment_count release];
    [_sender release];
    [_content release];
    [_createTime release];
    [_updateTime release];
    [_is_top release];
    [_hasPic release];
    [_icon release];
    [_iconPath release];
    [_titles release];
    
    [_audioURLString release];
    [_audioSecond release];
    
    [super dealloc];
}

+(id)modelFromDic:(NSDictionary *)dic
{
    NSLog(@"*****: %@",dic);
    WMMTopic *topic = [super modelFromDic:dic];
    NSDictionary *user = [dic objectOrNilForKey:@"user"];

    if (user) {
        topic.sender = [WMMUser modelFromDic:user];
    }
    
    NKBindValueWithKeyForParameterFromDic(@"title", topic.title, dic);
    NKBindValueWithKeyForParameterFromDic(@"description", topic.desc, dic);
    NKBindValueWithKeyForParameterFromDic(@"comment_count", topic.comment_count, dic);
    NKBindValueWithKeyForParameterFromDic(@"is_top", topic.is_top, dic);
    NKBindValueWithKeyForParameterFromDic(@"has_pic", topic.hasPic, dic);
    NKBindValueWithKeyForParameterFromDic(@"icon", topic.iconPath, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"audio", topic.audioURLString, dic);
    NKBindValueWithKeyForParameterFromDic(@"audio_seconds", topic.audioSecond, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"praise", topic.prise, dic);
    NKBindValueWithKeyForParameterFromDic(@"praised", topic.prised, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"fav", topic.fav, dic);
    
    NSArray *titles = [dic objectOrNilForKey:@"titles"];
    if ([titles isKindOfClass:[NSArray class]] && [titles count]>0) {
        topic.titles = [NSMutableArray arrayWithCapacity:[titles count]];
        for (int i=0; i<[titles count]; i++) {
            [topic.titles addObject:[titles objectAtIndex:i]];
        }
    }
    
    NSArray *contents = [dic objectOrNilForKey:@"content"];
    if ([contents isKindOfClass:[NSArray class]] && [contents count]>0) {
        topic.content = [NSMutableArray arrayWithCapacity:[contents count]];
        for (int i=0; i<[contents count]; i++) {
            WMMTopicCotent *tContent = [WMMTopicCotent modelFromDic:[contents objectAtIndex:i]];
            [topic.content addObject:tContent];
        }
    }
    
    topic.createTime = [NSDate dateWithTimeIntervalSince1970:[[dic objectOrNilForKey:@"created_at"] longLongValue]];
    topic.updateTime = [NSDate dateWithTimeIntervalSince1970:[[dic objectOrNilForKey:@"updated_at"] longLongValue]];
    
    return topic;
}

-(UIImage *)icon
{
    if (!_icon) {
        
        [[NKImageLoader imageLoader] addImageLoadObject:[NKImageLoadObject imageLoadObjectWithObject:self url:_iconPath andKeyPath:@"icon"]];
    }
    
    return _icon;
}


@end

@implementation WMMTopicCotent

-(void)dealloc
{
    [_type release];
    [_value release];
    [_image release];
    [super dealloc];
}

+(id)modelFromDic:(NSDictionary *)dic
{
    NSLog(@"*****: %@",dic);
    WMMTopicCotent *content = [super modelFromDic:dic];
    
    NKBindValueWithKeyForParameterFromDic(@"type", content.type, dic);
    NKBindValueWithKeyForParameterFromDic(@"value", content.value, dic);
    
    return content;
}

-(UIImage *)image
{
    //_value = nil;
    if ([_type isEqualToString:@"pic"] && !_image) {
        [[NKImageLoader imageLoader] addImageLoadObject:[NKImageLoadObject imageLoadObjectWithObject:self url:_value andKeyPath:@"image"]];
    }
    return _image;
}


@end

@implementation WMMTopicBoard

-(void)dealloc
{
    [_count release];
    [_titles release];
    [_name release];
    [_icon release];
    [_iconPath release];
    [_doorCloseMsg release];
    [super dealloc];
}

+(id)modelFromDic:(NSDictionary *)dic
{
    WMMTopicBoard *topic = [super modelFromDic:dic];
        
    NKBindValueWithKeyForParameterFromDic(@"name", topic.name, dic);
    NKBindValueWithKeyForParameterFromDic(@"count", topic.count, dic);
    NKBindValueWithKeyForParameterFromDic(@"icon", topic.iconPath, dic);
    NKBindValueWithKeyForParameterFromDic(@"door_close_msg", topic.doorCloseMsg, dic);
    
    topic.doorClose = [[dic valueForKey:@"door_close"] boolValue];
    
    NSArray *titles = [dic objectOrNilForKey:@"titles"];
    if ([titles isKindOfClass:[NSArray class]] && [titles count]>0) {
        topic.titles = [NSMutableArray arrayWithCapacity:[titles count]];
        for (int i=0; i<[titles count]; i++) {
            [topic.titles addObject:[titles objectAtIndex:i]];
        }
    }
    
    return topic;
}

-(UIImage *)icon
{
    if (!_icon) {
        
        [[NKImageLoader imageLoader] addImageLoadObject:[NKImageLoadObject imageLoadObjectWithObject:self url:_iconPath andKeyPath:@"icon"]];
    }
    
    return _icon;
}

@end


@implementation WMMTopicPicad

-(void)dealloc{
    
    [_title release];
    [_pic release];
    [_picPath release];
    [_topic_id release];
    [_type release];
    [super dealloc];
}

+(id)modelFromDic:(NSDictionary *)dic{
    
    WMMTopicPicad *topicPicad = [super modelFromDic:dic];
    
    NKBindValueWithKeyForParameterFromDic(@"title", topicPicad.title, dic);
    NKBindValueWithKeyForParameterFromDic(@"pic", topicPicad.picPath, dic);
    NKBindValueWithKeyForParameterFromDic(@"url", topicPicad.url, dic);
     NKBindValueWithKeyForParameterFromDic(@"type", topicPicad.type, dic);
     NKBindValueWithKeyForParameterFromDic(@"topic_id", topicPicad.topic_id, dic);
    return topicPicad;
    
}

-(UIImage*)pic{
    
    if (!_pic) {
        
        [[NKImageLoader imageLoader] addImageLoadObject:[NKImageLoadObject imageLoadObjectWithObject:self url:_picPath andKeyPath:@"pic"]];
    }
    
    return _pic;
    
    
}

@end


@implementation WMMTopicComment

-(void)dealloc{
    
    [_content release];
    [_sender release];
    [_createTime release];
    [_touserid release];
    [_prefix release];
    [_reply_comment release];
    [_reply_commentid release];
    [_reply_content release];
    [_reply_title release];
    
    [_audioURLString release];
    [_audioSecond release];
    
    [super dealloc];
}

+(id)modelFromDic:(NSDictionary *)dic{
    
    WMMTopicComment *comment = [super modelFromDic:dic];
    
    NKBindValueWithKeyForParameterFromDic(@"touserid", comment.touserid, dic);
    NKBindValueWithKeyForParameterFromDic(@"prefix", comment.prefix, [dic valueForKey:@"data"]);
    NKBindValueWithKeyForParameterFromDic(@"reply_comment", comment.reply_comment, [dic valueForKey:@"data"]);
    NKBindValueWithKeyForParameterFromDic(@"reply_commentid", comment.reply_commentid, [dic valueForKey:@"data"]);
    NKBindValueWithKeyForParameterFromDic(@"content", comment.reply_content, [dic valueForKey:@"data"]);
    NKBindValueWithKeyForParameterFromDic(@"title", comment.reply_title, [dic valueForKey:@"data"]);
    
    NKBindValueWithKeyForParameterFromDic(@"audio", comment.audioURLString, [dic valueForKey:@"data"]);
    NKBindValueWithKeyForParameterFromDic(@"audio_seconds", comment.audioSecond, [dic valueForKey:@"data"]);
    
    NSDictionary *user = [dic objectOrNilForKey:@"user"];
    if (user) {
        comment.sender = [WMMUser modelFromDic:user];
    }
    NSArray *contents = [dic objectOrNilForKey:@"content_array"];
    if ([contents isKindOfClass:[NSArray class]] && [contents count]>0) {
        comment.content = [NSMutableArray arrayWithCapacity:[contents count]];
        for (int i=0; i<[contents count]; i++) {
            WMMTopicCotent *tContent = [WMMTopicCotent modelFromDic:[contents objectAtIndex:i]];
            [comment.content addObject:tContent];
        }
    }
    comment.createTime = [NSDate dateWithTimeIntervalSince1970:[[dic objectOrNilForKey:@"time"] longLongValue]];
    
    return comment;
    
}

- (NSString *)firstTxetReply {
    if (self.content) {
        for (WMMTopicCotent *con in self.content) {
            if ([con.type isEqualToString:@"text"]) {
                return con.value;
            }
        }
    }
    
    return nil;
}

@end

@implementation WMMTopicNotification

+ (id)modelFromDic:(NSDictionary *)dic {
    WMMTopicNotification *model = [super modelFromDic:dic];
    
    NKBindValueWithKeyForParameterFromDic(@"typeid", model.topicID, dic);
    NKBindValueWithKeyForParameterFromDic(@"topicnick", model.nick, dic[@"byuser"]);
    NKBindValueWithKeyForParameterFromDic(@"title", model.title, dic[@"data"]);
    NKBindValueWithKeyForParameterFromDic(@"content", model.content, dic[@"data"]);
    NKBindValueWithKeyForParameterFromDic(@"message", model.message, dic);
    
    id replyComment = dic[@"data"][@"reply_comment"];
    
    if (replyComment && ![replyComment isKindOfClass:[NSNull class]]) {
        model.reply = [NSString stringWithFormat:@"回复我的 “%@”", replyComment];
    } else {
        model.reply = [NSString stringWithFormat:@"回复我的帖子《%@》", dic[@"data"][@"title"]];
    }
    
    model.createTime = [NSDate dateWithTimeIntervalSince1970:[dic[@"created_at"] longLongValue]];
    
    return model;
}

- (void)dealloc {
    [_topicID release];
    [_nick release];
    [_createTime release];
    [_title release];
    [_reply release];
    
    [super dealloc];
}

@end