//
//  WMMirror.m
//  WEIMI
//
//  Created by SteveMa on 13-11-4.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMMirror.h"

@implementation WMMirror

@synthesize title,url,iconUrl,icon,red;

+(id)modelFromDic:(NSDictionary *)dic
{
    WMMirror *newMirror = [[self alloc] init];
    NKBindValueWithKeyForParameterFromDic(@"title", newMirror.title, dic);
    NKBindValueWithKeyForParameterFromDic(@"url", newMirror.url, dic);
    NKBindValueWithKeyForParameterFromDic(@"icon", newMirror.iconUrl, dic);
    NKBindValueWithKeyForParameterFromDic(@"red", newMirror.red, dic);
    return newMirror;
}

-(UIImage *)icon
{
    [[NKImageLoader imageLoader] addImageLoadObject:[NKImageLoadObject imageLoadObjectWithObject:self url:iconUrl andKeyPath:@"icon"]];
    return icon;
}
@end
