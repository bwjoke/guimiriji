// WMRecordPlugin.m
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

#import "WMRecordPlugin.h"
#import "WMAudioRecorder.h"
#import "WMAudioLevelView.h"
#import "UIImage+NKImage.h"

#import "WMAudioPitch.h"

enum tWMRecordPluginViewTag {
    kWMRecordPluginViewTagDeleteAudio = 1,
};

@interface WMRecordPlugin () <WMAudioRecorderDelegate, WMAudioLevelViewDelegate, AVAudioPlayerDelegate, UIAlertViewDelegate>

@end

@implementation WMRecordPlugin {
    WMAudioPitch *_audioPitch;
    WMAudioRecorder *_recorder;
    WMAudioLevelView *_audioLevelView;
    NSData *_audio;
    UIView *_previewView;
    UILabel *_secondsLabel;
    UILabel *_effectLabel;
    UIImageView *_playlist;
    AVAudioPlayer *_player;
    NSInteger _seconds;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self doInit];
    }
    
    return self;
}

- (void)doInit {
    _audioPitch = [[WMAudioPitch alloc] init];
    
    self.clipsToBounds = NO;
    
    [self setImage:[UIImage imageNamed:@"record_icon"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"record_icon"] forState:UIControlStateHighlighted];
    
    [self addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpOutside];
    
    // Audio preview button
    
    CGRect frame = self.bounds;
    
    _previewView = [[UIView alloc] initWithFrame:frame];
    
    // Initial, hide the preview
    _previewView.hidden = YES;
    
    _previewView.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
    
    [self addSubview:_previewView];
    
    UIButton *previewButton = [[UIButton alloc] initWithFrame:self.bounds];
    
    [previewButton setImage:[UIImage imageNamed:@"record_icon_done"] forState:UIControlStateNormal];
    [previewButton addTarget:self action:@selector(preview:) forControlEvents:UIControlEventTouchUpInside];
    
    [_previewView addSubview:previewButton];

    // Seconds label
    
    _secondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 30.0f)];
    
    _secondsLabel.center = CGPointMake(previewButton.bounds.size.width / 2.0f, 35.0f);
    _secondsLabel.backgroundColor = [UIColor clearColor];
    _secondsLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    _secondsLabel.textAlignment = UITextAlignmentCenter;
    _secondsLabel.textColor = [UIColor whiteColor];
    
    [previewButton addSubview:_secondsLabel];
    
    // Effect label
    
    _effectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 30.0f)];
    
    _effectLabel.center = CGPointMake(previewButton.bounds.size.width / 2.0f - 15, 68.0f);
    _effectLabel.backgroundColor = [UIColor clearColor];
    _effectLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _effectLabel.textAlignment = UITextAlignmentCenter;
    _effectLabel.textColor = [UIColor whiteColor];
    
    _effectLabel.text = @"原声";
    
    [previewButton addSubview:_effectLabel];
    
    UIImageView *downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice_down_arraw"]];
    downArrow.frame = CGRectMake(65, 65, 15, 10);
    
    [previewButton addSubview:downArrow];
    
    UIButton *audioDeleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_previewView addSubview:audioDeleteButton];
    
    [audioDeleteButton addTarget:self action:@selector(deleteAudio:) forControlEvents:UIControlEventTouchUpInside];
    [audioDeleteButton setImage:[UIImage imageNamed:@"baoliao_image_delete"] forState:UIControlStateNormal];
    
    audioDeleteButton.center = CGPointMake(90, 13);
}

- (void)startRecord:(id)sender {
    [self showAudioLevel];
    [[self recorder] record];
    [self setImage:[UIImage imageNamed:@"record_icon_down"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"record_icon_down"] forState:UIControlStateHighlighted];
}

- (void)stopRecord:(id)sender {
    NSURL *audioURL = [[self recorder] audioURL];
    
    [self hideAudioLevel];
    
    [[self recorder] stop];
    
    if ([audioURL checkResourceIsReachableAndReturnError:NULL]) {
        NSData *data = [NSData dataWithContentsOfURL:audioURL];
        
        // Convert to amr
        
        // NSData *amrData = EncodePCMToAMR((char *)data.bytes, data.length, 1, 16);
        
        _audio = data;
        
        NSInteger secend = (NSInteger)[RecordAudio getAudioTime:data];
        
        _secondsLabel.text = [NSString stringWithFormat:@"%d''", MIN(secend + 1, 60)];
    }
    
    [self updateUI];
}

- (void)stopRecord {
    [self stopRecord:nil];
}

- (void)showAudioLevel {
    [self audioLevelView].hidden = NO;
    [[self audioLevelView] start];
}

- (void)hideAudioLevel {
    [self audioLevelView].hidden = YES;
    [[self audioLevelView] stop];
}

