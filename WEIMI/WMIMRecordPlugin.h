//
//  WMIMRecordPlugin.h
//  WEIMI
//
//  Created by Tang Tianyong on 10/28/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMRecordPlugin.h"

@class WMIMRecordPlugin;

@protocol WMIMRecordPluginDelegate <NSObject>

@optional

- (void)recordPluginTouchDidBegin:(WMIMRecordPlugin *)recordPlugin;
- (void)recordPluginTouchDidChange:(WMIMRecordPlugin *)recordPlugin toOutOfScope:(BOOL)outOfScope;
- (void)recordPluginTouchDidComplete:(WMIMRecordPlugin *)recordPlugin seconds:(NSTimeInterval)seconds;
- (void)recordPluginTouchDidCancel:(WMIMRecordPlugin *)recordPlugin;
- (void)recordPluginMeterDidUpdate:(WMIMRecordPlugin *)recordPlugin toPower:(CGFloat)power;


@end

@interface WMIMRecordPlugin : UIButton

@property (nonatomic, unsafe_unretained) id<WMIMRecordPluginDelegate> delegate;

@property (nonatomic, readonly, getter = amrData) NSData *audio;
@property (nonatomic, readonly, getter = amrDataSeconds) NSTimeInterval audioSeconds;

- (void)stopRecord;

@end
