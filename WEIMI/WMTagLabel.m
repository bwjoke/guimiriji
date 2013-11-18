//
//  WMTagLabel.m
//  WEIMI
//
//  Created by steve on 13-5-21.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTagLabel.h"
#import "UIColor+HexString.h"

@implementation WMTagLabel

#define FONT_FOR_TYPE0 [UIFont systemFontOfSize:12]

+(CGFloat)widthOfLabel:(NSString *)tag type:(int)type
{
    CGFloat totalWidth = 0.0f;
    if (type == 0) {
        totalWidth = [tag sizeWithFont:FONT_FOR_TYPE0 constrainedToSize:CGSizeMake(300, 14) lineBreakMode:NSLineBreakByCharWrapping].width +8;
    }else {
        totalWidth = [tag sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(260, 14) lineBreakMode:NSLineBreakByCharWrapping].width +14;
    }
    
    return  totalWidth;
}

- (id)initWithFrame:(CGRect)frame tag:(NSString *)tag color:(UIImage *)image type:(int)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = color;
        self.image = image;
        if (type == 0) {
            //CGFloat width = [tag sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(300, 10) lineBreakMode:NSLineBreakByCharWrapping].width;
            _textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(4, 3, frame.size.width - 4, 14)] autorelease];
            _textLabel.font = FONT_FOR_TYPE0;
        }else {
            CGFloat width = [tag sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 14) lineBreakMode:NSLineBreakByCharWrapping].width;
            _textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(7, 8, width, 14)] autorelease];
            _textLabel.font = [UIFont systemFontOfSize:14];
        }
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.text = tag;
        [self addSubview:_textLabel];
    }
    return self;
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
