//
//  WMPopView.m
//  WEIMI
//
//  Created by steve on 13-8-27.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMPopView.h"
#import "WMCustomLabel.h"
#import "UIColor+HexString.h"

@implementation WMPopView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}


- (id)initWithTitle:(NSString *)title numOfTextFiled:(int)numOfTextFiled
{
    self = [self initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
    if (self) {
        // Initialization code
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.6;
        [self addSubview:bgView];
        mainView =  [[UIView alloc] initWithFrame:CGRectMake(20, -300, 280, 130+30*numOfTextFiled)];
        mainView.backgroundColor = [UIColor colorWithHexString:@"#f5eee3"];
        mainView.layer.cornerRadius = 6.0f;
        mainView.layer.borderColor = [UIColor grayColor].CGColor;
        mainView.layer.borderWidth = 1.0f;
        [self addSubview:mainView];
        
        WMCustomLabel *titleLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(0, 15, 280, 18) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithHexString:@"a6937c"]];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = title;
        [mainView addSubview:titleLabel];
        
        self.contentView = [[UIView alloc] init];
        self.contentView.frame = CGRectMake(0, 50, self.frame.size.width, 30*numOfTextFiled);
        [mainView addSubview:self.contentView];
        
        UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleButton.frame = CGRectMake(15, 65+self.contentView.frame.size.height+10, 115, 40);
        [cancleButton setBackgroundImage:[UIImage imageNamed:@"cancleBtn"] forState:UIControlStateNormal];
        [cancleButton setBackgroundImage:[UIImage imageNamed:@"cancleBtnClicked"] forState:UIControlStateHighlighted];
        [cancleButton setTitleColor:[UIColor colorWithHexString:@"#a6937c"] forState:UIControlStateNormal];
        [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancleButton addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:cancleButton];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"doneBtn"] forState:UIControlStateNormal];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"doneBtnClicked"] forState:UIControlStateHighlighted];
        doneButton.frame = CGRectMake(150, 65+self.contentView.frame.size.height+10, 115, 40);
        [doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor colorWithHexString:@"#a6937c"] forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:doneButton];
    }
    return self;
}

-(void)done:(id)sender
{
    [_delegate doneButtonClickWithPopView:self];
}

-(void)cancle:(id)sender
{
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = mainView.frame;
        frame.origin.y = -300;
        mainView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)showInView:(UIView *)view
{
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = mainView.frame;
        frame.origin.y = 14;
        mainView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
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
