//
//  WMTextView.m
//  WEIMI
//
//  Created by ZUO on 7/1/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTextView.h"

@implementation WMTextView

- (void)dealloc {
    [_textView release];
    
    [super dealloc];
}

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
    textBack.frame = self.bounds;
    textBack.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:textBack];
    [textBack release];
    
    UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc] initWithFrame:self.bounds];
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:textView];
    self.textView = textView;
    [textView release];
}

- (void)setMargin:(CGFloat)margin {
    UIEdgeInsets insets = UIEdgeInsetsMake(margin, margin, margin, margin);
    self.textView.frame = UIEdgeInsetsInsetRect(self.bounds, insets);
}

- (void)setInsets:(UIEdgeInsets)insets {
    self.textView.frame = UIEdgeInsetsInsetRect(self.bounds, insets);
}

@end
