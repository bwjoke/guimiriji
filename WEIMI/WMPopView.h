//
//  WMPopView.h
//  WEIMI
//
//  Created by steve on 13-8-27.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

@class WMPopView;
@protocol WMPopViewDelegate <NSObject>

@optional
-(void)doneButtonClickWithPopView:(WMPopView *)popView;

@end

#import <UIKit/UIKit.h>

@interface WMPopView : UIView
{
    CGRect popFrame;
    UIView *mainView;
}
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,unsafe_unretained)id<WMPopViewDelegate>delegate;

-(id)initWithTitle:(NSString *)title numOfTextFiled:(int)numOfTextFiled;
-(void)showInView:(UIView *)view;
-(void)cancle:(id)sender;
@end
