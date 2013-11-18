//
//  WMSettingCell.m
//  WEIMI
//
//  Created by steve on 13-4-8.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMSettingCell.h"
#import "UIColor+HexString.h"
#import "NKBadgeView.h"
#import "WMNotificationCenter.h"
#import "WMMTopic.h"
#import "NKSocial.h"
#import "NKConfig.h"
#import "WMAppDelegate.h"

@interface WMSettingCell ()

// 返回当前账号绑定的社交账号数组
- (NSMutableDictionary *)oauth;

#pragma mark - Lazy loading

- (UIActivityIndicatorView *)indicator;

@end

@implementation WMSettingCell
{
    UILabel *titileLabel,*countLabel;
    UIImageView *iconView,*topicBadge;
    UILabel *bindLabel;
    UIActivityIndicatorView *_indicator;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Lazy loading
- (UILabel *)bindLabel {
    if (bindLabel == nil) {
        bindLabel = [[[UILabel alloc] initWithFrame:CGRectMake(155.0f, 5.0f, 80.0f, 30.0f)] autorelease];
        bindLabel.font = [UIFont systemFontOfSize:12.0f];
        bindLabel.backgroundColor = [UIColor clearColor];
        bindLabel.textColor = [UIColor colorWithHexString:@"#d0c0a5"];
        bindLabel.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:bindLabel];
    }
    
    return bindLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        titileLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 13, 230, 15)] autorelease];
        titileLabel.backgroundColor = [UIColor clearColor];
        titileLabel.font = [UIFont systemFontOfSize:14.0];
        titileLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
        [self.contentView addSubview:titileLabel];
        
        countLabel = [[[UILabel alloc] initWithFrame:CGRectMake(100, 13, 152, 15)] autorelease];
        countLabel.textAlignment = NSTextAlignmentRight;
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.font = [UIFont systemFontOfSize:14.0];
        countLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
        [self.contentView addSubview:countLabel];
        
        UIImageView *icon = [[[UIImageView alloc] initWithFrame:CGRectMake(255, 13, 9, 15)] autorelease];
        icon.image = [UIImage imageNamed:@"arrow"];
        [self addSubview:icon];
        
        topicBadge = [[UIImageView alloc] initWithFrame:CGRectMake(48, 10, 14, 14)];
        topicBadge.image = [UIImage imageNamed:@"xiaohongdian"];
        topicBadge.hidden = YES;
        [self.contentView addSubview:topicBadge];
        [topicBadge release];
        
        
        
    }
    return self;
}

