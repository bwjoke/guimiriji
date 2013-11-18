//
//  WMBindDetailViewController.m
//  WEIMI
//
//  Created by Tang Tianyong on 7/16/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMBindDetailViewController.h"
#import "TTTAttributedLabel.h"

@interface WMBindDetailViewController ()

- (NSMutableDictionary *)oauth;

@end

@implementation WMBindDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    
    [self addBackButton];
    
    if (self.oauth.count > 1) {
        [self addRightButtonWithTitle:@"解绑"];
    }
    
    [self.headBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] atIndex:0];
    [self addHeadShadow];
    
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    
    NSString *logo_icon = nil;
    
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10.0f, self.view.frame.size.height / 2.0f + 30.0f, 300.0f, 20.0f)];
    [self.view addSubview:label];
    label.textAlignment = UITextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithHexString:@"#A6937C"];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.backgroundColor = [UIColor clearColor];
    
    label.lineHeightMultiple = 1.2f;
    
    if ([self.type isEqualToString:@"weibo"]) {
        self.titleLabel.text = @"新浪微博";
        
        label.frame = CGRectMake(10.0f, self.view.frame.size.height / 2.0f + 50.0f, 300.0f, 40.0f);
        label.text = @"已绑定新浪微博，系统会为你推荐新浪微博\n\
上你或你朋友认识的男人点评;)";
        
        logo_icon = @"weibo_big_icon";
    } else if ([self.type isEqualToString:@"renren"]) {
        self.titleLabel.text = @"人人账号";
        
        label.frame = CGRectMake(10.0f, self.view.frame.size.height / 2.0f + 50.0f, 300.0f, 40.0f);
        label.text = @"已绑定人人账号，系统会为你推荐人人网\n\
上你或你朋友同学认识的男人点评;)";
        
        logo_icon = @"renren_big_icon";
    } else if ([self.type isEqualToString:@"qq"]) {
        self.titleLabel.text = @"QQ账号";
        
        label.frame = CGRectMake(10.0f, self.view.frame.size.height / 2.0f + 50.0f, 300.0f, 100.0f);
        label.text = @"已绑定QQ账号，可以使用QQ账号登录\n\
推荐绑定微博、人人网账号，系统会为你\n\
推荐微博、人人网上你或朋友同学认识的\n\
男纸点评; )";
        
        logo_icon = @"qq_big_icon";
    }
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:logo_icon]];
    
    [self.view addSubview:logo];
    
    CGSize size = self.view.frame.size;
    CGPoint center = CGPointMake(size.width / 2.0f, size.height / 2.0f);
    center.y -= 55.0f;
    
    logo.center = center;
}

- (void)rightButtonClick:(id)sender {
    NSString *msg = @"确定要解绑吗？";
    
    if ([self.type isEqualToString:@"weibo"]) {
        msg = @"确定要解绑微博账号吗？";
    } else if ([self.type isEqualToString:@"renren"]) {
        msg = @"确定要解绑人人账号吗？";
    } else if ([self.type isEqualToString:@"qq"]) {
        msg = @"确定要解绑QQ账号吗？";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self confirmToUnbind];
    }
}

- (void)confirmToUnbind {
    progressView = [NKProgressView progressViewForView:self.view];
    progressView.labelText = @"正在解绑";
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(unbindOK) andFailedSelector:@selector(unbindFailed:)];
    [[NKUserService sharedNKUserService] socialUnbindWithType:self.type andRequestDelegate:rd];
}

- (void)unbindOK {
    if ([self.delegate respondsToSelector:@selector(unbindDidSuccess:)]) {
        [self.delegate unbindDidSuccess:self.type];
    }
}

- (void)unbindFailed:(NKRequest *)request {
    ProgressErrorDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private
- (NSMutableDictionary *)oauth {
    return [[[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] currentAccount] oauth];
}

@end
