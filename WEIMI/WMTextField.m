//
//  WMTextField.m
//  WEIMI
//
//  Created by ZUO on 7/1/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTextField.h"

@implementation WMTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void)doInit {
    UIImageView *textBack = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"wm_input_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    [self addSubview:textBack];
    [textBack release];
    textBack.frame = self.bounds;
    textBack.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, self.insets);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, self.insets);
}

- (void)setMargin:(CGFloat)margin {
    self.insets = UIEdgeInsetsMake(margin, margin, margin, margin);
}

@end
