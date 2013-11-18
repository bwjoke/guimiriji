//
//  WMHoneyRequestViewController.m
//  WEIMI
//
//  Created by steve on 13-4-11.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMHoneyRequestViewController.h"
#import "WMHoneyView.h"
#import "WMNotificationCenter.h"

@interface WMHoneyRequestViewController ()
{
    int reduceHeight;
}
@end

@implementation WMHoneyRequestViewController


// review note:  WMMUser 是 @property(nonatomic,retain)WMMUser *user; retain的， 这边需要加个dealloc方法


-(void)dealloc{
    
    [_user release];
    _avatarView.target = self;
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (!_showHeaderBar) {
        [self layOutHeaderView];
        reduceHeight = 0;
    }else {
        reduceHeight = 60;
    }
    
    self.refreshHeaderView.hidden = YES;
    [self layOutMainView];
}

-(void)layOutHeaderView
{
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    self.titleLabel.text = @"闺蜜";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    
    [self addBackButton];
    
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    
}

-(void)layOutMainView
{
    
    // review note: 属性在初始化的时候建议使用 self.avatarView = 
    CGRect frame = self.contentView.frame;
    frame.origin.y = frame.origin.y - reduceHeight;
    self.contentView.frame = frame;
    
    _avatarView = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(115, 105, 91, 91)] autorelease];
    _avatarView.target = self;
    [self.contentView addSubview:_avatarView];
    _avatarView.placeHolderImage = [UIImage imageNamed:@"default_portrait"];
    [_avatarView bindValueOfModel:_user forKeyPath:@"avatar"];
    
    UIImageView *coverView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 82, 320, 120)] autorelease];
    coverView.image = [UIImage imageNamed:@"avatar_cover"];
    [self.contentView addSubview:coverView];
    
    for (int i=0; i<2; i++) {
        UILabel *nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 226+i*30, 300, 20)] autorelease];
        nameLabel.font = [UIFont boldSystemFontOfSize:18.0];
        nameLabel.textAlignment = UITextAlignmentCenter;
        nameLabel.text = i==0?_user.name:@"把妳加为她的闺蜜";
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor colorWithHexString:@"#7e6b5a"];
        [self.contentView addSubview:nameLabel];
        
        UIButton *btn = [[[UIButton alloc] initWithFrame:CGRectMake(65+i*111, 310, 81, 52)] autorelease];
        switch (i) {
            case 0: {
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_accept"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_accept_hi"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:@"接受" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
                [btn setTitleColor:[UIColor colorWithHexString:@"#7e6b5a"] forState:UIControlStateNormal];
                break;
            }
            case 1: {
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_ignore"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_ignore_hi"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(ignore:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:@"忽略" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:20];
                [btn setTitleColor:[UIColor colorWithHexString:@"#a6937c"] forState:UIControlStateNormal];
                break;
            }
            default:
                break;
        }
        
        [self.contentView addSubview:btn];
    }
    
    
    
}

-(void)accept:(id)sender
{
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(addFriendOK:) andFailedSelector:@selector(addFriendFailed:)];
     ProgressWith(@"正在接受好友请求");
    [[WMUserService sharedWMUserService] addFriend:_user.mid from:@"" andRequestDelegate:rd];
}

-(void)ignore:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要忽略好友请求吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(cancleFriendOK:) andFailedSelector:@selector(cancleFriendFailed:)];
        ProgressWith(@"正在忽略好友请求");
        [[WMUserService sharedWMUserService] cancleFriend:_user.mid andRequestDelegate:rd];
    }
}

-(void)addFriendOK:(NKRequest*)request
{
    ProgressSuccess(@"成功");
    if (!_showHeaderBar) {
        [self goBack:self];
    }
    [[WMHoneyView shareHoneyView:CGRectZero] relaodData:[WMMUser me]];
    //[[WMHoneyView shareHoneyView:CGRectZero] reloadUserPage];
    [_delegate didFollow];
    
    [[WMNotificationCenter sharedNKNotificationCenter] getNotificationsCountDelay];
    
}

-(void)addFriendFailed:(NKRequest*)request
{
    ProgressErrorDefault;
}

-(void)cancleFriendOK:(NKRequest*)request
{
    ProgressSuccess(@"成功");
    if (!_showHeaderBar) {
        [self goBack:self];
    }
    [[WMHoneyView shareHoneyView:CGRectZero] relaodData:[WMMUser me]];
    [_delegate didUnFollow];
    
    [[WMNotificationCenter sharedNKNotificationCenter] getNotificationsCountDelay];
    
}

-(void)cancleFriendFailed:(NKRequest*)request
{
    ProgressErrorDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
