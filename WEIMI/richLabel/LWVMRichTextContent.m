//
//  LWVMCommentContent.m
//  Laiwang
//
//  Created by Levy's on 12-12-2.
//  Copyright (c) 2012年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import "LWVMRichTextContent.h"
#import "LWEmotionDataSource.h"
#import "RegexKitLite.h"
#import "LWVMEmotion.h"
#import "ZUOCommentCell.h"
//#import "ZUOFeedCell.h"
//#import "ZUOChatCell.h"
//#import "LWStringOperation.h"

#define kVMCommentNodeTypeKey @"VMCommentNodeType"
#define kVMCommentNodeFrameKey @"VMCommentNodeFrame"
#define kVMCommentNodeTextKey @"VMCommentNodeText"
#define kVMCommentNodeEmotionURLKey @"VMCommentNodeEmotionURL"
#define kVMCommentContentNodeKey @"VMCommentContentNode"
#define kVMCommentContentHeightKey @"VMCommentContentHeight"


#define kFDCommentContentEmotionWidth [_contentFont lineHeight]
#define kFDCommentContentEmotionSpace 2
#define kFDCommentContentEmotionHeight [_contentFont lineHeight]
#define EmojiCharacterLength 2

@implementation LWVMRichTextContentNode
@synthesize type = _type;
@synthesize frame = _frame;
@synthesize text = _text;
@synthesize emotionURL = _emotionURL;

- (void)dealloc
{
    [_text release];
    [_emotionURL release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt32:_type forKey:kVMCommentNodeTypeKey];
    [encoder encodeCGRect:_frame forKey:kVMCommentNodeFrameKey];
    [encoder encodeObject:_text forKey:kVMCommentNodeTextKey];
    [encoder encodeObject:_emotionURL forKey:kVMCommentNodeEmotionURLKey];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.type = [decoder decodeInt32ForKey:kVMCommentNodeTypeKey];
        self.frame = [decoder decodeCGRectForKey:kVMCommentNodeFrameKey];
        self.text = [decoder decodeObjectForKey:kVMCommentNodeTextKey];
        self.emotionURL = [decoder decodeObjectForKey:kVMCommentNodeEmotionURLKey];
    }
    
    return self;
}

#pragma mark -
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    LWVMRichTextContentNode *copy = [[[self class] allocWithZone:zone] init];
    copy.type = self.type;
    copy.frame = self.frame;
    copy.text = [[self.text copyWithZone:zone] autorelease];
    copy.emotionURL = [[self.emotionURL copyWithZone:zone] autorelease];
    
    return copy;
}

@end

@interface LWVMRichTextContent ()

- (BOOL)isContentHasEmotion:(NSString *)content;
- (void)addSingleNodeWithContent:(NSString *)content;

@end

@implementation LWVMRichTextContent
@synthesize nodes = _nodes;
@synthesize height = _height;
@synthesize width = _width;
- (void)dealloc
{
    [_nodes release];
    
    [super dealloc];
}

// 根据类型来初始化变量
- (void)initVariableWithType:(LWVMRichTextShowContentType)type
{
    _hasChangedOriginX = 0;
    _hasChangedOriginY = 0;
    switch (type) {
        case LWVMRichTextShowContentTypeWall:
//            _contentFont = FeedCellContentFont;
//            _maxWidth = FeedCellContentFrameWidth;
//            _maxLineCount = FeedCellContentMaxHeight/20;
            _textSpace = 0;
            break;
            
        case LWVMRichTextShowContentTypeMiyuDetail:
            _contentFont = [UIFont systemFontOfSize:14];
            _maxWidth = 290;
            _maxLineCount = 0;
            _textSpace = 0;
            break;
        case LWVMRichTextShowContentTypeFeedDetail:
            _contentFont = [UIFont systemFontOfSize:14];
            _maxWidth = 294;
            _maxLineCount = 0;
            _textSpace = 3;
            break;
        case LWVMRichTextShowContentTypeComment:
            _contentFont = CommentCellcontentFont;
            _maxWidth = CommentCellcontentWidth;
            _maxLineCount = 0;
            _textSpace = 3;
            break;
        case LWVMRichTextShowContentTypeNotification:
            _contentFont = [UIFont systemFontOfSize:14];
            _maxWidth = 245;
            _maxLineCount = 1;
            _textSpace = 0;
            break;
        case LWVMRichTextShowContentTypeFriendMessage:
            _contentFont = [UIFont systemFontOfSize:14];
            _maxWidth = 180;
            _maxLineCount = 0;
            _textSpace = 0;
            break;
        case LWVMRichTextShowContentTypeFeed:
            _contentFont = CommentCellcontentFont;
            _maxWidth = 224;
            _maxLineCount = 0;
            _textSpace = 3;
            break;
        case LWVMRichTextShowContentTypeChat:
            _contentFont = [UIFont systemFontOfSize:14];
            _maxWidth = 172;
            _maxLineCount = 0;
            _textSpace = 3;
            break;
        case LWVMRichTextTypeFeedList:
            _contentFont = [UIFont systemFontOfSize:14];
            _maxWidth = 227;
            _maxLineCount = 7;
            _textSpace = 3;
            break;
        case LWVMRichTextTypeFeedListWithAttachment:
            _contentFont = [UIFont systemFontOfSize:14];
            _maxWidth = 140;
            _maxLineCount = 4;
            _textSpace = 3;
            break;
        default:
            break;
    }
}