- (void)updateUI {
    _previewView.hidden = !_audio;
    [self playlist].hidden = YES;
    
    [self setImage:[UIImage imageNamed:@"record_icon"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"record_icon"] forState:UIControlStateHighlighted];
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

- (WMAudioLevelView *)audioLevelView {
    if (_audioLevelView != nil) {
        return _audioLevelView;
    }
    
    WMAudioLevelView *audioLevelView = [[WMAudioLevelView alloc] init];
    
    audioLevelView.delegate = self;
    
    CGRect frame = audioLevelView.frame;
    frame.origin = CGPointMake(-87.0f, -60.0f);
    
    audioLevelView.frame = frame;
    
    [self addSubview:audioLevelView];
    
    _audioLevelView = audioLevelView;
    
    return _audioLevelView;
}

- (UIView *)playlist {
    if (_playlist != nil) {
        return _playlist;
    }
    
    _playlist = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 139.0f, 89.0f)];
    
    _playlist.userInteractionEnabled = YES;
    
    UIImage *image = [UIImage imageNamed:@"voice_preview"];
    
    image = [image resizeImageWithCapInsets:UIEdgeInsetsMake(20.0f, 20.0f, 10.0f, 10.0f)];
    
    _playlist.image = image;
    
    // Add the playButton
    
    UIButton *originAudioButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 70.0f, 65.0f)];
    
    originAudioButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [originAudioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [originAudioButton setTitle:@"原声" forState:UIControlStateNormal];
    
    [originAudioButton addTarget:self action:@selector(listenOrigin:) forControlEvents:UIControlEventTouchUpInside];
    
    [_playlist addSubview:originAudioButton];
    
    
    UIButton *filterButton = [[UIButton alloc] initWithFrame:CGRectMake(70.0f, 10.0f, 70.0f, 65.0f)];
    
    filterButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [filterButton setTitle:@"滤镜" forState:UIControlStateNormal];
    
    [filterButton addTarget:self action:@selector(filterButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_playlist addSubview:filterButton];
    
    // Place playlist
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordPlugin:placePlayList:)]) {
        [self.delegate recordPlugin:self placePlayList:_playlist];
    }
    
    return _playlist;
}

#pragma mark - WMAudioRecorderDelegate

- (void)meterDidUpdate:(CGFloat)peakPower {
    _audioLevelView.db = (30.0f + peakPower) / 40.0f;
}

#pragma mark - WMAudioLevelViewDelegate

- (void)audioLevelViewShouldStop:(WMAudioLevelView *)audioLevelView {
    [self stopRecord:nil];
}

#pragma mark - preview

- (void)preview:(id)sender {
    if (_player && [_player isPlaying]) {
        [self stopPlay];
    } else {
        [self playlist].hidden = ![self playlist].hidden;
    }
}

- (void)listenOrigin:(id)sender {
    [self startPlay];
    [self playlist].hidden = YES;
}

- (void)filterButtonDidClick:(id)sender {
    [[[UIAlertView alloc]
     initWithTitle:nil
     message:@"即将推出声音滤镜功能，敬请期待~"
     delegate:self cancelButtonTitle:@"确定"
     otherButtonTitles:nil, nil]
     show];
}

#pragma mark - Delete audio

- (void)deleteAudio:(id)sender {
     UIAlertView *alert = [[UIAlertView alloc]
                           initWithTitle:nil
                           message:@"是否确认删除录音？"
                           delegate:self
                           cancelButtonTitle:@"取消"
                           otherButtonTitles:@"确定", nil];
    alert.tag = kWMRecordPluginViewTagDeleteAudio;
    [alert show];
}

- (void)confirmDelete {
    if (_player && [_player isPlaying]) {
        [_player stop];
    }
    
    _audio = nil;
    
    [self updateUI];
}

#pragma mark - Play audio

- (void)startPlay {
    if (_player != nil) {
        // TODO
        [_player stop];
    }
    
    _seconds = 1;
    
//    NSData *pitchedData = [_audioPitch changePitchTo:0 PCM:_audio];
//    
//    NSLog(@"Pitched data: %@", pitchedData);
    
    NSError *error = NULL;
    
    _player = [[AVAudioPlayer alloc] initWithData:_audio error:&error];
    _player.delegate = self;
	[_player prepareToPlay];
    [_player setVolume:1.0];
    
	BOOL success = [_player play];
    
    if (!success) {
        NSLog(@"Play failed!");
    }
    
    [self performSelectorInBackground:@selector(increaseSeconds) withObject:nil];
}

- (void)stopPlay {
    [_player stop];
    
    NSInteger secend = (NSInteger)[RecordAudio getAudioTime:_audio];
    
    _secondsLabel.text = [NSString stringWithFormat:@"%d''", MIN(secend + 1, 60)];
}

- (void)increaseSeconds {
    while (_player && [_player isPlaying]) {
        
        UILabel *label = _secondsLabel;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            label.text = [NSString stringWithFormat:@"%d''", _seconds];
        });
        
        [NSThread sleepForTimeInterval:1.0f];
        
        ++_seconds;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kWMRecordPluginViewTagDeleteAudio) {
        if (buttonIndex == 1) {
            [self confirmDelete];
        }
    }
}

- (void)destroy {
    if (_player && [_player isPlaying]) {
        [_player stop];
    }
    
    _player = nil;
}

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
