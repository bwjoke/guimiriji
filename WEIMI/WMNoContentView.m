//
//  WMNoContentView.m
//  WEIMI
//
//  Created by steve on 13-4-27.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMNoContentView.h"
#import "UIColor+HexString.h"

@implementation WMNoContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *icon = [[[UIImageView alloc] initWithFrame:CGRectMake(135, 0, 50, 56)] autorelease];
        icon.image = [UIImage imageNamed:@"no_content_icon"];
        [self addSubview:icon];
        
        descLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 72, 320, 12)] autorelease];
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.textAlignment = UITextAlignmentCenter;
        descLabel.font = [UIFont systemFontOfSize:11];
        descLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
        [self addSubview:descLabel];
    }
    return self;
}

-(void)setText:(NSString *)text;
{
    descLabel.text = text;
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