// 初始化VMCommentContent
- (id)initWithContent:(NSString *)content withType:(LWVMRichTextShowContentType)type
{
	if (self = [super init]) {
        if (!content || [content isEqualToString:@""]) {
            [self addTextNode:@"" frame:CGRectZero];
            self.height = 0;
            self.width = 0;
        }
        else {
            [self initVariableWithType:type];
            //NSString *adjustContent = [LWStringOperation adjustATagMsg:content];
            //adjustContent = [content gtm_stringByUnescapingFromHTML];
            NSString *adjustContent = content;
            BOOL hasEmotion = [self isContentHasEmotion:adjustContent];
            if (!hasEmotion) {
                [self addSingleNodeWithContent:adjustContent];
            }
            else {
                [self addMultipleNodesWithContent:adjustContent];
            }
//            [self isContentHasEmotion:content];
//            [self addMultipleNodesWithContent:content];
        }
	}
	return self;
}

//判断是否包含emoji
- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

// 判断content是否包含表情
- (BOOL)isContentHasEmotion:(NSString *)content
{
    NSRange searchRange = NSMakeRange(0, content.length);
    NSString *rex = [[LWEmotionDataSource sharedLWEmotionDataSource] getEmotionRex];
    NSRange startRang = [content rangeOfRegex:rex inRange:searchRange];
    if (startRang.location != NSNotFound) {
        return YES;
    }
    return NO;
}

// 添加文本node
- (void)addTextNode:(NSString *)text frame:(CGRect)frame
{
    if (!self.nodes) {
        self.nodes = [NSMutableArray array];
    }
    LWVMRichTextContentNode *node = [[LWVMRichTextContentNode alloc] init];
    node.type = LWVMRichTextNodeTypeText;
    node.text = [NSString stringWithString:text];
    node.frame = frame;
    [_nodes addObject:node];
    [node release];
}

// 添加表情node
- (void)addEmotionNode:(NSString *)emotionURL frame:(CGRect)frame
{
    if (!self.nodes) {
        self.nodes = [NSMutableArray array];
    }
    LWVMRichTextContentNode *node = [[LWVMRichTextContentNode alloc] init];
    node.type = LWVMRichTextNodeTypeEmotion;
    node.emotionURL = [NSString stringWithString:emotionURL];
    node.frame = frame;
    [_nodes addObject:node];
    [node release];
}

// 全部内容都是文本，则只有一个node
- (void)addSingleNodeWithContent:(NSString *)content
{
    CGFloat singleHeight = _contentFont.ascender - _contentFont.descender + 1;
    CGSize contentStrSize = [content sizeWithFont:_contentFont
                                constrainedToSize:CGSizeMake(_maxWidth, CGFLOAT_MAX)
                                    lineBreakMode:UILineBreakModeWordWrap];
    self.height = contentStrSize.height;
    if (_maxLineCount>0 && self.height > _maxLineCount*singleHeight) {
        self.height = _maxLineCount*singleHeight;
    }
    _width = [content sizeWithFont:[UIFont systemFontOfSize:14] forWidth:_maxWidth lineBreakMode:NSLineBreakByCharWrapping].width;
    [self addTextNode:content frame:CGRectMake(0, 0, _maxWidth, self.height)];
}

