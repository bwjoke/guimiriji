//
//  UIPlaceHolderTextView.h
//  WEIMI
//
//  Created by steve on 13-5-15.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
{
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)initPlaceHolder;
-(void)textChanged:(NSNotification*)notification;
@end
