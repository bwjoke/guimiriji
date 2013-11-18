//
//  WMIMInputView.m
//  WEIMI
//
//  Created by Tang Tianyong on 10/25/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMIMInputView.h"
#import "UIColor+HexString.h"
#import "WMIMRecordPlugin.h"
#import "NKProgressView.h"
#import "WMAudioLevelView.h"

static CGFloat __min_record_seconds = 1.0f;

@interface WMIMInputView () <WMIMRecordPluginDelegate, WMAudioLevelViewDelegate>

@property (nonatomic, retain) UIButton *audioToggleButton;
@property (readonly) WMIMRecordPlugin *audioButton;
@property (readonly) NKProgressView *HUD;
@property (readonly) WMAudioLevelView *levelView;

@end

@implementation WMIMInputView {
    UIButton *_audioToggleButton;
    WMIMRecordPlugin *_audioButton;
    NKProgressView *_HUD;
    CGRect _lastFrame;
    BOOL _isRecording;
    WMAudioLevelView *_levelView;
}

- (void)dealloc {
    [_HUD removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self.sendButton removeFromSuperview];
        [self setSendButton:nil];
        
        _isRecording = NO;
        
        self.nimingButton.hidden = YES;
        
        CGRect emojoFrame = self.emojoButton.frame;
        emojoFrame.origin.x = 245.0f;
        self.emojoButton.frame = self.jianpanButton.frame = emojoFrame;
        
        _audioToggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _audioToggleButton.frame = CGRectMake(8, 7, 27, 27);
        _audioToggleButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [_audioToggleButton setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
        [_audioToggleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_audioToggleButton setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.4] forState:UIControlStateNormal];
        [_audioToggleButton setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateDisabled];
        [_audioToggleButton setBackgroundImage:[UIImage imageNamed:@"record_toggle"] forState:UIControlStateNormal];
        [_audioToggleButton setBackgroundImage:[UIImage imageNamed:@"record_toggle"] forState:UIControlStateHighlighted];
        _audioToggleButton.titleLabel.shadowOffset = CGSizeMake (0.0, 1.0);
        _audioToggleButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        
        [_audioToggleButton addTarget:self action:@selector(toggleAudio) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_audioToggleButton];
        
        self.audioToggleButton = _audioToggleButton;
        
        [_audioToggleButton addTarget:self action:@selector(toggleAudio) forControlEvents:UIControlEventTouchUpInside];
        
        // Add button
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(287, 8, 27, 27);
        addButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [addButton setBackgroundImage:[UIImage imageNamed:@"send_picture"] forState:UIControlStateNormal];
        [addButton setBackgroundImage:[UIImage imageNamed:@"send_picture"] forState:UIControlStateHighlighted];
        [addButton setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [addButton setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.4] forState:UIControlStateNormal];
        [addButton setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateDisabled];
        addButton.titleLabel.shadowOffset = CGSizeMake (0.0, 1.0);
        addButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        
        [addButton addTarget:self action:@selector(addButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:addButton];
        
        CGRect emojiFrame = self.emojoButton.frame;
        emojiFrame.origin.x += 10.0f;
        self.emojoButton.frame = self.jianpanButton.frame = emojiFrame;
        
        CGFloat offsetX = -28.0f;
        
        // Use return key instead of send button
        
        self.textView.internalTextView.returnKeyType = UIReturnKeySend;
        
        // Change frame of input view
        
        CGRect inputFrame = self.textView.frame;
        inputFrame.origin.x += offsetX;
        inputFrame.origin.y = 7.0f;
        inputFrame.size.width = 210.0f;
        self.textView.frame = inputFrame;
        
        // Change frame of background
        
        CGRect entryFrame = self.entryImageView.frame;
        entryFrame.origin.x += offsetX;
        entryFrame.origin.y = 7.0f;
        entryFrame.size.width = 210.0f;
        self.entryImageView.frame = entryFrame;
        
        _lastFrame = self.frame;
        
        // Load the HUD
        [self HUD];
    }
    
    return self;
}

- (void)toggleAudio {
    if (_isRecording) {
        _isRecording = NO;
        
        CGRect frame = self.frame;
        frame.size = _lastFrame.size;
        self.frame = frame;
        
        [self.textView becomeFirstResponder];
        [self.entryImageView setHidden:NO];
        [self.textView setHidden:NO];
        
        [[self audioButton] setHidden:YES];
        
        [_audioToggleButton setBackgroundImage:[UIImage imageNamed:@"record_toggle"] forState:UIControlStateNormal];
        [_audioToggleButton setBackgroundImage:[UIImage imageNamed:@"record_toggle"] forState:UIControlStateHighlighted];
    } else {
        _isRecording = YES;
        
        CGRect lastFrame = _lastFrame = self.frame;
        lastFrame.size.height = 276.0f;
        self.frame = lastFrame;
        
        [self.textView resignFirstResponder];
        [self.entryImageView setHidden:YES];
        [self.textView setHidden:YES];
        
        [[self audioButton] setHidden:NO];
        
        [_audioToggleButton setBackgroundImage:[UIImage imageNamed:@"wm_keyboard_button_normal"] forState:UIControlStateNormal];
        [_audioToggleButton setBackgroundImage:[UIImage imageNamed:@"wm_keyboard_button_normal"] forState:UIControlStateHighlighted];
        
        [self hide];
    }
}

