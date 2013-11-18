//
//  WMTopicNameViewController.m
//  WEIMI
//
//  Created by Tang Tianyong on 7/23/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTopicNameViewController.h"

@interface WMTopicNameViewController () {
    NSString *_topicnick;
}

@end

@implementation WMTopicNameViewController

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
    [self.headBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] atIndex:0];
    [self addHeadShadow];
    
    [self addBackButton];
    [self addRightButtonWithTitle:@"完成"];
    [self setShouldAutoRefreshData:NO];
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    
    self.titleLabel.text = @"话题讨论区昵称";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.textField = [[WMTextField alloc] initWithFrame:CGRectMake(15, 60, 290, 40)];
    [self.contentView addSubview:_textField];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.margin = 10.0f;
    
    NSString *topicName = [[WMMUser me] topicName];
    
    if (topicName) {
        _textField.text = topicName;
    }
    
    [_textField becomeFirstResponder];
}

-(void)rightButtonClick:(id)sender
{
    _topicnick = [[_textField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    
    if ([_topicnick length]==0) {
        return;
    }
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(setTopicNameOK:) andFailedSelector:@selector(setTopicNameFailed:)];
    
    ProgressLoading;
    
    [[WMUserService sharedWMUserService] setTopicnick:_topicnick andRequestDelegate:rd];
}

- (void)setTopicNameOK:(NKRequest *)request {
    ProgressHide;
    
    [self goBack:self];
    
    // Update the topicname
    [[WMMUser me] setTopicName:_topicnick];
    
    if ([self.delegate respondsToSelector:@selector(updateTopicnickSuccess)]) {
        [self.delegate updateTopicnickSuccess];
    }
}

- (void)setTopicNameFailed:(NKRequest *)request {
    ProgressErrorDefault;
    // TODO
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
