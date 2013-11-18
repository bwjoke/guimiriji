// WMAudioPlayer.m
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

#import "WMAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "amrFileCodec.h"

@interface WMAudioPlayer ()

@end

@implementation WMAudioPlayer {
    AVAudioPlayer *_player;
    NSURL *_URL;
    NSData *_audioData;
    UILabel *_secondsLabel;
    int _length;
    int _seconds;
}

- (id)initWithURL:(NSURL *)URL length:(int)length {
    self = [super init];
    
    if (self) {
        _URL = URL;
        _length = length;
        
        self.frame = CGRectMake(0.0f, 0.0f, 100.0f, 25.0f);
        
        [self setImage:[UIImage imageNamed:@"play_record_audio"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"play_record_audio"] forState:UIControlStateHighlighted];
        
        [self addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
        
        // Seconds label
        
        _secondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        
        _secondsLabel.center = CGPointMake(self.bounds.size.width - 25.0f, self.bounds.size.height * 0.5);
        _secondsLabel.backgroundColor = [UIColor clearColor];
        _secondsLabel.font = [UIFont systemFontOfSize:14.0f];
        _secondsLabel.textAlignment = UITextAlignmentCenter;
        _secondsLabel.textColor = [UIColor whiteColor];
        
        _secondsLabel.text = [NSString stringWithFormat:@"%d''", length];
        
        [self addSubview:_secondsLabel];
        
        _seconds = 0;
    }
    
    return self;
}

- (void)play {
    if (_player) {
        [_player stop];
        _player.currentTime = 0.0f;
        
        if ([_player play]) {
            [self performSelectorInBackground:@selector(increaseSeconds) withObject:nil];
        }
        
    } else {
        if (_URL) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *amr = [NSData dataWithContentsOfURL:_URL];
                // Convert to wave
                NSData *wave = DecodeAMRToWAVE(amr);
                
                NSError *error;
                _player = [[AVAudioPlayer alloc] initWithData:wave error:&error];
                
                if (error == NULL) {
                    [_player prepareToPlay];
                    
                    if ([_player play]) {
                        [self performSelectorInBackground:@selector(increaseSeconds) withObject:nil];
                    }
                    
                }
            });
        }
    }
}

- (void)increaseSeconds {
    while (1) {
        
        if (_player && [_player isPlaying]) {
            UILabel *label = _secondsLabel;
            int length = _length;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                int seconds = MIN(length, _seconds);
                label.text = [NSString stringWithFormat:@"%d''", seconds];
            });
            
            [NSThread sleepForTimeInterval:1.0f];
            
            ++_seconds;
        } else {
            
            [self stop];
            
            break;
        }
        
    }
}

- (void)stop {
    [_player stop];
    _player.currentTime = 0.0f;
    _seconds = 0;
    _secondsLabel.text = [NSString stringWithFormat:@"%d''", _length];
    [self setImage:[UIImage imageNamed:@"play_record_audio"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"play_record_audio"] forState:UIControlStateHighlighted];
}

- (void)toggle:(id)sender {
    if (_player && [_player isPlaying]) {
        [self stop];
    } else {
        [self play];
        [self setImage:[UIImage imageNamed:@"stop_record_audio"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"stop_record_audio"] forState:UIControlStateHighlighted];
    }
}

- (void)destroy {
    if (_player && [_player isPlaying]) {
        [_player stop];
    }
    
    _player = nil;
}

@end