-(void)emojoButtonClick:(id)sender{
    [self.textView becomeFirstResponder];
    [self.entryImageView setHidden:NO];
    [self.textView setHidden:NO];
    
    [[self audioButton] setHidden:YES];
    
    _isRecording = NO;
    
    [_audioToggleButton setBackgroundImage:[UIImage imageNamed:@"record_toggle"] forState:UIControlStateNormal];
    [_audioToggleButton setBackgroundImage:[UIImage imageNamed:@"record_toggle"] forState:UIControlStateHighlighted];
    
    [super emojoButtonClick:sender];
}

- (void)addButtonDidClick {
    [_delegate showImageSheet];
    
}

#pragma mark - Lazy loading

- (WMIMRecordPlugin *)audioButton {
    if (_audioButton != nil) {
        return _audioButton;
    }
    
    _audioButton = [WMIMRecordPlugin buttonWithType:UIButtonTypeCustom];
    _audioButton.frame = CGRectMake(40, 7, 210, 26);
    [_audioButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [_audioButton setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    [_audioButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_audioButton setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.4] forState:UIControlStateNormal];
    [_audioButton setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateDisabled];
    _audioButton.titleLabel.shadowOffset = CGSizeMake (0.0, 1.0);
    _audioButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    
    _audioButton.delegate = self;
    
    [self addSubview:_audioButton];
    
    return _audioButton;
}

- (NKProgressView *)HUD {
    if (_HUD != nil) {
        return _HUD;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    _HUD = [[NKProgressView alloc] initWithView:window];
    [_HUD setMinSize:CGSizeMake(185.0f, 70.0f)];
    [window addSubview:_HUD];
    
    return _HUD;
}

- (WMAudioLevelView *)levelView {
    if (_levelView != nil) {
        return _levelView;
    }
    
    _levelView = [[WMAudioLevelView alloc] init];
    [_levelView setBarLength:216.0f];
    _levelView.delegate = self;
    _levelView.image = nil;
    
    return _levelView;
}

#pragma mark - WMIMRecordPluginDelegate

- (void)recordPluginTouchDidBegin:(WMIMRecordPlugin *)recordPlugin {
    [self HUD].mode = MBProgressHUDModeIndeterminate;
    [self HUD].labelText = @"手指上滑，取消发送";
    [self HUD].margin = 10.0f;
    [self HUD].customView = self.levelView;
    [self HUD].mode = MBProgressHUDModeCustomView;
    
    [self.levelView start];
    
    [[self HUD] show:NO];
}

- (void)recordPluginTouchDidChange:(WMIMRecordPlugin *)recordPlugin toOutOfScope:(BOOL)outOfScope {
    if (outOfScope) {
        [self HUD].labelText = @"松开手指，取消发送";
    } else {
        [self HUD].labelText = @"手指上滑，取消发送";
    }
}

- (void)recordPluginTouchDidComplete:(WMIMRecordPlugin *)recordPlugin seconds:(NSTimeInterval)seconds {
    [self.levelView stop];
    
    if (seconds >= __min_record_seconds) {
        [[self HUD] hide:NO];
        
        NSData *audio = self.audioButton.audio;
        NSNumber *during = @(self.audioButton.audioSeconds);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.recordSendAction withObject:audio withObject:during];
#pragma clang diagnostic pop
    } else {
        [self HUD].margin = 20.0f;
        [self HUD].mode = MBProgressHUDModeIndeterminate;
        [[self HUD] failedWithString:@"说话时间太短"];
    }
}

- (void)recordPluginTouchDidCancel:(WMIMRecordPlugin *)recordPlugin {
    [[self HUD] hide:NO];
}

- (void)recordPluginMeterDidUpdate:(WMIMRecordPlugin *)recordPlugin toPower:(CGFloat)power {
    self.levelView.db = (30.0f + power) / 40.0f;
}

#pragma mark - WMAudioLevelViewDelegate

- (void)audioLevelViewShouldStop:(WMAudioLevelView *)audioLevelView {
    [[self audioButton] stopRecord];
}

@end
