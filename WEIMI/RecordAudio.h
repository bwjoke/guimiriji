//
//  RecordAudio.h
//  JuuJuu
//
//  Created by xiaoguang huang on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "amrFileCodec.h"

@class RecordAudio;

@protocol RecordAudioDelegate <NSObject>

// 0: playing 1: finished 2: error

-(void)RecordStatus:(int)status;
-(void)meterDidUpdate:(RecordAudio *)recorder;

@end

@interface RecordAudio : NSObject <AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    //Variables setup for access in the class:
	NSURL * recordedTmpFile;
	AVAudioRecorder * recorder;
	NSError * error;
    AVAudioPlayer * avPlayer;
}

@property (nonatomic,assign)id<RecordAudioDelegate> delegate;
@property (nonatomic,assign) CGFloat peakPower;

- (void)stopRecord;
- (void)startRecord;
- (void)pauseRecord;


-(void) play:(NSData*) data;
-(void) stopPlay;
+(NSTimeInterval) getAudioTime:(NSData *) data;

- (NSURL *)audioURL;
@end
