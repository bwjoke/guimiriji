// WMAudioPitch.mm
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

#import "WMAudioPitch.h"
#import "SoundTouch.h"
#import "amrFileCodec.h"

@implementation WMAudioPitch {
    soundtouch::SoundTouch soundTouchEngine;
}

- (id)init {
    self = [super init];
    
    if (self) {
        int sampleRate = 44100;
        int channels = 2;
        soundTouchEngine.setSampleRate( sampleRate );
        soundTouchEngine.setChannels( channels );
        soundTouchEngine.setTempoChange( 0.0f );
        soundTouchEngine.setPitchSemiTones( 0.0f );
        soundTouchEngine.setRateChange( 0.0f );
        soundTouchEngine.setSetting( SETTING_USE_QUICKSEEK, TRUE );
        soundTouchEngine.setSetting( SETTING_USE_AA_FILTER, FALSE );
    }
    
    return self;
}

- (NSData *)changePitchTo:(NSUInteger)pitch PCM:(NSData *)pcm {
    char *bytes = (char *)[pcm bytes];
    int length = [pcm length];
    int index = 0;
    int nFrameCount = 0;
    
    index += SkipCaffHead(bytes);
    
    if (index >= length) {
        return nil;
    }
    
    bytes += index;
    
    // Convert {{{
    
    char *initByte = bytes;
    soundtouch::SAMPLETYPE simples[160];
    
    NSMutableData *result = [[NSMutableData alloc] init];
    
    // Write header to amr
    
//    [result appendBytes:AMR_MAGIC_NUMBER length:strlen(AMR_MAGIC_NUMBER)];
    
    NSMutableData *fpwave = [[NSMutableData alloc]init];
    
    while (1) {
        if ((bytes - initByte + 320) > length) {
            break;
        }
        
		int nRead = ReadPCMFrameData(simples, bytes, 1, 8);
        
        bytes += nRead;
        
        // Transformation
        
        soundTouchEngine.setTempoChange(-50.0);
        soundTouchEngine.putSamples(simples, nRead / 4);
        
        soundtouch::SAMPLETYPE dest[1024];
        
        UInt32 numSimples = soundTouchEngine.receiveSamples(dest, 160 );
        
        [fpwave appendBytes:dest length:numSimples];
        
        ++nFrameCount;
    }
    
    WriteWAVEHeader(result, nFrameCount);
    
    [result appendData:fpwave];
    
    // }}}
    
	return result;
}

@end
