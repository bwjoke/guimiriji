//
//  WMHoneyListCell.m
//  WEIMI
//
//  Created by steve on 13-4-9.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "WMHoneyListCell.h"
#import "UIColor+HexString.h"

@implementation WMHoneyListCell

-(void)dealloc
{
    _avatar.target = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
          indexPath:(NSIndexPath *)indexPath
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        currentIndexPath = indexPath.row;
        
         self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"honey_cell_normal"]] autorelease];
        
        self.avatar = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(13, 12.5, 50, 50)] autorelease];
        _avatar.target = self;
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = 6.0f;
        [self.contentView addSubview:_avatar];
        _avatar.placeHolderImage = [UIImage imageNamed:@"default_portrait"];
        
        self.name = [[[UILabel alloc] initWithFrame:CGRectMake(79, 20, 130, 33)] autorelease];
        _name.font = [UIFont systemFontOfSize:15];
        _name.textColor = [UIColor colorWithHexString:@"#A6937C"];
        [self.contentView addSubview:_name];
        
        _request = [[[UILabel alloc] initWithFrame:CGRectMake(233, 32, 26, 14)] autorelease];
        _request.font = [UIFont systemFontOfSize:12.0];
        _request.textColor = [UIColor colorWithHexString:@"#a6937c"];
        _request.text = @"请求";
        [self.contentView addSubview:_request];
        
        _button = [[[UIButton alloc] initWithFrame:CGRectMake(213, 23, 63, 30)] autorelease];
        [_button setBackgroundImage:[UIImage imageNamed:@"btn_unfollow_normal"] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:@"btn_unfollow_click"] forState:UIControlStateHighlighted];
        [_button setTitle:@"解除" forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:12];
        [_button setTitleColor:[UIColor colorWithHexString:@"#a6937c"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(unfollow) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
    }
    return self;
}

-(void)showForObject:(id)object
{
    self.showedObject = object;
    
    WMMUser *user = object;
    
    _name.text = user.name;
    
    [_avatar bindValueOfModel:user forKeyPath:@"avatar"];
    
    _button.hidden = YES;
    _request.hidden = YES;
    
    if ([user.relation isEqualToString:NKRelationFollower] ) {
        
        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"honey_cell_click"]] autorelease];
        
        _request.hidden = NO;
        
        UIImageView *icon = [[[UIImageView alloc] initWithFrame:CGRectMake(266, 30, 9, 15)] autorelease];
        icon.image = [UIImage imageNamed:@"arrow"];
        [self.contentView addSubview:icon];
        
    }else {
        _button.hidden = NO;
    }
    
}

-(void)unfollow
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否确认解除闺蜜关系？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [_delegate unfollow:currentIndexPath];
    }
}

@end
