// WMAudioRecorder.m
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

#import "WMAudioRecorder.h"

@implementation WMAudioRecorder {
    RecordAudio *_recorder;
    NSOperationQueue *_queue;
}

- (id)init {
    self = [super init];
    
    if (self) {
        _recorder = [[RecordAudio alloc] init];
        _recorder.delegate = self;
        
        _queue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (void)record {
    [_recorder startRecord];
}

- (void)pause {
    [_recorder pauseRecord];
}

- (void)stop {
    [_recorder stopRecord];
}

- (NSURL *)audioURL {
    return _recorder.audioURL;
}

- (NSData *)audioData {
    NSURL *url = _recorder.audioURL;
    
    if ([url checkResourceIsReachableAndReturnError:NULL]) {
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        // Convert to amr
        
        NSData *amrData = EncodePCMToAMR((char *)data.bytes, data.length, 1, 16);
        
        return amrData;
    }
    
    return nil;
}

#pragma mark - RecordAudioDelegate

- (void)RecordStatus:(int)status {
    // TODO
}

- (void)meterDidUpdate:(RecordAudio *)recorder {
    if (self.delegate && [self.delegate respondsToSelector:@selector(meterDidUpdate:)]) {
        [self.delegate meterDidUpdate:recorder.peakPower];
    }
}

@end
