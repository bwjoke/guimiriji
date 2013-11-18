//
//  WMAddZDYDafenViewController.m
//  WEIMI
//
//  Created by King on 4/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMAddZDYDafenViewController.h"

@interface WMAddZDYDafenViewController ()

@end

@implementation WMAddZDYDafenViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    [self addBackButton];
    [self addRightButtonWithTitle:@"完成"];
    [self setShouldAutoRefreshData:NO];
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    
    self.titleLabel.text = @"自定义打分项";
    

    UIImageView *mazhi = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mazhi_back"]] autorelease];
    [self.contentView addSubview:mazhi];
    mazhi.frame = CGRectMake(0, 44, mazhi.frame.size.width, mazhi.frame.size.height);
    
    UIImageView *textBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wm_input_back"]] autorelease];
    [self.contentView addSubview:textBack];
    textBack.frame = CGRectMake((320-textBack.frame.size.width)/2, 60, textBack.frame.size.width, textBack.frame.size.height);
    
    
    self.textField = [[[NKTextViewWithPlaceholder alloc] initWithFrame:CGRectMake(15, textBack.frame.origin.y, 290, textBack.frame.size.height-1)] autorelease];
    [self.contentView addSubview:_textField];
    _textField.backgroundColor = [UIColor clearColor];
    [_textField becomeFirstResponder];
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _textField.placeholderLabel.text = @"给他哪方面打分？";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightButtonClick:(id)sender{
    
    
    if (![self.textField.text length]) {
    
        
        ProgressFailedWith(@"请输入打分名称");
        return;
    }
    
    if ([self.textField.text length]>6) {
        ProgressFailedWith(@"打分项名称过长");
        return;
    }
    
    
    if ([self.target respondsToSelector:self.finishAction]) {
        [self.target performSelector:self.finishAction withObject:self.textField.text];
    }

    [self goBack:nil];

}

@end
