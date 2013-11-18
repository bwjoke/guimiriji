//
//  WMWeiboUser.m
//  WEIMI
//
//  Created by steve on 13-5-24.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMWeiboUser.h"

@implementation WMWeiboUser

@synthesize name;
@synthesize weiboId;
@synthesize avatarPath;
@synthesize avatar;

-(void)dealloc
{
    [name release];
    [weiboId release];
    [avatarPath release];
    [avatar release];
    [super dealloc];
}

+(id)modelFromDic:(NSDictionary *)dic
{
    WMWeiboUser *weiboUser = [super modelFromDic:dic];
    NKBindValueWithKeyForParameterFromDic(@"name", weiboUser.name, dic);
    NKBindValueWithKeyForParameterFromDic(@"id", weiboUser.weiboId, dic);
    NKBindValueWithKeyForParameterFromDic(@"profile_image_url", weiboUser.avatarPath, dic);
    weiboUser.localHasInvited = NO;
    
    if (dic[@"invited"] && [dic[@"invited"] boolValue] == YES) {
        weiboUser.hasInvited = YES;
    }
    
    return weiboUser;
}

-(UIImage*)avatar{
    
    if (!avatar) {
        
        [[NKImageLoader imageLoader] addImageLoadObject:[NKImageLoadObject imageLoadObjectWithObject:self url:avatarPath andKeyPath:@"avatar"]];
    }
    
    return avatar;
    
    
}
@end

/*
{
    "error": 10000,
    "data": {
        "code": 200,
        "page": 1,
        "maxpage": 16,
        "data": [
                 {
                     "id": 1732442317,
                     "idstr": "1732442317",
                     "screen_name": "耙嫂",
                     "name": "耙嫂",
                     "province": "50",
                     "city": "6",
                     "location": "重庆 沙坪坝区",
                     "description": "",
                     "url": "",
                     "profile_image_url": "http://tp2.sinaimg.cn/1732442317/50/5644568137/0",
                     "profile_url": "u/1732442317",
                     "domain": "",
                     "weihao": "",
                     "gender": "f",
                     "followers_count": 67,
                     "friends_count": 40,
                     "statuses_count": 41,
                     "favourites_count": 0,
                     "created_at": "Tue Jul 06 14:24:39 +0800 2010",
                     "following": false,
                     "allow_all_act_msg": false,
                     "geo_enabled": true,
                     "verified": false,
                     "verified_type": -1,
                     "remark": "",
                     "status": {
                         "created_at": "Fri May 17 09:28:25 +0800 2013",
                         "id": 3578876473447621,
                         "mid": "3578876473447621",
                         "idstr": "3578876473447621",
                         "text": " @粟栗微博  胖哥，周大猫[可怜]",
                         "source": "<a href=\"http://app.weibo.com/t/feed/9ksdit\" rel=\"nofollow\">iPhone客户端</a>",
                         "favorited": false,
                         "truncated": false,
                         "in_reply_to_status_id": "",
                         "in_reply_to_user_id": "",
                         "in_reply_to_screen_name": "",
                         "pic_urls": [],
                         "geo": null,
                         "reposts_count": 0,
                         "comments_count": 0,
                         "attitudes_count": 0,
                         "mlevel": 0,
                         "visible": {
                             "type": 0,
                             "list_id": 0
                         }
                     },
                     "allow_all_comment": true,
                     "avatar_large": "http://tp2.sinaimg.cn/1732442317/180/5644568137/0",
                     "verified_reason": "",
                     "follow_me": false,
                     "online_status": 0,
                     "bi_followers_count": 18,
                     "lang": "zh-cn",
                     "star": 0,
                     "mbtype": 0,
                     "mbrank": 0,
                     "block_word": 0
                 }
                 ]
    }
}

*/