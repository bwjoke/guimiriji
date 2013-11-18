//
//  WMTagButton.m
//  WEIMI
//
//  Created by steve on 13-5-24.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTagButton.h"
#import "UIColor+HexString.h"

@implementation WMTagButton

+(CGFloat)widthOfButton:(NSString *)tag
{
    CGFloat totalWidth = 0.0f;
    totalWidth = [tag sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(290, 14) lineBreakMode:NSLineBreakByCharWrapping].width +20;
    
    return  totalWidth;
}

- (id)initWithFrame:(CGRect)frame tag:(NSString *)tag index:(int)index;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithHexString:@"#C7C7C7"]];
        [self setTitle:tag forState:UIControlStateNormal];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(10, 7, 10, 7)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.tag = index;
        self.userInteractionEnabled = YES;
        [self addTarget:self action:@selector(addTag:) forControlEvents:UIControlEventTouchUpInside];
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTag:)];
//        [self addGestureRecognizer:singleTap];
    }
    return self;
}

-(void)addTag:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [_delegate buttonTapAtIndex:button.tag];
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
