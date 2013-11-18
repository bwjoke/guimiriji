//
//  WMIMRecordPlugin.m
//  WEIMI
//
//  Created by Tang Tianyong on 10/28/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMIMRecordPlugin.h"
#import "WMAudioRecorder.h"
#import "UIImage+NKImage.h"

static CGFloat __threshold = 80.0f;

@interface WMIMRecordPlugin () <WMAudioRecorderDelegate>

@property (readonly) WMAudioRecorder *recorder;

@end

@implementation WMIMRecordPlugin {
    WMAudioRecorder *_recorder;
    NSData *_audio;
    BOOL _outOfScope;
    UIImage *_bg;
    UIImage *_hbg;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
        [self addGestureRecognizer:panGesture];
        
        UIImage *rawSendImage = [UIImage imageNamed:@"wm_send_normal"];
        UIEdgeInsets insets = UIEdgeInsetsMake(rawSendImage.size.height/2, 15, rawSendImage.size.height-rawSendImage.size.height/2-1, 15);
        
        _bg = [rawSendImage resizeImageWithCapInsets:insets];
        _hbg = [[UIImage imageNamed:@"wm_send_click"] resizeImageWithCapInsets:insets];
        
        [self setBackgroundImage:_bg forState:UIControlStateNormal];
        [self setBackgroundImage:_bg forState:UIControlStateHighlighted];
    }
    return self;
}

#pragma mark - Lazy loading

- (WMAudioRecorder *)recorder {
    if (_recorder != nil) {
        return _recorder;
    }
    
    _recorder = [[WMAudioRecorder alloc] init];
    
    _recorder.delegate = self;
    
    return _recorder;
}

- (void)panHandler:(UIPanGestureRecognizer *)panGesture {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat pointY = [panGesture locationInView:window].y;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            _outOfScope = NO;
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat height = [[UIScreen mainScreen] applicationFrame].size.height;
            
            if (height - pointY > __threshold) {
                _outOfScope = YES;
                [self touchDidChange];
            } else {
                _outOfScope = NO;
                [self touchDidChange];
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (!_outOfScope) {
                [self touchDidCompelte];
            } else {
                [self touchDidCancel];
            }
        }
            break;
            
        default: break;
    }
}

#pragma mark - WMAudioRecorderDelegate

- (void)meterDidUpdate:(CGFloat)peakPower {
    if ([self.delegate respondsToSelector:@selector(recordPluginMeterDidUpdate:toPower:)]) {
        [self.delegate recordPluginMeterDidUpdate:self toPower:peakPower];
    }
}

- (void)stopRecord {
    NSURL *audioURL = [self.recorder audioURL];
    
    [[self recorder] stop];
    
    if ([audioURL checkResourceIsReachableAndReturnError:NULL]) {
        _audio = [NSData dataWithContentsOfURL:audioURL];
    }
}

#pragma mark - Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchDidBegin];
    
    [self setBackgroundImage:_hbg forState:UIControlStateNormal];
    [self setBackgroundImage:_hbg forState:UIControlStateHighlighted];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // The event convert to pan gesture
    // TODO
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchDidCompelte];
    
    [self setBackgroundImage:_bg forState:UIControlStateNormal];
    [self setBackgroundImage:_bg forState:UIControlStateHighlighted];
}

- (void)touchDidBegin {
    if ([self.delegate respondsToSelector:@selector(recordPluginTouchDidBegin:)]) {
        [self.delegate recordPluginTouchDidBegin:self];
    }
    
    [self.recorder record];
}

- (void)touchDidChange {
    if ([self.delegate respondsToSelector:@selector(recordPluginTouchDidChange:toOutOfScope:)]) {
        [self.delegate recordPluginTouchDidChange:self toOutOfScope:_outOfScope];
    }
}

- (void)touchDidCompelte {
    [self stopRecord];
    
    if ([self.delegate respondsToSelector:@selector(recordPluginTouchDidComplete:seconds:)]) {
        [self.delegate recordPluginTouchDidComplete:self seconds:[self amrDataSeconds]];
    }
    
    [self setBackgroundImage:_bg forState:UIControlStateNormal];
    [self setBackgroundImage:_bg forState:UIControlStateHighlighted];
}

- (void)touchDidCancel {
    [self stopRecord];
    
    if ([self.delegate respondsToSelector:@selector(recordPluginTouchDidCancel:)]) {
        [self.delegate recordPluginTouchDidCancel:self];
    }
    
    [self setBackgroundImage:_bg forState:UIControlStateNormal];
    [self setBackgroundImage:_bg forState:UIControlStateHighlighted];
}

#pragma mark -

- (NSData *)amrData {
    if (_audio) {
        return EncodePCMToAMR((char *)_audio.bytes, _audio.length, 1, 16);
    }
    
    return nil;
}

- (NSTimeInterval)amrDataSeconds {
    if (_audio) {
        return (NSTimeInterval)[RecordAudio getAudioTime:_audio];
    }
    
    return 0;
}

@end
