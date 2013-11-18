// WMAudioLevelView.m
//
// Copyright (c) 2013 Tang Tianyong
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
// KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
// AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

#import "WMAudioLevelView.h"
#import "DDProgressView.h"
#import "UIColor+HexString.h"

#define PROGRESS_FLUENT_FACTOR 0.2

@implementation WMAudioLevelView {
    DDProgressView *_progressView;
    UILabel *_label;
    NSTimer *_timer;
    
    UIImageView *_level1;
    UIView *_mask1;
    UIImageView *_level2;
    UIView *_mask2;
}

- (void)dealloc {
    [_timer invalidate];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.frame = CGRectMake(0.0f, 0.0f, 277, 76.0f);
        self.image = [UIImage imageNamed:@"audio_popup"];
        
        // Progress bar
        
        _progressView = [[DDProgressView alloc] initWithFrame:CGRectMake(10.0f, 35.0f, 257.0f, 15.0f)];
        _progressView.outerColor = [UIColor clearColor];
        _progressView.innerColor = [UIColor colorWithHexString:@"0xffe0e1"];
        _progressView.emptyColor = [UIColor colorWithHexString:@"0xe5b4b6"];
        
        [self addSubview:_progressView];
        
        // UILabel
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 30.0f)];
        _label.center = CGPointMake(self.bounds.size.width / 2.0f, 24.0f);
        
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont boldSystemFontOfSize:16.0f];
        _label.textAlignment = UITextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        
        [self addSubview:_label];
        
        // Level view
        
        UIImage *bg = [UIImage imageNamed:@"voice_level"];
        
        _level1 = [[UIImageView alloc] initWithFrame:CGRectMake(35.0f, 20.0f, 71.0f, 8.0f)];
        _level1.image = bg;
        
        [self addSubview:_level1];
        
        _mask1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _level1.frame.size.width, 8.0f)];
        _mask1.backgroundColor = [UIColor colorWithHexString:@"0xd56f7a"];
        _mask1.alpha = 0.5f;
        
        [_level1 addSubview:_mask1];
        
        _level2 = [[UIImageView alloc] initWithFrame:CGRectMake(170.0f, 20.0f, 71.0f, 8.0f)];
        _level2.image = bg;
        
        [self addSubview:_level2];
        
        _mask2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _level1.frame.size.width, 8.0f)];
        _mask2.backgroundColor = [UIColor colorWithHexString:@"0xd56f7a"];
        _mask2.alpha = 0.5f;
        
        [_level2 addSubview:_mask2];
        
        self.during = 0;
    }
    
    return self;
}

- (void)updateProgress {
	CGFloat currentProgress = _progressView.progress;
    
    CGFloat during = self.during > 0 ? self.during : 60;
    
    currentProgress += PROGRESS_FLUENT_FACTOR * (1 / during);
    
    if (currentProgress <= 1.0f) {
        _label.text = [NSString stringWithFormat:@"%d''", (int)(currentProgress * during + 1)];
        _progressView.progress = currentProgress;
    } else {
        [_timer invalidate];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioLevelViewShouldStop:)]) {
            [self.delegate audioLevelViewShouldStop:self];
        }
    }
}

- (void)setBarLength:(CGFloat)length {
    CGRect bounds = _progressView.bounds;
    bounds.size.width = length;
    
    _progressView.bounds = bounds;
}

- (void)start {
    _progressView.progress = 0.0f;
    
    if (_timer != nil) {
        [_timer invalidate];
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f * PROGRESS_FLUENT_FACTOR target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)stop {
    if (_timer != nil) {
        [_timer invalidate];
    }
}

- (void)setDb:(CGFloat)db {
    if (db < 0.0f) {
        db = 0.0f;
    }
    
    if (db > 1.0f) {
        db = 1.0f;
    }
    
    _db = db;
    
    CGRect frame = _level1.frame;
    CGFloat dbsize = db * frame.size.width;
    CGFloat width = _level1.frame.size.width - dbsize;
    CGFloat height = frame.size.height;
    
    CGRect mask1Rect = CGRectMake(0.0f, 0.0f, width, height);
    CGRect mask2Rect = CGRectMake(dbsize, 0.0f, width, height);
    
    _mask1.frame = mask1Rect;
    _mask2.frame = mask2Rect;
}

@end
