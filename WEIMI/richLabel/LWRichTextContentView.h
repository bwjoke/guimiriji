//
//  LWCommentContentView.h
//  Laiwang
//
//  Created by Levy's on 12-11-30.
//  Copyright (c) 2012年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWVMRichTextContent.h"

@interface LWRichTextContentView : UIView
{
    LWVMRichTextContent *_richTextContent;
    UIFont *_textFont;
    UIColor *_textColor;
    UIColor *_textShadowColor;
    CGSize _textShadowOffSet;
    NSMutableAttributedString *resultAttributedString;
}
@property(nonatomic,retain) LWVMRichTextContent *richTextContent;
@property(nonatomic,assign) UIFont *textFont;
@property(nonatomic,retain) UIColor *textColor;
@property(nonatomic,retain) UIColor *textShadowColor;
@property(nonatomic,assign) CGSize textShadowOffSet;

- (id)initWithFrame:(CGRect)frame
           withFont:(UIFont *)font
      withTextColor:(UIColor *)color
withTextShadowColor:(UIColor *)shadowColor
withTextShadowOffSet:(CGSize)shadowOffset;

-(void)setKeyWordTextArray:(NSArray *)keyWordArray WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor;

@end
