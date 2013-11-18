//
//  WMHelpView.m
//  WEIMI
//
//  Created by steve on 13-5-15.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMHelpView.h"

@implementation WMHelpView

- (void)dealloc {
    [_helpDidRemoved release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [imageView addGestureRecognizer:singleTap];
        [self addSubview:imageView];
    }
    return self;
}

-(void)setImage:(UIImage *)image
{
    imageView.image = image;
}

-(void)singleTap:(id)sender
{
    if (self.helpDidRemoved != nil) {
        self.helpDidRemoved();
    }
    [self removeFromSuperview];
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
