//
//  WMRegisterViewController.m
//  WEIMI
//
//  Created by steve on 13-4-24.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMRegisterViewController.h"
#import "WMRegitserInviteViewController.h"

@interface WMRegisterViewController ()
{
    NSString *lastEmail;
}
@end

@implementation WMRegisterViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_weimiID release];
    [_theAccount release];
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
    
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;

    UIButton *btn = [self addBackButton];
    //[btn setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    btn = [self addRightButtonWithTitle:@"下一步"];
     //[btn setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    self.titleLabel.text = @"注册帐号";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
    
    UIImageView *sepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 2)];
    sepLine.image = [UIImage imageNamed:@"register_sep"];
    [self.contentView addSubview:sepLine];
    [sepLine release];
    [WMAutocompleteTextField setDefaultAutocompleteDataSource:[WMAutocompleteManager sharedManager]];
    email = [[WMAutocompleteTextField alloc] initWithFrame:CGRectMake(15, 0, 210, 41)];
    email.placeholder = @"请输入邮箱地址";
    email.autocompleteType = WMAutocompleteTypeEmail;
    email.keyboardType = UIKeyboardTypeEmailAddress;
    [email setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    email.font = [UIFont systemFontOfSize:14];
    email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    email.textColor = [UIColor colorWithHexString:@"#bfb2a3"];
    email.delegate = self;
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 210, 41)];
    password.placeholder = @"请输入密码";
//    password.secureTextEntry = YES;
    [password setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    password.font = [UIFont systemFontOfSize:14];
    password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    password.textColor = [UIColor colorWithHexString:@"#bfb2a3"];
    
    for (int i=0; i<2; i++) {
        UIImageView *inputBg = [[UIImageView alloc] initWithFrame:CGRectMake(40, 75+i*77, 240, 41)];
        inputBg.image = [UIImage imageNamed:@"register_input"];
        inputBg.userInteractionEnabled = YES;
        [self.contentView addSubview:inputBg];
        [inputBg release];
        switch (i) {
            case 0:
                [inputBg addSubview:email];
                [email becomeFirstResponder];
                break;
            case 1:
                [inputBg addSubview:password];
                break;
            default:
                break;
        }
    }
    [email release];
    [password release];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, 320, 13)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.textAlignment = UITextAlignmentCenter;
    textLabel.text = @"邮箱是薇蜜帐号，请确保有效和填写正确";
    textLabel.textColor = [UIColor colorWithHexString:@"#9a8874"];
    [self.contentView addSubview:textLabel];
    [textLabel release];
     NSLog(@"weimiid:  %@",_theAccount.oauthId);
    lastEmail = [NSString stringWithFormat:@""];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(nameDidAutoCompleted:)
     name:TextDidAutoCompleted
     object:email];
}

- (void)nameDidAutoCompleted:(NSNotification *)noti {
    [password becomeFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [email resignFirstResponder];
    [password becomeFirstResponder];
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [email resignFirstResponder];
    [password resignFirstResponder];
}

-(void)goBack:(id)sender
{
    [[NKSocial social] removeSocial];
    [NKNC popViewControllerAnimated:YES];
}

-(void)rightButtonClick:(id)sender
{
    NSString *emailText = [[[email text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    NSString *passwordText = [[[password text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    
    if ([emailText length]==0 || [passwordText length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"邮箱或密码不能为空哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (![self isValidateEmail:emailText]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"邮箱格式不正确哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    _theAccount.loginEmail = emailText;
    _theAccount.password = passwordText;
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(loginOK:) andFailedSelector:@selector(loginFailed:)];
    [[NKUserService sharedNKUserService] socialRegisterWithType:NKAccountTypeRenren oauthID:_theAccount.oauthId token:_theAccount.accessToken account:emailText password:passwordText uname:_theAccount.name andRequestDelegate:rd];
    
    Progress(@"正在登录");
    

}

-(BOOL)isValidateEmail:(NSString *)vemail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:vemail];
}

-(void)loginOK:(NKRequest*)request
{
    WMMUser *user = [request.results lastObject];
    ProgressHide;
    WMRegitserInviteViewController *wmrvc = [[WMRegitserInviteViewController alloc] init];
    wmrvc.theAccount = _theAccount;
    wmrvc.uid = user.mid;
    [NKNC pushViewController:wmrvc animated:YES];
    [wmrvc release];
}

-(void)loginFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
