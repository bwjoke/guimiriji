//
//  WMCustomLabel.m
//  
//
//  Created by steve on 13-4-9.
//  Copyright (c) 2013年 Steve. All rights reserved.
//

#import "WMCustomLabel.h"
#import "UIColor+HexString.h"

@implementation WMCustomLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont systemFontOfSize:12.0];
        self.textAlignment = UITextAlignmentLeft;
        self.textColor = [UIColor colorWithHexString:@"#A6937C"];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.font = font;
        self.textAlignment = UITextAlignmentLeft;
        self.textColor = textColor;
    }
    return self;
}

- (BOOL)isSupportAttributedText {
    return [self respondsToSelector:@selector(attributedText)];
}

- (void)setTextColor:(UIColor *)textColor range:(NSRange)range
{
    // Only available in iOS 6.0 or later
    if ([self isSupportAttributedText]) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: self.attributedText];
        [text addAttribute: NSForegroundColorAttributeName
                     value: textColor
                     range: range];
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        [self setAttributedText: text];
    }
}

- (void)setFont:(UIFont *)font range:(NSRange)range
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: [[NSAttributedString alloc] initWithString:self.text]];
    
    // Only available in iOS 6.0 or later
    if ([self isSupportAttributedText]) {
        [text addAttribute: NSFontAttributeName
                     value: font
                     range: range];
        [self setAttributedText: text];
    }
    
}

-(void)setRoundBackgroundWithText:(NSString *)text bgColor:(UIColor *)bgColor fontSize:(CGFloat )fontSize textColor:(UIColor *)color
{
    self.layer.cornerRadius = 10.0;
    self.backgroundColor = bgColor;
    CGRect frame = self.frame;
    frame.size.width = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, fontSize) lineBreakMode:NSLineBreakByCharWrapping].width + 20;
    self.text = text;
    self.textAlignment  = NSTextAlignmentCenter;
    self.font = [UIFont boldSystemFontOfSize:fontSize];
    self.textColor = color;
    self.frame = frame;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