// 根据表情，把文本和表情分离
- (void)separateTextAndEmotionNode:(NSString *)content
{
    // 先根据表情，把content分成：“文本－－表情－－文本”的格式
    NSString *emotionRex = [[LWEmotionDataSource sharedLWEmotionDataSource] getEmotionRex];
    NSArray *emotions = [[LWEmotionDataSource sharedLWEmotionDataSource] emotions];
    
	NSInteger stringIndex = 0;
	while (stringIndex < content.length) {
		NSRange searchRange = NSMakeRange(stringIndex, content.length - stringIndex);
		NSRange startRange = [content rangeOfRegex:emotionRex inRange:searchRange];
		// 如果有表情符号，把表情前面的文本作为node存下来，再把表情的node存下
		if (startRange.location != NSNotFound) {
			NSRange beforeRange = NSMakeRange(searchRange.location, startRange.location - searchRange.location);
			if (beforeRange.length) {
                NSString *sl = [content substringWithRange:beforeRange];
                [self separateTextAndEmojiNode:sl];
                //[self addTextNode:[content substringWithRange:beforeRange] frame:CGRectZero];
			}
			// 存下表情的node
			NSString *phrase = [content substringWithRange:startRange];
			for (LWVMEmotion *emo in emotions) {
				if ([phrase isEqualToString:emo.description]) {
                    [self addEmotionNode:emo.filename frame:CGRectZero];
					break;
				}
			}
            
			stringIndex = startRange.location + startRange.length;
            
//            NSRange afterRange = NSMakeRange(stringIndex+1,  searchRange.length - startRange.length);
//			if (afterRange.length) {
//                [self addTextNode:[content substringWithRange:afterRange] frame:CGRectZero];
//			}
		}
        // 如果没有表情符号了，则把剩下的文本作为node存下来
		else {
            NSString *sl = [content substringWithRange:searchRange];
            //[self addTextNode:sl frame:CGRectZero];
            [self separateTextAndEmojiNode:sl];
            break;
		}
	}
}

//将文本与Emoji表情分开
- (void)separateTextAndEmojiNode:(NSString *)content
{
    __block NSString *text = content;
    if (![self stringContainsEmoji:text]) {
        [self addTextNode:text frame:CGRectZero];
        return;
    }
    [text enumerateSubstringsInRange:NSMakeRange(0, content.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        //emoji length is 2  replace emoji with emptyString
        if (substring.length == EmojiCharacterLength) {
            [self addTextNode:substring frame:CGRectZero];
            text = [content substringWithRange:substringRange];
            if (![self stringContainsEmoji:text]) {
                //[self addTextNode:text frame:CGRectZero];
                return;
            }
        }else {
            [self addTextNode:substring frame:CGRectZero];
            text = [content substringWithRange:substringRange];
            if (![self stringContainsEmoji:text]) {
                //[self addTextNode:text frame:CGRectZero];
                return;
            }
        }
    }];
}
// 换行的处理，返回NO表示不用再继续处理了
- (BOOL)startForNewLine
{
    CGFloat singleHeight = _contentFont.ascender - _contentFont.descender + 1;
    _showOriginX = 0;
    _showOriginY += singleHeight+_textSpace;
    self.height = _showOriginY+singleHeight+_textSpace;
    if (_maxLineCount>0 && self.height > _maxLineCount*singleHeight) {
        self.height -= singleHeight;
        LWVMRichTextContentNode *node = [self.nodes lastObject];
        node.text = [NSString stringWithFormat:@"%@...", node.text];
        return NO;
    }
    
    return YES;
}

