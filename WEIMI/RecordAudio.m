//
//  RecordAudio.m
//  JuuJuu
//
//  Created by xiaoguang huang on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RecordAudio.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "amrFileCodec.h"

@implementation RecordAudio

- (void)dealloc {
    [recorder dealloc];
	recorder = nil;
	recordedTmpFile = nil;
    [avPlayer stop];
    [avPlayer release];
    avPlayer = nil;
    [super dealloc];
}

-(id)init {
    self = [super init];
    
    if (self) {
        //Instanciate an instance of the AVAudioSession object.
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        //Setup the audioSession for playback and record. 
        //We could just use record and then switch it to playback leter, but
        //since we are going to do both lets set it up once.
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
								 sizeof (audioRouteOverride),
								 &audioRouteOverride);
        
        //Activate the session
        [audioSession setActive:YES error: &error];
    }
    
    return self;
}

- (void) stopRecord {
    [recorder stop];
    [recorder release];
    recorder = nil;
}

+(NSTimeInterval) getAudioTime:(NSData *) data {
    NSError * error;
    AVAudioPlayer*play = [[AVAudioPlayer alloc] initWithData:data error:&error];
    NSTimeInterval n = [play duration];
    [play release];
    return n;
}

// 0: playing 1: finished 2: error

-(void)sendStatus:(int)status {
    
    if ([self.delegate respondsToSelector:@selector(RecordStatus:)]) {
        [self.delegate RecordStatus:status];
    }
    
    if (status != 0) {
        if (avPlayer!=nil) {
            [avPlayer stop];
            [avPlayer release];
            avPlayer = nil;
        }
    }
}

-(void) stopPlay {
    if (avPlayer!=nil) {
        [avPlayer stop];
        [avPlayer release];
        avPlayer = nil;
        [self sendStatus:1];
    }
}

-(NSData *)decodeAmr:(NSData *)data{
    if (!data) {
        return data;
    }

    return DecodeAMRToWAVE(data);
}

-(void) play:(NSData*) data{
	//Setup the AVAudioPlayer to play the file that we just recorded.
    
    if (avPlayer != nil) {
        [self stopPlay];
        return;
    }
    
    NSData* o = [self decodeAmr:data];
    
    avPlayer = [[AVAudioPlayer alloc] initWithData:o error:&error];
    avPlayer.delegate = self;
	[avPlayer prepareToPlay];
    [avPlayer setVolume:1.0];
    
	if(![avPlayer play]){
        [self sendStatus:1];
    } else {
        [self sendStatus:0];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self sendStatus:1];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [self sendStatus:2];
}

-(void) startRecord {
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                   [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                   nil];
    
    //Now that we have our settings we are going to instanciate an instance of our recorder instance.
    //Generate a temp file for use by the recording.
    //This sample was one I found online and seems to be a good choice for making a tmp file that
    //will not overwrite an existing one.
    //I know this is a mess of collapsed things into 1 call.  I can break it out if need be.
    
    NSURL *documentURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *audioURL = [documentURL URLByAppendingPathComponent:@"temp.caf"];
    
    if ([audioURL checkResourceIsReachableAndReturnError:NULL]) {
        [[NSFileManager defaultManager] removeItemAtURL:audioURL error:NULL];
    }
    
    //Setup the recorder to use this file and record to it.
    recorder = [[ AVAudioRecorder alloc] initWithURL:audioURL settings:recordSetting error:&error];
    
    recorder.meteringEnabled = YES;
    
    //Use the recorder to start the recording.
    //Im not sure why we set the delegate to self yet.  
    //Found this in antother example, but Im fuzzy on this still.
    
    [recorder setDelegate:self];
    
    //We call this to start the recording process and initialize 
    //the subsstems so that when we actually say "record" it starts right away.
    
    [recorder prepareToRecord];
    
    //Start the actual Recording
    
    [recorder record];
    
    //Miter the audio
    [self performSelectorInBackground:@selector(miterAudio) withObject:nil];
}

- (void)pauseRecord {
    [recorder pause];
}

- (NSURL *)audioURL {
    return recorder.url;
}

- (void)miterAudio {
    if (self.delegate && [self.delegate respondsToSelector:@selector(meterDidUpdate:)]) {
        while ([recorder isRecording]) {
            [recorder updateMeters];
            
            self.peakPower = [recorder peakPowerForChannel:0];
            
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(meterDidUpdate:) withObject:self waitUntilDone:NO];
            
            [NSThread sleepForTimeInterval:0.1];
        }
    }
}

@end
