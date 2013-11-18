//
//  WMOauthCell.m
//  WEIMI
//
//  Created by steve on 13-9-24.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMOauthCell.h"
#import "UIColor+HexString.h"
#import "NKConfig.h"

@implementation WMOauthCell
{
    UILabel *titileLabel;
    UIImageView *iconView;
    UILabel *bindLabel;
    UIActivityIndicatorView *activityIndicator;
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
        bindLabel = [[UILabel alloc] initWithFrame:CGRectMake(195.0f, 5.0f, 80.0f, 30.0f)];
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
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        titileLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 13, 230, 15)];
        titileLabel.backgroundColor = [UIColor clearColor];
        titileLabel.font = [UIFont systemFontOfSize:14.0];
        titileLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
        [self addSubview:titileLabel];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(255, 13, 9, 15)];
        icon.image = [UIImage imageNamed:@"arrow"];
        self.accessoryView = icon;
        
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 10, 20, 20)];
        [self addSubview:iconView];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake(250, 15, 10, 10);
        [self addSubview:activityIndicator];
    }
    
    return self;
}

-(void)showIndex:(int)index shouldShowLoad:(BOOL)shouldShowLoad
{
    switch (index) {
        case 0: {
            NSString *iconName = nil;
            titileLabel.text = @"新浪微博";
            NSString *bindString = @"";
            iconName = @"weibo-normal-icon";
            self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_top_cell_normal"]] ;
            self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_top_cell_click"]];
            if (self.oauth[@"weibo"]) {
                //[activityIndicator stopAnimating];
                if ([self.oauth[@"weibo"] boolValue]) { // Expired
                    bindString = @"需更新授权";
                } else {
                    bindString = @"已绑定";
                }
                iconName = @"weibo-highlight-icon";
            }else {
                if (shouldShowLoad) {
                    [activityIndicator startAnimating];
                }else {
                    bindString = @"未绑定";
                }
            
            }
            iconView.image = [UIImage imageNamed:iconName];
            [self bindLabel].text = bindString;
            break;
        }
        case 1: {
            NSString *iconName = nil;
            titileLabel.text = @"人人账号";
            NSString *bindString = @"";
            iconName = @"renren-normal-icon";
            self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_mid_cell_normal"]];
            self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_mid_cell_click"]];
//            self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_bottom_cell_normal"]];
//            self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_bottom_cell_click"]];
            if (self.oauth[@"renren"]) {
                //[activityIndicator stopAnimating];
                if ([self.oauth[@"renren"] boolValue]) { // Expired
                    bindString = @"需更新授权";
                } else {
                    bindString = @"已绑定";
                }
                iconName = @"renren-highlight-icon";
            }else {
                if (shouldShowLoad) {
                    [activityIndicator startAnimating];
                }else {
                    bindString = @"未绑定";
                }
            }
            
            [self bindLabel].text = bindString;
            iconView.image = [UIImage imageNamed:iconName];
            break;
        }
        case 2: {
            NSString *iconName = nil;
            titileLabel.text = @"QQ账号";
            NSString *bindString = @"";
            iconName = @"qq-normal-icon";
            self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_bottom_cell_normal"]];
            self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_bottom_cell_click"]];
            if (self.oauth[@"qq"]) {
                //[activityIndicator stopAnimating];
                if ([self.oauth[@"qq"] boolValue]) { // Expired
                    bindString = @"需更新授权";
                } else {
                    bindString = @"已绑定";
                }
                iconName = @"qq-highlight-icon";
            }else {
                if (shouldShowLoad) {
                    [activityIndicator startAnimating];
                }else {
                    bindString = @"未绑定";
                }
            }
            
            [self bindLabel].text = bindString;
            iconView.image = [UIImage imageNamed:iconName];
            break;
        }
        default:
            break;
    }
}
- (NSMutableDictionary *)oauth {
    return [[[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] currentAccount] oauth];
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
