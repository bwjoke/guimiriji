//
//  NKInputView.m
//  WEIMI
//
//  Created by King on 11/21/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "NKInputView.h"
#import "UIColor+HexString.h"
#import "NKConfig.h"
#import "RegexKitLite.h"
#import "DDPageControl.h"

#define InputViewHeadHeight [[NKConfig sharedConfig] navigatorHeight]
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface NKInputView ()

@property (nonatomic, unsafe_unretained) DDPageControl *pageControl;
@property (nonatomic, unsafe_unretained) EmojiKeyBoardView *emojiKeyboardView;

@end

@implementation NKInputView

@synthesize upTableView;
@synthesize dataSource;

@synthesize otherView;

@synthesize emojoing;

@synthesize emojoView;

@synthesize target;
@synthesize action;

@synthesize textView;

@synthesize emojoButton;
@synthesize sendButton;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [otherView release];
    [super dealloc];
}


+(id)inputViewWithTableView:(UITableView*)tableView dataSource:(NSMutableArray*)data otherView:(NSArray*)views{
    
    
    NKInputView *inputView = [[self alloc] initWithFrame:CGRectMake(0, ScreenHeight-InputViewHeadHeight, [[UIScreen mainScreen] bounds].size.width, InputViewHeadHeight+216)];
    inputView.upTableView = tableView;
    inputView.otherView = views;
    inputView.dataSource = data;
    return [inputView autorelease];
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        
        NSDictionary *emojoPad = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[[NKConfig sharedConfig] emojoPad] ofType:@"plist"]];
        
        if ([[[NKConfig sharedConfig] emojoPad] isEqualToString:@"emojoPad"]) {
            
            UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 2.5, [[UIScreen mainScreen] bounds].size.width, 1)];
            topLine.backgroundColor = [UIColor whiteColor];
            topLine.alpha = 0.8;
            [self addSubview:topLine];
            [topLine release];
            
            self.emojoButton = [self addEmojoButtonWithTitle:[NSArray arrayWithObjects:[UIImage imageNamed:emojoPad[@"reply_emojo_normal"]], [UIImage imageNamed:emojoPad[@"reply_emojo_click"]], nil]];
            emojoButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            
            
            keyboardButton = [self styleButton];
            [keyboardButton addTarget:self action:@selector(showKeyboard) forControlEvents:UIControlEventTouchUpInside];
            [keyboardButton setImage:[UIImage imageNamed:emojoPad[@"reply_keyboard_normal"]] forState:UIControlStateNormal];
            [keyboardButton setImage:[UIImage imageNamed:emojoPad[@"reply_keyboard_click"]] forState:UIControlStateHighlighted];
            keyboardButton.adjustsImageWhenHighlighted = NO;
            keyboardButton.frame = emojoButton.frame;
            keyboardButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            keyboardButton.hidden = YES;
            
            
            
            // self.managedTextView.text = @"test\n\ntest";
            // textView.animateHeightChange = NO; //turns off animation
            
            UIImage *rawEntryBackground = [UIImage imageNamed:emojoPad[@"reply_input_back"]];
            UIImage *entryBackground = [rawEntryBackground resizeImageWithCapInsets:UIEdgeInsetsMake(rawEntryBackground.size.height/2, 30, rawEntryBackground.size.height-rawEntryBackground.size.height/2-1, 30)];
            UIImageView *entryImageView = [[[UIImageView alloc] initWithImage:entryBackground] autorelease];
            entryImageView.frame = CGRectMake(46, 10, 209, 34);
            entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
            
            textView = [[[HPGrowingTextView alloc] initWithFrame:CGRectMake(46, 9, 209, 20)] autorelease];
            textView.contentInset = UIEdgeInsetsMake(0, 3, 0, 5);
            
            textView.minNumberOfLines = 1;
            //textView.maxNumberOfLines = 4;
            textView.returnKeyType = UIReturnKeyDone; //just as an example
            textView.font = [UIFont systemFontOfSize:13.0f];
            textView.delegate = self;
            textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(3, 0, 3, 0);
            textView.internalTextView.backgroundColor = [UIColor clearColor];
            textView.internalTextView.returnKeyType = UIReturnKeyDone;
            textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
            // view hierachy
            [self addSubview:entryImageView];
            
            self.entryImageView = entryImageView;
            
            [self addSubview:textView];
            
            UIImage *rawSendImage = [UIImage imageNamed:emojoPad[@"reply_send_normal"]];
            
            UIImage *sendBtnBackground = [rawSendImage resizeImageWithCapInsets:UIEdgeInsetsMake(rawSendImage.size.height/2, 15, rawSendImage.size.height-rawSendImage.size.height/2-1, 15)];
            UIImage *selectedSendBtnBackground = [[UIImage imageNamed:emojoPad[@"reply_send_click"]] resizeImageWithCapInsets:UIEdgeInsetsMake(rawSendImage.size.height/2, 15, rawSendImage.size.height-rawSendImage.size.height/2-1, 15)];
            UIImage *disableSendBtnBackground = [[UIImage imageNamed:emojoPad[@"reply_send_disable"]] resizeImageWithCapInsets:UIEdgeInsetsMake(rawSendImage.size.height/2, 15, rawSendImage.size.height-rawSendImage.size.height/2-1, 15)];
            
            UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            doneBtn.frame = CGRectMake(260, 10, 52, 34);
            doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            [doneBtn setTitle:@"发送" forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateDisabled];
            [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
            [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateDisabled];
            doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
            doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            
            [doneBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
            [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
            [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateHighlighted];
            [doneBtn setBackgroundImage:disableSendBtnBackground forState:UIControlStateDisabled];
            [self addSubview:doneBtn];
            self.sendButton = doneBtn;
            doneBtn.enabled = NO;
            
            
            UIButton *deleteButton = [self styleButton];
            [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [deleteButton setImage:[UIImage imageNamed:emojoPad[@"delete_normal"]] forState:UIControlStateNormal];
            [deleteButton setImage:[UIImage imageNamed:emojoPad[@"delete_click"]] forState:UIControlStateHighlighted];
            deleteButton.frame = CGRectMake(258, 218, 60, 45);
            deleteButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            
            self.deleteButton = deleteButton;
            
            //CGRectMake(258, 218, 60, 45);
            
            UIButton *hideButton = [self styleButton];
            [hideButton addTarget:self action:@selector(hideButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [hideButton setImage:[UIImage imageNamed:emojoPad[@"reply_hide_normal"]] forState:UIControlStateNormal];
            [hideButton setImage:[UIImage imageNamed:emojoPad[@"reply_hide_click"]] forState:UIControlStateHighlighted];
            hideButton.frame = CGRectMake(2, 218, 60, 45);
            hideButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            

        }
        else{
            
            UIImageView *actionBar = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg-shit"] resizeImageWithCapInsets:UIEdgeInsetsMake(20, 10, 20, 10)]] autorelease];
            [self addSubview:actionBar];
            actionBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
            self.emojoButton = [self addEmojoButtonWithTitle:[NSArray arrayWithObjects:[UIImage imageNamed:emojoPad[@"reply_emojo_normal"]], [UIImage imageNamed:emojoPad[@"reply_emojo_click"]], nil]];
            emojoButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            emojoButton.frame = CGRectMake(35, 1, 30, 40);
            
            keyboardButton = [self styleButton];
            [keyboardButton addTarget:self action:@selector(showKeyboard) forControlEvents:UIControlEventTouchUpInside];
            [keyboardButton setImage:[UIImage imageNamed:emojoPad[@"reply_keyboard_normal"]] forState:UIControlStateNormal];
            [keyboardButton setImage:[UIImage imageNamed:emojoPad[@"reply_keyboard_click"]] forState:UIControlStateHighlighted];
            keyboardButton.adjustsImageWhenHighlighted = NO;
            keyboardButton.frame = emojoButton.frame;
            keyboardButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            keyboardButton.hidden = YES;
            self.jianpanButton = keyboardButton;
            
            self.nimingButton = [self styleButton];
            _nimingButton.frame = CGRectMake(4, 1, 30, 40);
            [_nimingButton setImage:[UIImage imageNamed:@"niming_normal"] forState:UIControlStateNormal];
            [_nimingButton setImage:[UIImage imageNamed:@"niming_click"] forState:UIControlStateHighlighted];
            _nimingButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            [_nimingButton addTarget:self action:@selector(gongkai:) forControlEvents:UIControlEventTouchUpInside];
            
            self.gongkaiButton = [self styleButton];
            [_nimingButton addSubview:_gongkaiButton];
            _gongkaiButton.frame = _nimingButton.bounds;
            [_gongkaiButton setImage:[UIImage imageNamed:@"buni_normal"] forState:UIControlStateNormal];
            [_gongkaiButton setImage:[UIImage imageNamed:@"buni_click"] forState:UIControlStateHighlighted];
            _gongkaiButton.hidden = YES;
            [_gongkaiButton addTarget:self action:@selector(gongkai:) forControlEvents:UIControlEventTouchUpInside];
            
            // self.managedTextView.text = @"test\n\ntest";
            // textView.animateHeightChange = NO; //turns off animation
            CGFloat startX = 68;
            
            
            UIImage *rawEntryBackground = [UIImage imageNamed:emojoPad[@"reply_input_back"]];
            UIImage *entryBackground = [rawEntryBackground resizeImageWithCapInsets:UIEdgeInsetsMake(rawEntryBackground.size.height/2, 30, rawEntryBackground.size.height-rawEntryBackground.size.height/2-1, 30)];
            UIImageView *entryImageView = [[[UIImageView alloc] initWithImage:entryBackground] autorelease];
            entryImageView.frame = CGRectMake(startX, 9, 255-startX, rawEntryBackground.size.height);
            entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            self.textViewBack = entryImageView;
            
            textView = [[[HPGrowingTextView alloc] initWithFrame:CGRectMake(startX, 9.5, 255-startX, 10)] autorelease];
            textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
            
            //textView.backgroundColor = [UIColor grayColor];
            
            textView.minNumberOfLines = 1;
            textView.returnKeyType = UIReturnKeyDefault; //just as an example
            
            textView.font = [UIFont systemFontOfSize:12.0f];
            textView.delegate = self;
            textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
            textView.internalTextView.backgroundColor = [UIColor clearColor];
            //textView.internalTextView.contentInset = UIEdgeInsetsMake(-5, 0, 0, 0);
            //textView.backgroundColor = [UIColor whiteColor];
            
            
            textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
            // view hierachy
            [self addSubview:entryImageView];
            
            self.entryImageView = entryImageView;
            
            [self addSubview:textView];
            
            textView.frame = CGRectMake(startX, 7, 255-startX, 31);
            
            UIImage *rawSendImage = [UIImage imageNamed:emojoPad[@"reply_send_normal"]];
            
            UIImage *sendBtnBackground = [rawSendImage resizeImageWithCapInsets:UIEdgeInsetsMake(rawSendImage.size.height/2, 15, rawSendImage.size.height-rawSendImage.size.height/2-1, 15)];
            UIImage *selectedSendBtnBackground = [[UIImage imageNamed:emojoPad[@"reply_send_click"]] resizeImageWithCapInsets:UIEdgeInsetsMake(rawSendImage.size.height/2, 15, rawSendImage.size.height-rawSendImage.size.height/2-1, 15)];
            UIImage *disableSendBtnBackground = [[UIImage imageNamed:emojoPad[@"reply_send_disable"]] resizeImageWithCapInsets:UIEdgeInsetsMake(rawSendImage.size.height/2, 15, rawSendImage.size.height-rawSendImage.size.height/2-1, 15)];
            
            UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            doneBtn.frame = CGRectMake(260, 9, 52, rawSendImage.size.height);
            doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            [doneBtn setTitle:@"发送" forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
            [doneBtn setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.4] forState:UIControlStateNormal];
            [doneBtn setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateDisabled];
            doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, 1.0);
            doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            
            [doneBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
            [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
            [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateHighlighted];
            [doneBtn setBackgroundImage:disableSendBtnBackground forState:UIControlStateDisabled];
            [self addSubview:doneBtn];
            self.sendButton = doneBtn;
            doneBtn.enabled = NO;
            
            
            UIButton *deleteButton = [self styleButton];
            [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [deleteButton setImage:[UIImage imageNamed:emojoPad[@"delete_normal"]] forState:UIControlStateNormal];
            [deleteButton setImage:[UIImage imageNamed:emojoPad[@"delete_click"]] forState:UIControlStateHighlighted];
            deleteButton.frame = CGRectMake(255, 209, 60, 45);
            deleteButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            
            self.deleteButton = deleteButton;
            
            //CGRectMake(258, 218, 60, 45);
            
            UIButton *hideButton = [self styleButton];
            [hideButton addTarget:self action:@selector(hideButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [hideButton setImage:[UIImage imageNamed:emojoPad[@"reply_hide_normal"]] forState:UIControlStateNormal];
            [hideButton setImage:[UIImage imageNamed:emojoPad[@"reply_hide_click"]] forState:UIControlStateHighlighted];
            hideButton.frame = CGRectMake(5, 209, 60, 45);
            hideButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            
            
        }
        
        
        self.managedTextView = textView.internalTextView;
        
                
        
    }
    return self;
}


-(void)gongkai:(id)sender{
    
    _gongkaiButton.hidden = !_gongkaiButton.hidden;
}

-(void)deleteButtonClick:(id)sender{
    NSString *theText = self.managedTextView.text;
    
    if ([theText length]) {

        if ([[theText substringFromIndex:[theText length]-1] isEqualToString:@")"]) {
            NSRange kuohaoRange = [theText rangeOfString:@"(" options:NSBackwardsSearch];
            if (kuohaoRange.length && [theText length] - kuohaoRange.location<=5) {
                theText = [theText substringToIndex:kuohaoRange.location];
            }
            else{
                theText = [theText substringToIndex:[theText length]-1];
            }
        }
        else{
            
            if (theText.length > 1) {
                NSString *last2Char = [theText substringFromIndex:theText.length - 2];
                if ([self stringContainsEmoji:last2Char]) {
                    theText = [theText substringToIndex:[theText length]-2];
                } else {
                    theText = [theText substringToIndex:[theText length]-1];
                }
            } else {
                theText = [theText substringToIndex:[theText length]-1];
            }
            
        }
        
    }
    
    id view = (self.managedTextView == textView.internalTextView) ? textView : self.managedTextView;
    [view setText:theText];
    
}


-(void)showKeyboard{
    
    [self.managedTextView becomeFirstResponder];
    
}

-(void)hideButtonClick{
    [self hide];
}

-(void)sendMessage{
    
    if ([target respondsToSelector:action]) {
        [target performSelector:action withObject:self.managedTextView.text];
    }
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)note{
    
    
    if (![self.managedTextView isFirstResponder]) {
        return;
    }
    
    emojoing = NO;
    emojoButton.hidden = emojoing;
    keyboardButton.hidden = !emojoing;
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect frame = self.frame;
    frame.origin.y = ScreenHeight - (keyboardBounds.size.height + self.frame.size.height-216);
    
    CGRect upFrame = upTableView.frame;
    upFrame.size.height = frame.origin.y - upFrame.origin.y;
    
    
    
    [UIView animateWithDuration:[duration doubleValue] delay:0 options:UIViewAnimationOptionBeginFromCurrentState|[curve intValue] animations:^{
        
        for (UIView *other in self.otherView) {
            if (other.frame.size.height!=upTableView.frame.size.height) {
                other.frame = CGRectMake(0, upFrame.origin.y+upFrame.size.height-other.bounds.size.height, other.frame.size.width, other.frame.size.height);
            }
            else{
                CGRect otherFrame = other.frame;
                otherFrame.size.height = upFrame.size.height;
                other.frame = otherFrame;
            }
        }
        
        self.frame = frame;
        upTableView.frame = upFrame;
        if ([dataSource count]) {
            [upTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[dataSource count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)keyboardWillHide:(NSNotification *)note{
    
    if (emojoing) {
        emojoing = NO;
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.y = ScreenHeight-(self.frame.size.height-216);
    CGRect upFrame = upTableView.frame;
    upFrame.size.height = frame.origin.y-upFrame.origin.y;;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|0 animations:^{
        
        for (UIView *other in self.otherView) {
            if (other.frame.size.height!=upTableView.frame.size.height) {
                other.frame = CGRectMake(0, upFrame.origin.y+upFrame.size.height-other.bounds.size.height, other.frame.size.width, other.frame.size.height);
            }
            else{
                CGRect otherFrame = other.frame;
                otherFrame.size.height = upFrame.size.height;
                other.frame = otherFrame;
                
            }
        }
        
        self.frame = frame;
        upTableView.frame = upFrame;
        
        
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.frame = r;
    
    CGRect upFrame = upTableView.frame;
    upFrame.size.height = r.origin.y-upFrame.origin.y;
    for (UIView *other in self.otherView) {
        if (other.frame.size.height!=upTableView.frame.size.height) {
            other.frame = CGRectMake(0, upFrame.origin.y+upFrame.size.height-other.bounds.size.height, other.frame.size.width, other.frame.size.height);
        }
        else{
            CGRect otherFrame = other.frame;
            otherFrame.size.height = upFrame.size.height;
            other.frame = otherFrame;
            
        }
    }
    
    upTableView.frame = upFrame;
    if ([dataSource count]) {
        [upTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[dataSource count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    self.wrapperView.frame = CGRectMake(10, emojoButton.frame.origin.y+48, emojoView.frame.size.width, emojoView.frame.size.height);
    
    if (self.enableSendButton) {
        self.pageControl.center = CGPointMake(130.0f, emojoButton.frame.origin.y+231);
    } else {
        self.pageControl.center = CGPointMake(160.0f, emojoButton.frame.origin.y+231);
    }
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    sendButton.enabled = [growingTextView hasText];
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView {
    [self sendMessage];
    return NO;
}

-(void)hide{
    
    emojoing = NO;
    keyboardButton.hidden = !emojoing;
    emojoButton.hidden = emojoing;
    [textView setDefaultPlaceHolder:@""];
    if ([self.managedTextView isFirstResponder]) {
        
        [self.managedTextView resignFirstResponder];
    }
    else{
        
        [self keyboardWillHide:nil];
    }
    
}

-(void)sendOK{
    [textView setDefaultPlaceHolder:@""];
    
    id view = (self.managedTextView == textView.internalTextView) ? textView : self.managedTextView;
    
    if ([[view text] length] > 0) {
        [view setText:@""];
    }
}

#pragma mark Emojo

-(UIButton*)styleButton{
    
    NSDictionary *emojoPad = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[[NKConfig sharedConfig] emojoPad] ofType:@"plist"]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normal = [[UIImage imageNamed:emojoPad[@"style_button_normal"]] resizeImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    UIImage *highlight = [[UIImage imageNamed:emojoPad[@"style_button_click"]] resizeImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    button.frame = CGRectMake(0, 0, normal.size.width, normal.size.height);
    [button setBackgroundImage:normal forState:UIControlStateNormal];
    [button setBackgroundImage:highlight forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [button setTitleColor:[UIColor colorWithHexString:@"#4287C6"] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:button];
    [button setImageEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
    return button;
    
}

-(UIButton*)addEmojoButtonWithTitle:(id)title{
    
    UIButton *button = [self styleButton];
    [button addTarget:self action:@selector(emojoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([title isKindOfClass:[NSString class]]) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    else if ([title isKindOfClass:[NSArray class]]){
        [button setImage:[title objectAtIndex:0] forState:UIControlStateNormal];
        [button setImage:[title objectAtIndex:1] forState:UIControlStateHighlighted];
    }
    
    button.frame = CGRectMake(2, 4, 45, 45);
    return button;
    
}

-(void)emojoButtonClick:(id)sender{
    
    emojoing = YES;
    keyboardButton.hidden = !emojoing;
    emojoButton.hidden = emojoing;
    
    if (!self.emojoView) {
        UIView *view = (self.managedTextView == textView.internalTextView) ? textView : self.managedTextView;
        
        self.emojoView = [NKEmojoView emojoViewWithReciever:view];
        emojoView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        CGRect frame = self.emojoView.bounds;
        emojoView.frame = emojoView.bounds;
        
        
        // wrapperView
        UIScrollView *wrapperView = [[[UIScrollView alloc] initWithFrame:CGRectMake(10, 49, frame.size.width, frame.size.height)] autorelease];
        [self addSubview:wrapperView];
        
        wrapperView.delegate = self;
        wrapperView.bounces = NO;
        
        // emojiKeyboardView
        EmojiKeyBoardView *emojiKeyboardView = [[[EmojiKeyBoardView alloc] initWithFrame:CGRectMake(frame.size.width, 9.0f, frame.size.width, 148)]autorelease];
        emojiKeyboardView.delegate = self;
        
        self.emojiKeyboardView = emojiKeyboardView;
        
        self.pageControl = [[[DDPageControl alloc] initWithType:DDPageControlTypeOnFullOffFull] autorelease];
        self.pageControl.onColor = [UIColor darkGrayColor];
        self.pageControl.offColor = [UIColor lightGrayColor];
        self.pageControl.indicatorDiameter = 5.0f;
        self.pageControl.indicatorSpace = 9.0f;
        self.pageControl.hidesForSinglePage = YES;
        self.pageControl.currentPage = 0;
        
        if (self.enableSendButton) {
            self.pageControl.center = CGPointMake(130.0f, 232.0f);
        } else {
            self.pageControl.center = CGPointMake(160.0f, 232.0f);
        }
        
        [self.pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.pageControl.numberOfPages = 8 + 1;
        
        [self insertSubview:self.pageControl atIndex:0];
        
        
        [wrapperView addSubview:emojoView];
        [wrapperView addSubview:emojiKeyboardView];
        
        
        wrapperView.contentSize = CGSizeMake(frame.size.width * 2, frame.size.height);
        wrapperView.pagingEnabled = YES;
        wrapperView.showsHorizontalScrollIndicator = NO;
        wrapperView.showsVerticalScrollIndicator = NO;
        
        self.wrapperView = wrapperView;
    }
    
    
    CGRect frame = self.frame;
    frame.origin.y = ScreenHeight - self.frame.size.height;
    
    CGRect upFrame = upTableView.frame;
    upFrame.size.height = frame.origin.y - upFrame.origin.y;
    
    
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|0 animations:^{
        
        for (UIView *other in self.otherView) {
            if (other.frame.size.height!=upTableView.frame.size.height) {
                other.frame = CGRectMake(0, upFrame.origin.y+upFrame.size.height-other.bounds.size.height, other.frame.size.width, other.frame.size.height);
            }
            else{
                CGRect otherFrame = other.frame;
                otherFrame.size.height = upFrame.size.height;
                other.frame = otherFrame;
            }
        }
        
        self.frame = frame;
        upTableView.frame = upFrame;
        if ([dataSource count]) {
            [upTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[dataSource count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self.managedTextView resignFirstResponder];
}


#pragma mark - EmojiKeyboardViewDelegate

- (void)emojiKeyBoardView:(EmojiKeyBoardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji {
    
    [self.managedTextView insertText:emoji];
    
    if (self.managedTextView == textView.internalTextView) {
        // Trigger a text did change event
        [textView setText:textView.text];
    }
    
    self.managedTextView.text = [self.managedTextView.text stringByAppendingString:@""];
}

- (void)emojiKeyBoardViewDidPressBackSpace:(EmojiKeyBoardView *)emojiKeyBoardView {
    // TODO
}

- (void)pageDidChanged:(NSInteger)pageNumber {
    self.pageControl.currentPage = pageNumber + 1;
}

- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x > 300) {
        return;
    }
    
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSInteger newPageNumber = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.pageControl.currentPage == newPageNumber) {
        return;
    }
    self.pageControl.currentPage = newPageNumber;
}

#pragma mark - DDPageControlDelegate

- (void)pageControlValueChanged:(DDPageControl *)sender {
    CGRect bounds = self.wrapperView.bounds;
    
    if (sender.currentPage > 0) {
        bounds.origin.x = CGRectGetWidth(bounds);
        bounds.origin.y = 0;
        [self.wrapperView scrollRectToVisible:bounds animated:YES];
        
        bounds.origin.x = CGRectGetWidth(bounds) * (sender.currentPage - 1);
        
        [self.emojiKeyboardView.scrollView scrollRectToVisible:bounds animated:YES];
        
    } else {
        bounds.origin.x = 0;
        bounds.origin.y = 0;
        [self.wrapperView scrollRectToVisible:bounds animated:YES];
    }
}

#pragma mark - Enable delete button

- (void)setEnableSendButton:(BOOL)enableSendButton {
    _enableSendButton = enableSendButton;
    
    if (enableSendButton) {
        CGRect frame = self.deleteButton.frame;
        frame.origin.x -= 60.0f;
        self.deleteButton.frame = frame;
        
        UIButton *thesendButton = [self styleButton];
        [thesendButton setImage:[UIImage imageNamed:@"send_button_normal"] forState:UIControlStateNormal];
        [thesendButton setImage:[UIImage imageNamed:@"send_button_highlight"] forState:UIControlStateHighlighted];
        thesendButton.frame = CGRectMake(255, 209, 60, 45);
        thesendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        [thesendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