// 有文本有表情，有多个node，每行进行拆分
- (void)addMultipleNodesWithContent:(NSString *)content
{
    [self separateTextAndEmotionNode:content];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.nodes];
    self.nodes = [NSMutableArray array];
    CGFloat singleHeight = _contentFont.ascender - _contentFont.descender + 1;
    _showOriginX = 0;
    _showOriginY = 0;
    
    for (int nodeIndex=0; nodeIndex<[tempArray count]; nodeIndex++) {
        LWVMRichTextContentNode *node = [tempArray objectAtIndex:nodeIndex];
        if (LWVMRichTextNodeTypeEmotion == node.type) {
            
            // 如果表情加到文字后面超过maxWidth的话，另起一行显示
            if (_showOriginX+kFDCommentContentEmotionWidth + kFDCommentContentEmotionSpace>_maxWidth) {
                _width = _maxWidth;
                if (![self startForNewLine]) {
                    return;
                }
            }
            // 如果表情不是每行的开头，则在表情和文字之间增加emotionspace的距离
            if (_showOriginX != 0) {
                _showOriginX += kFDCommentContentEmotionSpace;
            }
            [self addEmotionNode:node.emotionURL frame:CGRectMake(_showOriginX, _showOriginY, kFDCommentContentEmotionWidth, kFDCommentContentEmotionHeight)];
            _showOriginX += kFDCommentContentEmotionWidth+kFDCommentContentEmotionSpace;
            _width = _showOriginX;
        }
        else {
            NSInteger lineStartIndex = 0;
            NSUInteger length = node.text.length;
            CGFloat lineWidth = 0;
            if ([self stringContainsEmoji:node.text]) {
                CGSize letterSize = [node.text sizeWithFont:_contentFont];
                if (_showOriginX + lineWidth + letterSize.width > _maxWidth) {
                    _width = _maxWidth;
                    CGFloat singleHeight = _contentFont.ascender - _contentFont.descender + 1;
                    //_showOriginX = 0;
                    //lineWidth = letterSize.width;
                    //_showOriginY += singleHeight+_textSpace;
                    if (![self startForNewLine]) {
                        return;
                    }
                    [self addTextNode:node.text frame:CGRectMake(_showOriginX, _showOriginY, letterSize.width, singleHeight)];
                    
                }else {
                    [self addTextNode:node.text frame:CGRectMake(_showOriginX, _showOriginY, letterSize.width, singleHeight)];
                    _showOriginX += letterSize.width;
                    _width = _showOriginX;
                }
            }else {
                for (int i=0; i < length; ) {
                    // 获取字符
                    NSString *c = [node.text substringWithRange:NSMakeRange(i, 1)];
                        // 如果是回车字符，则
                    
                    if ([c isEqualToString:@"\n"]) {
                        NSRange lineRange = NSMakeRange(lineStartIndex, i-lineStartIndex);
                        NSString *line = [node.text substringWithRange:lineRange];  // 获取行字符串
                        [self addTextNode:line frame:CGRectMake(_showOriginX, _showOriginY, lineWidth+5, singleHeight)];
                        if (![self startForNewLine]) {
                            return;
                        }
                        lineWidth = 0;
                        lineStartIndex = i+1;
                        i++;
                        continue;
                    }
                    CGSize letterSize = [c sizeWithFont:_contentFont]; // 字符尺寸
                    //如果 已占用行宽+字符宽度>行宽
                    if (_showOriginX + lineWidth + letterSize.width > _maxWidth) {
                        // 从行开始字符索引 到 当前字符索引
                        _width = _maxWidth;
                        NSRange lineRange = NSMakeRange(lineStartIndex, i-lineStartIndex);
                        if (lineRange.length) { // 如果存在字符
                            NSString *line = [node.text substringWithRange:lineRange];  // 获取行字符串
                            [self addTextNode:line frame:CGRectMake(_showOriginX, _showOriginY, lineWidth+5, singleHeight)];
                        }
                        if (![self startForNewLine]) {
                            return;
                        }
                        lineWidth = 0;
                        lineStartIndex = i;
                    }
                    else {
                        lineWidth += letterSize.width;
                        _width = lineWidth;
                        i++;
                    }
                    
                    
                    
                }
            }
            
            // 如果剩下来的text还没有显示，则加入node
            if (lineWidth) {
                NSRange lineRange = NSMakeRange(lineStartIndex, length-lineStartIndex);
                NSString *line = [node.text substringWithRange:lineRange];  // 获取行字符串
                [self addTextNode:line frame:CGRectMake(_showOriginX, _showOriginY, lineWidth+5, singleHeight)];
                _showOriginX += lineWidth;
                _width = _showOriginX;
            }
        }
        
    }
    if (0 == self.height) {
        self.height = singleHeight;
    }
    if (self.height>singleHeight) {
        _width = _maxWidth;
    }
}

// 根据起始位置不同来重新设置node的frame
- (void)resetNodeFrameWithOriginX:(CGFloat)originX withOriginY:(CGFloat)originY
{
    for (int nodeIndex=0; nodeIndex<[self.nodes count]; nodeIndex++) {
        LWVMRichTextContentNode *node = [self.nodes objectAtIndex:nodeIndex];
        CGRect frame = node.frame;
        frame.origin.x += -_hasChangedOriginX+originX;
        frame.origin.y += -_hasChangedOriginY+originY;
        node.frame = frame;
    }
    _hasChangedOriginX = originX;
    _hasChangedOriginY = originY;
}
//
//#pragma mark -
//#pragma mark NSCoding
//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    [encoder encodeObject:_nodes forKey:kVMCommentContentNodeKey];
//    [encoder encodeDouble:_height forKey:kVMCommentContentHeightKey];
//}
//
//- (id)initWithCoder:(NSCoder *)decoder
//{
//    if (self = [super init]) {
//        self.nodes = [decoder decodeObjectForKey:kVMCommentContentNodeKey];
//        self.height = [decoder decodeDoubleForKey:kVMCommentContentHeightKey];
//    }
//    
//    return self;
//}
//
//#pragma mark -
//#pragma mark NSCopying
//- (id)copyWithZone:(NSZone *)zone
//{
//    LWVMCommentContent *copy = [[[self class] allocWithZone:zone] init];
//    copy.nodes = [[self.nodes copyWithZone:zone] autorelease];
//    copy.height = self.height;
//    
//    return copy;
//}


@end