-(void)showIndexPath:(NSIndexPath *)indexPath dataSource:(NSArray *)dataSource hasNotification: (BOOL)hasNotification
{
    [iconView removeFromSuperview];
    iconView = nil;
    countLabel.text = nil;
    topicBadge.hidden = YES;
    CGRect frame = CGRectMake(20, 13, 230, 15);
    titileLabel.frame = frame;
    topicBadge.frame = CGRectMake(48, 10, 14, 14);
    if ([dataSource count]>0) {
        
    }else {
        switch (indexPath.section) {
            case -1:{
                titileLabel.text = @"夫妻相大测试";
                CGRect frame = titileLabel.frame;
                frame.origin.x = frame.origin.x + 58;
                titileLabel.frame = frame;
                if (!iconView) {
                    iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 54, 25)] autorelease];
                    iconView.image = [UIImage imageNamed:@"couple_icon"];
                    [self.contentView addSubview:iconView];
                }
                if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"showCoupleTest"] boolValue]) {
                    topicBadge.hidden = NO;
                    CGRect frame = topicBadge.frame;
                    frame.origin.x = 164;
                    frame.origin.y = 8;
                    topicBadge.frame = frame;
                }
                self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_normal"]] autorelease];
                self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_click"]] autorelease];
                break;
            }
            case 0:{
                switch (indexPath.row) {
                    case 0:
                        titileLabel.text = @"个人设置";
                        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_top_cell_normal"]] autorelease];
                        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_top_cell_click"]] autorelease];
                        break;
                    case 1:{
                        titileLabel.text = @"闺蜜";
                        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_bottom_cell_normal"]] autorelease];
                        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_bottom_cell_click"]] autorelease];
                        NKBadgeView *feedBadge = [[NKBadgeView alloc] initWithFrame:CGRectMake(47, 8, 14, 14)];
                        feedBadge.numberLabel.hidden = YES;
                        feedBadge.placeHolderImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                        feedBadge.highlightedImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                        [feedBadge bindValueOfModel:[WMNotificationCenter sharedNKNotificationCenter] forKeyPath:@"hasRequest"];
                        [self.contentView addSubview:feedBadge];
                        [feedBadge release];
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
            case 1:{
                NSString *iconName = nil;
                
                switch (indexPath.row) {
                    case 0: {
                        titileLabel.text = @"新浪微博";
                        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_top_cell_normal"]] autorelease];
                        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_top_cell_click"]] autorelease];
                        
                        if (!iconView) {
                            iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(18, 10, 20, 20)] autorelease];
                            [self addSubview:iconView];
                        }
                        
                        NSString *bindString = @"";
                        iconName = @"weibo-normal-icon";
                        
                        [[self indicator] stopAnimating];
                        
                        if (self.oauth[@"weibo"]) {
                            
                            if ([self.oauth[@"weibo"] boolValue]) { // Expired
                                bindString = @"需更新授权";
                            } else {
                                bindString = @"已绑定";
                            }
                            
                            iconName = @"weibo-highlight-icon";
                        } else {
                            if ([[self.oauth allKeys] count] > 0) {
                                bindString = @"未绑定";
                            } else {
                                [[self indicator] startAnimating];
                            }
                        }
                        
                        [self bindLabel].text = bindString;
                        
                        break;
                    }
                    case 1: {
                        titileLabel.text = @"人人账号";
                        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_mid_cell_normal"]] autorelease];
                        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_mid_cell_normal"]] autorelease];
                        
                        if (!iconView) {
                            iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(18, 10, 20, 20)] autorelease];
                            [self addSubview:iconView];
                        }
                        
                        NSString *bindString = @"";
                        iconName = @"renren-normal-icon";
                        
                        [[self indicator] stopAnimating];
                        
                        if (self.oauth[@"renren"]) {
                            
                            if ([self.oauth[@"renren"] boolValue]) { // Expired
                                bindString = @"需更新授权";
                            } else {
                                bindString = @"已绑定";
                            }
                            
                            iconName = @"renren-highlight-icon";
                        } else {
                            if ([[self.oauth allKeys] count] > 0) {
                                bindString = @"未绑定";
                            } else {
                                [[self indicator] startAnimating];
                            }
                        }
                        
                        [self bindLabel].text = bindString;
                        
                        break;
                    }
                    case 2: {
                        // TODO
                        titileLabel.text = @"QQ账号";
                        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_bottom_cell_normal"]] autorelease];
                        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_bottom_cell_click"]] autorelease];
                        
                        if (!iconView) {
                            iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(18, 10, 20, 20)] autorelease];
                            [self addSubview:iconView];
                        }
                        
                        NSString *bindString = @"";
                        iconName = @"qq-normal-icon";
                        
                        [[self indicator] stopAnimating];
                        
                        if (self.oauth[@"qq"]) {
                            
                            if ([self.oauth[@"qq"] boolValue]) { // Expired
                                bindString = @"需更新授权";
                            } else {
                                bindString = @"已绑定";
                            }
                            
                            iconName = @"qq-highlight-icon";
                        } else {
                            if ([[self.oauth allKeys] count] > 0) {
                                bindString = @"未绑定";
                            } else {
                                [[self indicator] startAnimating];
                            }
                        }
                        
                        [self bindLabel].text = bindString;
                        
                        break;
                    }
                    default:
                        break;
                }
                
                iconView.image = [UIImage imageNamed:iconName];
                
                CGRect frame = titileLabel.frame;
                frame.origin.x = frame.origin.x + 22;
                titileLabel.frame = frame;
                break;
            }
            case 2:{
                titileLabel.text = @"把薇蜜推荐给好友";
                CGRect frame = titileLabel.frame;
                frame.origin.x = frame.origin.x + 22;
                titileLabel.frame = frame;
                if (!iconView) {
                    iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 16, 18)] autorelease];
                    iconView.image = [UIImage imageNamed:@"setting_icon"];
                    [self addSubview:iconView];
                }
                self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_normal"]] autorelease];
                self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_click"]] autorelease];
                break;
            }
            case 3:{
                switch (indexPath.row) {
                    case 0:
                        titileLabel.text = @"关于薇蜜";
                        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_top_cell_normal"]] autorelease];
                        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_top_cell_click"]] autorelease];
                        break;
                    case 1:
                        titileLabel.text = @"检查新版本";//@"检查新版本";
                        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_mid_cell_normal"]] autorelease];
                        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_mid_cell_click"]] autorelease];
                        break;
                        break;
                    case 2:
                        titileLabel.text = @"给薇蜜评价";
                        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_mid_cell_normal"]] autorelease];
                        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_mid_cell_click"]] autorelease];
                        break;
                    case 3:
                        
                        if (![[[WMAppDelegate shareAppDelegate] totalBadge3] isHidden]) {
                            topicBadge.frame = CGRectMake(162, 8, 14, 14);
                            topicBadge.hidden = NO;
                        }
                        
                        titileLabel.text = @"建议/吐槽/要求新功能";
                        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_bottom_cell_normal"]] autorelease];
                        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_bottom_cell_click"]] autorelease];
                        break;
                    default:
                        break;
                }
                break;
            }
            case 4:{
                titileLabel.text = @"应用推荐";
                self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_normal"]] autorelease];
                self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_click"]] autorelease];
                break;
            }
                
            default:
                break;
        }
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (NSMutableDictionary *)oauth {
    return [[[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] currentAccount] oauth];
}

- (UIActivityIndicatorView *)indicator {
    if (_indicator) {
        return _indicator;
    }
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    indicator.center = CGPointMake(220, self.frame.size.height / 2.0f);
    
    [self.contentView addSubview:indicator];
    
    _indicator = indicator;
    
    return indicator;
}

@end



