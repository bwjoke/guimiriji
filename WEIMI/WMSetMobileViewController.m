//
//  WMSetMobileViewController.m
//  WEIMI
//
//  Created by steve on 13-4-27.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMSetMobileViewController.h"

@interface WMSetMobileViewController ()

@end

@implementation WMSetMobileViewController

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
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    [self addBackButton];
    [self addRightButtonWithTitle:@"完成"];
    [self setShouldAutoRefreshData:NO];
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    
    self.titleLabel.text = @"手机号";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.textField = [[[WMTextField alloc] initWithFrame:CGRectMake(15, 60, 290, 40)] autorelease];
    [self.contentView addSubview:_textField];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.margin = 10.0f;
    _textField.text = [[WMMUser me] mobile];
    _textField.keyboardType = UIKeyboardTypePhonePad;
    [_textField becomeFirstResponder];
}

-(void)rightButtonClick:(id)sender
{
    NSString *mobile = [[[_textField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    
    if ([mobile length]==0) {
        return;
    }
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(setMobileOK:) andFailedSelector:@selector(setMobileFailed:)];
    
    [[WMUserService sharedWMUserService] setUserMobile:mobile andRequestDelegate:rd];
}

-(void)setMobileOK:(NKRequest*)request
{
    // review note: ProgressErrorDefault 如果之前没有progressview， 会自己创建一个， ProgressSuccess 不会自动创建， 所以如果之前没有的， 这里更新成功是不会显示的。
    
    [self goBack:self];
}

-(void)setMobileFailed:(NKRequest*)request
{
    ProgressErrorDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
