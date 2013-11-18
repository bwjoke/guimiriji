//
//  LWEmotionDataSource.h
//  Laiwang
//
//  Created by Levy's on 12-11-29.
//  Copyright (c) 2012年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKServiceBase.h"
#define kEmotionDidHighlightedNotiKey @"EmotionDidHighlighted"
#define kEmotionDidPickedNotiKey @"EmotionDidPicked"
#define kEmotionDeleteButtonPressedNotiKey @"EmotionDeleteButtonPressed"

// 来往表情的数据管理
@interface LWEmotionDataSource : NSObject
{
    NSMutableArray *_emotions;  // 所有表情Array
    NSMutableString *_emotionRex; // 表情索引，用来区分该text是否包含表情
}
@property (nonatomic, retain) NSMutableArray *emotions;
@property (nonatomic, retain) NSMutableString *emotionRex;

dshared(LWEmotionDataSource);

- (NSMutableString *)getEmotionRex;
- (NSArray *)emotionArray;
// 把服务器返回的"[**]"替换为html显示的格式
- (NSString *)replaceEmoDesOfString:(NSString *)replaceString emoSize:(CGSize)size;
// 判断该字符是否是表情
- (BOOL)isTextBelongToEmo:(NSString *)text;

@end
