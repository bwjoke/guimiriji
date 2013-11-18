//
//  WMIMService.m
//  WEIMI
//
//  Created by steve on 13-9-10.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMIMService.h"
#import "WMMessage.h"

@implementation WMIMService
$singleService(WMIMService, @"im");

static NSString *const WMAPIGetIMList = @"/list";
-(NKRequest*)getIMList:(NSString *)uid last_id:(NSString *)last_id size:(int)size andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetIMList];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMessage class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (uid) {
        [newRequest addPostValue:uid forKey:@"user_id"];
    }
    
    if (last_id) {
        [newRequest addPostValue:last_id forKey:@"last_id"];
    }
    
    if (size) {
        [newRequest addPostValue:[NSString stringWithFormat:@"%d",size] forKey:@"size"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPINewIMList = @"/check_for_new";
-(NKRequest*)checkForNewMessage:(NSString *)uid last_id:(NSString *)last_id andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPINewIMList];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMessage class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (uid) {
        [newRequest addPostValue:uid forKey:@"user_id"];
    }
    
    if (last_id) {
        [newRequest addPostValue:last_id forKey:@"last_id"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}


static NSString *const WMAPIPostIM = @"/post";
-(NKRequest*)postIM:(NSString *)type user_id:(NSString *)uid content:(NSData *)content audio_seconds:(NSString *)audio_seconds switchState:(NSString *)switchState andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIPostIM];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMessage class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (uid) {
        [newRequest addPostValue:uid forKey:@"user_id"];
    }
    
    if (!type) {
        type = @"1";
    }else {
        [newRequest addPostValue:type forKey:@"type"];
    }
    
    if (audio_seconds) {
        [newRequest addPostValue:audio_seconds forKey:@"audio_seconds"];
    }
    
    if (switchState) {
        [newRequest addPostValue:switchState forKey:@"switch"];
    }
    
    if (content) {
        switch ([type intValue]) {
            case 1:
                [newRequest addPostValue:[[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding] forKey:@"content"];
                break;
            case 2:
                [newRequest addData:content withFileName:@"fromIphone.jpg" andContentType:@"image/jpeg" forKey:@"content"];
                break;
            case 3:
                [newRequest addData:content withFileName:@"fromIphone.amr" andContentType:@"audio/amr" forKey:@"content"];
                break;
                
            case 4:
                [newRequest addPostValue:[[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding] forKey:@"content"];
            break;
            default:
                break;
        }
        
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIPostDeleteOne = @"/delete";
- (NKRequest *)deleteOneMessage:(WMMessage *)message andRequestDelegate:(NKRequestDelegate *)rd {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIPostDeleteOne];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMessage class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (message) {
        [newRequest addPostValue:message.messageId forKey:@"id"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIPostDeleteAll = @"/delete_all";
- (NKRequest *)deleteAllMessage:(WMMUser *)yourFriend andRequestDelegate:(NKRequestDelegate *)rd {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIPostDeleteAll];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMessage class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (yourFriend) {
        [newRequest addPostValue:yourFriend.mid forKey:@"user_id"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

@end
