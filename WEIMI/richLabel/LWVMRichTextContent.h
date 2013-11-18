//
//  LWVMCommentContent.h
//  Laiwang
//
//  Created by Levy's on 12-12-2.
//  Copyright (c) 2012年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

// 节点类型：文本类型和表情类型
typedef enum{
	LWVMRichTextNodeTypeText,
	LWVMRichTextNodeTypeEmotion
}LWVMRichTextNodeType;

// 显示类型：主墙类型和评论类型
typedef enum{
	LWVMRichTextShowContentTypeWall,
    LWVMRichTextShowContentTypeFeedDetail,
    LWVMRichTextShowContentTypeMiyuDetail,
	LWVMRichTextShowContentTypeComment,
	LWVMRichTextShowContentTypeNotification,
	LWVMRichTextShowContentTypeFriendMessage,
    LWVMRichTextShowContentTypeChat,
    LWVMRichTextShowContentTypeFeed,
    LWVMRichTextTypeFeedList,
    LWVMRichTextTypeFeedListWithAttachment
}LWVMRichTextShowContentType;

// 评论content的节点：分段显示的内容
@interface LWVMRichTextContentNode : NSObject
{
    LWVMRichTextNodeType _type;     // 节点的类型：文本还是表情
    CGRect _frame;          // 节点的显示位置，文本最多一行显示
    NSString *_text;        // 文本显示的内容
    NSString *_emotionURL;  // 表情url地址
}
@property (nonatomic, assign) LWVMRichTextNodeType type;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *emotionURL;

@end

// 评论的content展示具体内容，如果有表情，就分段显示，否则就只显示文本
@interface LWVMRichTextContent : NSObject
{
    NSMutableArray *_nodes;     // 各个节点
    CGFloat _height;            // content的显示高度
    CGFloat _width;             // content的显示宽度
    UIFont *_contentFont;       // 显示的文本字体
    CGFloat _maxWidth;          // 显示的最大宽度
    NSInteger _maxLineCount;    // 显示的最大的行数，0表示没限制
    CGFloat _showOriginX;       // 显示node的起始坐标x
    CGFloat _showOriginY;       // 显示node的起始坐标y
    CGFloat _hasChangedOriginX; // 已经变换的坐标x
    CGFloat _hasChangedOriginY; // 已经变换的坐标y
    CGFloat _textSpace;         // 文字之间的间距
}
@property (nonatomic, retain) NSMutableArray *nodes;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

- (id)initWithContent:(NSString *)content withType:(LWVMRichTextShowContentType)type;
- (void)resetNodeFrameWithOriginX:(CGFloat)originX withOriginY:(CGFloat)originY;

@end
