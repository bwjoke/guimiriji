//
//  LWEmotionDataSource.m
//  Laiwang
//
//  Created by Levy's on 12-11-29.
//  Copyright (c) 2012年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import "LWEmotionDataSource.h"
#import "LWVMEmotion.h"

#define kEmotionDSDesKey @"key"
#define kEmotionDSNameKey @"picture"

@interface LWEmotionDataSource ()
- (void)insertEmotions;
- (void)initEmotionRex;
@end

@implementation LWEmotionDataSource
@synthesize emotions = _emotions;
@synthesize emotionRex = _emotionRex;

$singleton(LWEmotionDataSource);

- (void)dealloc
{
    [_emotions release];
    [_emotionRex release];
    
    [super dealloc];
}

// 初始化数据
- (void)initLWEmotionDataSource
{
    if (!_emotions) {
        self.emotions = [NSMutableArray array];
        [self insertEmotions];
        [self initEmotionRex];
    }
}

- (NSArray *)emotionArray
{
    if (!_emotions) {
        [self initLWEmotionDataSource];
    }
    
    return _emotions;
}

- (void)insertEmotions
{
    
    
    NSArray *emojos = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emojo" ofType:@"plist"]];

    for (NSDictionary *emoDic in emojos) {
        LWVMEmotion *emotion = [[LWVMEmotion alloc] initWithDescription:[emoDic objectForKey:kEmotionDSDesKey]
                                                               filename:[emoDic objectForKey:kEmotionDSNameKey]];
        [self.emotions addObject:emotion];
        [emotion release];
    }
}

// 初始化表情的索引
- (void)initEmotionRex
{
    self.emotionRex = [NSMutableString stringWithString:@""];
    for (int i=0; i<self.emotions.count; i++) {
        LWVMEmotion *emotion = [self.emotions objectAtIndex:i];
        [_emotionRex appendString:[[emotion.description stringByReplacingOccurrencesOfString:@"(" withString:@"\\("] stringByReplacingOccurrencesOfString:@")" withString:@"\\)"]];
        if (i < self.emotions.count - 1) {
            [_emotionRex appendString:@"|"];
        }
    }
}

- (NSMutableString *)getEmotionRex
{
    if (!self.emotionRex) {
        [self initLWEmotionDataSource];
    }
    
    return self.emotionRex;
}

// 把服务器返回的"[**]"替换为html显示的格式
- (NSString *)replaceEmoDesOfString:(NSString *)replaceString emoSize:(CGSize)size
{
    if (!_emotions) {
        [self initLWEmotionDataSource];
    }
    NSMutableString *replacedString = [NSMutableString stringWithString:replaceString];
    for (LWVMEmotion *emotion in self.emotions) {
        NSString *emoticonURL = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:emotion.filename];
        NSString *emotionURLStr = [NSString stringWithFormat:@"<img style=\"vertical-align:sub;padding:0 1px;\" src=\"%@\" alt=\"%@\" width=\"%d\" height=\"%d\" />", emoticonURL, emotion.description, (int)size.width, (int)size.height];
        [replacedString replaceOccurrencesOfString:emotion.description withString:emotionURLStr options:NSLiteralSearch range:NSMakeRange(0, replacedString.length)];
    }
    
    return replacedString;
}

// 判断该字符是否是表情
- (BOOL)isTextBelongToEmo:(NSString *)text
{
    if (!_emotions) {
        [self initLWEmotionDataSource];
    }
    for (LWVMEmotion *emotion in self.emotions) {
        if ([text isEqualToString:emotion.description]) {
            return YES;
        }
    }
    return NO;
}

@end
