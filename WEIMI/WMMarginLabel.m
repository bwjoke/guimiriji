//
//  WMMarginLabel.m
//  WEIMI
//
//  Created by ZUO on 6/28/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMMarginLabel.h"

@implementation WMMarginLabel

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

- (void)setMargin:(CGFloat)margin {
    self.insets = UIEdgeInsetsMake(margin, margin, margin, margin);
}

@end
