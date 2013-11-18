//
//  WMMessage.m
//  WEIMI
//
//  Created by steve on 13-9-11.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMMessage.h"

NSString *const ZUOMMessageSendStateSending = @"发送中";
NSString *const ZUOMMessageSendStateSuccess = @"送达";
NSString *const ZUOMMessageSendStateFailed = @"发送失败";

@implementation WMMessage

@synthesize messageId;
@synthesize sender;
@synthesize content;
@synthesize createAt;
@synthesize type;
@synthesize sendState;
@synthesize contentText;
@synthesize switchState;
@synthesize image;
@synthesize imageUrl;
@synthesize audioUrl;
@synthesize audioLength;


-(NSString*)description{
    
    return [NSString stringWithFormat:@"<%@> content:%@, id:%@, sender:%@, ", NSStringFromClass([self class]), content, messageId, sender];
}

+(id)modelFromDic:(NSDictionary *)dic
{
    WMMessage *newMessage = [[self alloc] init];
    
    newMessage.jsonDic = dic;
    
    newMessage.type = [[dic objectOrNilForKey:@"type"] stringValue];
    if ([newMessage.type isEqualToString:@"1"]||[newMessage.type isEqualToString:@"4"] ) {
        newMessage.content = [[dic objectOrNilForKey:@"content"] dataUsingEncoding:NSUTF8StringEncoding];
        newMessage.contentText = [dic objectOrNilForKey:@"content"];
    }else if ([newMessage.type isEqualToString:@"2"]) {
        newMessage.imageUrl = [dic objectOrNilForKey:@"content"];
    }else if ([newMessage.type isEqualToString:@"3"]) {
        newMessage.audioUrl = [dic objectOrNilForKey:@"content"];
        newMessage.audioLength = [dic objectOrNilForKey:@"audio_seconds"];
    }
    
    newMessage.messageId = [[dic objectOrNilForKey:@"id"] stringValue];
    NSDictionary *user_dic = @{@"id":[dic objectOrNilForKey:@"user_id"]};
    newMessage.sender = [WMMUser userFromDic:user_dic];
    newMessage.createAt = [NSDate dateWithTimeIntervalSince1970:[[dic objectOrNilForKey:@"time"] longLongValue]];
    newMessage.switchState = [dic valueForKey:@"switch"];
    return newMessage;
    
}

-(UIImage *)image
{
    //_value = nil;
    if ([type isEqualToString:@"2"] && !image) {
        [[NKImageLoader imageLoader] addImageLoadObject:[NKImageLoadObject imageLoadObjectWithObject:self url:imageUrl andKeyPath:@"image"]];
    }
    return image;
}

@end
