//
//  NKInputView.h
//  WEIMI
//
//  Created by King on 11/21/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "NKEmojoView.h"
#import "EmojiKeyBoardView.h"


@interface NKInputView : UIView<HPGrowingTextViewDelegate, EmojiKeyboardViewDelegate, UIScrollViewDelegate>{
    
    UITableView *upTableView;
    NSArray     *otherView;
    
    NSMutableArray *dataSource;
    
    BOOL emojoing;
    
    HPGrowingTextView *textView;
    UIButton *sendButton;
    
    NKEmojoView *emojoView;
    
    id  target;
    SEL action;
    
    UIButton *keyboardButton;
    UIButton *emojoButton;
}


@property (nonatomic, assign) UITableView    *upTableView;
@property (nonatomic, assign) NSMutableArray *dataSource;

@property (nonatomic, retain) NSArray        *otherView;

@property (nonatomic, assign) BOOL emojoing;

@property (nonatomic, assign) NKEmojoView *emojoView;

@property (nonatomic, assign) id  target;
@property (nonatomic, assign) SEL action;

@property (nonatomic, assign) HPGrowingTextView *textView;

@property (nonatomic, assign) UIButton *emojoButton;
@property (nonatomic, assign) UIButton *jianpanButton;
@property (nonatomic, assign) UIButton *sendButton;
@property (nonatomic, unsafe_unretained) UIButton *deleteButton;

@property (nonatomic, assign) UIButton *nimingButton;
@property (nonatomic, assign) UIButton *gongkaiButton;


@property (nonatomic, assign) UIImageView *textViewBack;

@property (nonatomic, assign) UITextView *managedTextView;

@property (nonatomic, assign) UIScrollView *wrapperView;
@property (nonatomic, retain) UIImageView *entryImageView;

@property (nonatomic, assign) BOOL enableSendButton;


+(id)inputViewWithTableView:(UITableView*)tableView dataSource:(NSMutableArray*)data otherView:(NSArray*)views;

-(void)hide;

-(void)sendOK;

-(void)emojoButtonClick:(id)sender;

@end
