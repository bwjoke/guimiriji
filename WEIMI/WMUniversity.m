//
//  WMUniversity.m
//  WEIMI
//
//  Created by steve on 13-8-10.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMUniversity.h"

@implementation WMUniversityManList

-(void)dealloc
{
    [_bigImage release];
    [_bigImagePath release];
    [_name release];
    [_type release];
    [_desc release];
    [_smallImages release];
    [super dealloc];
}

+(id)modelFromDic:(NSDictionary *)dic
{
    WMUniversityManList *list = [super modelFromDic:dic];
    NKBindValueWithKeyForParameterFromDic(@"name", list.name, dic);
    NKBindValueWithKeyForParameterFromDic(@"type", list.type, dic);
    NKBindValueWithKeyForParameterFromDic(@"description", list.desc, dic);
    NKBindValueWithKeyForParameterFromDic(@"big", list.bigImagePath, [dic valueForKey:@"data"]);
    NSArray *images = [[dic valueForKey:@"data"] valueForKey:@"small"];
    list.smallImages = [NSMutableArray array];
    for (int i=0; i<[images count]; i++) {
        [list.smallImages addObject:[images objectAtIndex:i]];
    }
    return list;
}


-(UIImage *)bigImage
{
    if (!_bigImage) {
        [[NKImageLoader imageLoader] addImageLoadObject:[NKImageLoadObject imageLoadObjectWithObject:self url:_bigImagePath andKeyPath:@"bigImage"]];
    }
    return _bigImage;
}
@end
