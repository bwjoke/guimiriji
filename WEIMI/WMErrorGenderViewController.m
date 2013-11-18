//
//  WMErrorGenderViewController.m
//  WEIMI
//
//  Created by steve on 13-4-28.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMErrorGenderViewController.h"

@interface WMErrorGenderViewController ()
{
    UITextField *email;
}
@end

@implementation WMErrorGenderViewController

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
    [self addleftButtonWithTitle:@"取消"];
    [self addRightButtonWithTitle:@"提交"];
    self.titleLabel.text = @"注册帐号";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
    
    UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appBackground.png"]] autorelease];
    [self.contentView insertSubview:bgView atIndex:0];
    
    UIImageView *sepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 2)];
    sepLine.image = [UIImage imageNamed:@"register_sep"];
    [self.contentView addSubview:sepLine];
    [sepLine release];
    
    for (int i=0; i<4; i++) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75+i*21, 320, 14)];
        textLabel.font = [UIFont systemFontOfSize:13];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor colorWithHexString:@"#9A8975"];
        [self.contentView addSubview:textLabel];
        [textLabel release];
        switch (i) {
            case 0:
                textLabel.text = @"抱歉，薇蜜暂时只能由女生使用";
                break;
            case 1:
                textLabel.text = @"如果你对我们很感兴趣，欢迎留下电子邮箱,";
                break;
            case 2:
                textLabel.text = @"我们会在对男生开放相关功能时通知你,";
                break;
            case 3:
                textLabel.text = @"或访问薇蜜网站：www.weimi.com";
                break;
            default:
                break;
        }
    }
    
    UIImageView *inputBg = [[[UIImageView alloc] initWithFrame:CGRectMake(41, 171, 240, 41)] autorelease];
    inputBg.userInteractionEnabled = YES;
    inputBg.image = [UIImage imageNamed:@"register_input"];
    [self.contentView addSubview:inputBg];
    
    email = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 230, 41)];
    email.placeholder = @"请输入邮箱地址";
    [email setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    email.font = [UIFont systemFontOfSize:14];
    email.textColor = [UIColor colorWithHexString:@"bfb2a3"];
    [inputBg addSubview:email];
    [email release];
    
    UIImageView *iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(135, 310, 50, 57)] autorelease];
    iconView.image = [UIImage imageNamed:@"error_icon"];
    [self.contentView addSubview:iconView];
    
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [email resignFirstResponder];
}

-(void)leftButtonClick:(id)sender
{
    [[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] logOut];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)rightButtonClick:(id)sender
{
    NSString *emailText = [[[email text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    
    if ([emailText length]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"邮箱不能为空哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(senderOK:) andFailedSelector:@selector(senderFailed:)];
    [[NKUserService sharedNKUserService] socialEmail:emailText andRequestDelegate:rd];
}

-(void)senderOK:(NKRequest *)request
{
    [[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] logOut];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)senderFailed:(NKRequest *)request
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
