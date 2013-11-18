//
//  WMAboutCell.m
//  WEIMI
//
//  Created by steve on 13-4-9.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMAboutCell.h"
#import "UIColor+HexString.h"

@implementation WMAboutCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        UILabel *titileLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 13, 230, 15)] autorelease];
        titileLabel.backgroundColor = [UIColor clearColor];
        titileLabel.font = [UIFont systemFontOfSize:14.0];
        titileLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
        [self addSubview:titileLabel];
        
        UIImageView *icon = [[[UIImageView alloc] initWithFrame:CGRectMake(270, 13, 9, 15)] autorelease];
        icon.image = [UIImage imageNamed:@"arrow"];
        [self addSubview:icon];
        
        switch (indexPath.row) {
            case 0:
                titileLabel.text = @"欢迎页";
                self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_top_cell_normal"]] autorelease];
                self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_top_cell_click"]] autorelease];
                break;
            case 1:
                titileLabel.text = [NSString stringWithFormat:@"检查新版本(当前%@)",[NSString stringWithFormat:@"v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];//@"检查新版本";
                self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_mid_cell_normal"]] autorelease];
                self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_mid_cell_click"]] autorelease];
                break;
            case 2:
                titileLabel.text = @"给薇蜜打分";
                self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_bottom_cell_normal"]] autorelease];
                self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_bottom_cell_click"]] autorelease];
                break;
            default:
                break;
        }
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
