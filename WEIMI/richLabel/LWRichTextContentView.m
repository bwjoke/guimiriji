//
//  LWCommentContentView.m
//  Laiwang
//
//  Created by Levy's on 12-11-30.
//  Copyright (c) 2012年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import "LWRichTextContentView.h"
#import <CoreText/CoreText.h>

@implementation LWRichTextContentView
 @synthesize textFont = _textFont;
@synthesize textColor = _textColor;
@synthesize textShadowColor = _textShadowColor;
@synthesize textShadowOffSet = _textShadowOffSet;

- (id)initWithFrame:(CGRect)frame
           withFont:(UIFont *)font
      withTextColor:(UIColor *)color
withTextShadowColor:(UIColor *)shadowColor
withTextShadowOffSet:(CGSize)shadowOffset
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.textFont = font;
        self.textColor = color;
        self.textShadowColor = shadowColor;
        self.textShadowOffSet = shadowOffset;
    }
    return self;
}

-(void)setKeyWordTextArray:(NSArray *)keyWordArray WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor{
    NSMutableArray *rangeArray = [[[NSMutableArray alloc]init] autorelease];
    for (int i = 0; i < [keyWordArray count]; i++) {
        NSString *keyString = [keyWordArray objectAtIndex:i];
        
        NSRange range = NSMakeRange(0, [keyString length]);;//[self.richTextContent rangeOfString:keyString];
        NSValue *value = [NSValue valueWithRange:range];
        if (range.length > 0) {
            [rangeArray addObject:value];
        }
    }
    for (NSValue *value in rangeArray) {
        NSRange keyRange = [value rangeValue];
        [resultAttributedString addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)keyWordColor.CGColor range:keyRange];
        CTFontRef ctFont1 = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize,NULL);
        [resultAttributedString addAttribute:(NSString *)(kCTFontAttributeName) value:(id)ctFont1 range:keyRange];
        CFRelease(ctFont1);
        
    }
    
}

- (void)dealloc
{
    
    [_richTextContent release];
    [_textColor release];
    [_textShadowColor release];
    
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    if (!_richTextContent.nodes) {
        return;
    }
    
    for (LWVMRichTextContentNode *node in _richTextContent.nodes) {
        if (LWVMRichTextNodeTypeText == node.type) {
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextSaveGState(ctx);
            CGContextAddRect(ctx, node.frame);
            CGContextClip(ctx);
            NSString *dfs = node.text;
            [_textColor setFill];
            if (_textShadowColor) {
                CGContextSetShadowWithColor(ctx, _textShadowOffSet, 1, _textShadowColor.CGColor);
            }
            [dfs drawInRect:node.frame
                   withFont:_textFont
              lineBreakMode:UILineBreakModeCharacterWrap];
            CGContextRestoreGState(ctx);
        }
        else if (LWVMRichTextNodeTypeEmotion == node.type) {
            UIImage *image = [UIImage imageNamed:node.emotionURL];
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextSaveGState(ctx);
            CGContextAddRect(ctx, node.frame);
            CGContextClip(ctx);
            [image drawInRect:node.frame];
            CGContextRestoreGState(ctx);
        }
    }
}

@end
