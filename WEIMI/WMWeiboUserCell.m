//
//  WMWeiboUserCell.m
//  WEIMI
//
//  Created by steve on 13-5-27.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMWeiboUserCell.h"
#import "UIColor+HexString.h"
#import "WMWeiboUser.h"

@implementation WMWeiboUserCell {
    UILabel *_descLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(int)index
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
        self.bottomLine.image = nil;
        self.bottomLine.frame = CGRectMake(0, 55, 320, 1);
        [self addSubview:self.bottomLine];
        
        self.avatar = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(15, 10, 35, 35)] autorelease];
        self.avatar.layer.cornerRadius = 4.0f;
        [self.contentView addSubview:_avatar];
        _avatar.placeHolderImage = [UIImage imageNamed:@"default_portrait"];
        
        self.name = [[[UILabel alloc] initWithFrame:CGRectMake(60, 18, 180, 18)] autorelease];
        _name.backgroundColor = [UIColor clearColor];
        _name.font = [UIFont boldSystemFontOfSize:18];
        _name.textColor = [UIColor colorWithHexString:@"#AC9B86"];
        [self.contentView addSubview:_name];
        
        self.button = [[[UIButton alloc] initWithFrame:CGRectMake(256, 12, 50, 30)] autorelease];
        [_button setBackgroundImage:[UIImage imageNamed:@"man_invite"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(invte:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.button];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(245, 12, 80, 30)];
        [self.contentView addSubview:descLabel];
        descLabel.text = @"被邀请过";
        descLabel.textColor = [UIColor colorWithHexString:@"#AC9B86"];
        descLabel.font = [UIFont systemFontOfSize:16];
        _descLabel = descLabel;
    }
    return self;
}

-(void)showForObject:(id)object
{
    WMWeiboUser *user = object;
    self.button.tag = _index;
    [_avatar bindValueOfModel:user forKeyPath:@"avatar"];
    
    _button.hidden = NO;
    _descLabel.hidden = YES;
    
    if (user.hasInvited) {
        _button.hidden = YES;
        _descLabel.hidden = NO;
    } else if (user.localHasInvited) {
        [_button setBackgroundImage:[UIImage imageNamed:@"man_invite_selected"] forState:UIControlStateNormal];
    }else {
        [_button setBackgroundImage:[UIImage imageNamed:@"man_invite"] forState:UIControlStateNormal];
    }
    _name.text = user.name;
}

-(void)invte:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [_delegate inviteButtonClicked:btn.tag];
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
