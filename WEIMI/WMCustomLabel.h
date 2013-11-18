//
//  WMCustomLabel.h
//  WEIMI
//
//  Created by steve on 13-4-9.
//  Copyright (c) 2013年 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMCustomLabel : UILabel

- (id)initWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor;

- (void)setTextColor:(UIColor *)textColor range:(NSRange)range;
- (void)setFont:(UIFont *)font range:(NSRange)range;
-(void)setRoundBackgroundWithText:(NSString *)text bgColor:(UIColor *)bgColor fontSize:(CGFloat )fontSize textColor:(UIColor *)color;
@end
