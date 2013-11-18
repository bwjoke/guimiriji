//
//  WMPersonalCell.m
//  WEIMI
//
//  Created by steve on 13-4-8.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "WMPersonalCell.h"
#import "UIColor+HexString.h"
#import "WMMUser.h"
#import "NKKVOLabel.h"
#import "KKKeychain.h"
#import "KKPasscodeLock.h"

@implementation WMPersonalCell
{
    NKKVOImageView *avatar;
    NKKVOLabel *nameLabel;
    NKKVOLabel *_titileLabel;
    UIImageView *_icon;
    UISwitch *switchButton;
    UILabel *logout;
}

- (void)dealloc {
    [_titileLabel release];
    [_icon release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        _titileLabel = [[NKKVOLabel alloc] initWithFrame:CGRectMake(20, 13, 100, 15)];
        _titileLabel.backgroundColor = [UIColor clearColor];
        _titileLabel.font = [UIFont systemFontOfSize:14.0];
        _titileLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
        [self addSubview:_titileLabel];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(255, 13, 9, 15)];
        _icon.image = [UIImage imageNamed:@"arrow"];
        [self addSubview:_icon];
        
        switchButton = [[UISwitch alloc] init];
        switchButton.center = CGPointMake(230, 22);
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:switchButton];
    }
    return self;
}

- (void)refreshWithIndexPath:(NSIndexPath *)indexPath {
    _icon.hidden = NO;
    switchButton.hidden = YES;
    [avatar removeFromSuperview];
    avatar = nil;
    logout.hidden = YES;
    _titileLabel.hidden = YES;
    switch (indexPath.section) {
        case 0:{
            _titileLabel.hidden = NO;
            _titileLabel.text = @"头像";
            _titileLabel.frame = CGRectMake(20, 30, 30, 15);
            if (!avatar) {
                avatar = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(196, 13, 50, 50)] autorelease];
                [avatar bindValueOfModel:[WMMUser me] forKeyPath:@"avatar"];
                avatar.layer.masksToBounds = YES;
                avatar.layer.cornerRadius = 6.0f;
                [self addSubview:avatar];
            }
            
            _icon.frame = CGRectMake(255, 30, 9, 15);
            self.backgroundView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"set_cell_normal"] resizeImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]] autorelease];
            self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"set_cell_click"] resizeImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]] autorelease];
            break;
        }
        case 1:{
            _titileLabel.hidden = NO;
            _titileLabel.text = @"名字";
            self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_normal"]] autorelease];
            self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_click"]] autorelease];
            if (!nameLabel) {
                nameLabel = [[[NKKVOLabel alloc] initWithFrame:CGRectMake(105, 13, 140, 15)] autorelease];
                nameLabel.backgroundColor = [UIColor clearColor];
                nameLabel.textAlignment = UITextAlignmentRight;
                nameLabel.font = [UIFont systemFontOfSize:14.0];
                nameLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
                [nameLabel bindValueOfModel:[WMMUser me] forKeyPath:@"name"];
                [self addSubview:nameLabel];
            }
            
            break;
        }
        case 2:{
            _titileLabel.hidden = NO;
            _titileLabel.text = @"话题讨论区昵称";
            self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_normal"]] autorelease];
            self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_click"]] autorelease];
            
            NSString *topicName = [[WMMUser me] topicName];
            
            if (!nameLabel) {
                nameLabel = [[[NKKVOLabel alloc] initWithFrame:CGRectMake(105, 13, 140, 15)] autorelease];
                nameLabel.backgroundColor = [UIColor clearColor];
                nameLabel.textAlignment = UITextAlignmentRight;
                nameLabel.font = [UIFont systemFontOfSize:14.0];
                [nameLabel bindValueOfModel:[WMMUser me] forKeyPath:@"topicName"];
                [self addSubview:nameLabel];
            }
            
            if (topicName) {
                nameLabel.text = topicName;
                nameLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
            } else {
                nameLabel.text = @"未设定";
                nameLabel.textColor = [UIColor colorWithHexString:@"#d0c0a5"];
            }
            
            break;
        }
        case 3:{
            _titileLabel.hidden = NO;
            _titileLabel.text = @"手机号";
            self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_normal"]] autorelease];
            self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_click"]] autorelease];
            if (!nameLabel) {
                nameLabel = [[[NKKVOLabel alloc] initWithFrame:CGRectMake(105, 13, 140, 15)] autorelease];
                nameLabel.backgroundColor = [UIColor clearColor];
                nameLabel.textAlignment = UITextAlignmentRight;
                nameLabel.font = [UIFont systemFontOfSize:14.0];
                nameLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
                [nameLabel bindValueOfModel:[WMMUser me] forKeyPath:@"mobile"];
                [self addSubview:nameLabel];
            }
            
            break;
        }
        case 4: {
            _titileLabel.hidden = NO;
            _icon.hidden = YES;
            switchButton.hidden = NO;
            switchButton.tag = indexPath.section;
            _titileLabel.text = @"设置隐私密码";
            self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_normal"]] autorelease];
            self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_click"]] autorelease];
            if ([[KKKeychain getStringForKey:@"passcode_on"] isEqualToString:@"YES"]) {
                switchButton.on = YES;
            }else {
                switchButton.on = NO;
            }
            
            break;
        }
        case 5: {
            _titileLabel.hidden = NO;
            _icon.hidden = YES;
            switchButton.hidden = NO;
            switchButton.tag = indexPath.section;
            _titileLabel.text = @"夜间防骚扰模式";
            self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_normal"]] autorelease];
            self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_click"]] autorelease];
            if ([[[WMMUser me] notiSwitch] isEqualToString:@"on"]) {
                switchButton.on = YES;
            }else {
                switchButton.on = NO;
            }
            
            break;
        }
            
        case 6:{
            self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_normal"]] autorelease];
            self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_click"]] autorelease];
            _icon.hidden = YES;
            CGRect frame = self.frame;
            frame.origin.x -= 12;
            if (!logout) {
                logout = [[[UILabel alloc] initWithFrame:frame] autorelease];
                logout.backgroundColor = [UIColor clearColor];
                logout.textAlignment = UITextAlignmentCenter;
                logout.text = @"切换账号";
                logout.font = [UIFont systemFontOfSize:14.0];
                logout.textColor = [UIColor colorWithHexString:@"#A6937C"];
                [self addSubview:logout];
            }
            logout.hidden = NO;
            break;
        }
        default:
            break;
    }
}

-(void)switchAction:(id)sender
{
    UISwitch *switchBtn = sender;
    if (switchBtn.tag == 4) {
        [_delegate switchValueChange:sender];
    }else if (switchBtn.tag == 5) {
        [_delegate setNoNotification:sender];
    }
    
    
}



-(void)downLoadAvatarFinish
{
    avatar.image = [[WMMUser me] avatar];
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
