//
//  WMMessage.h
//  WEIMI
//
//  Created by steve on 13-9-11.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMModel.h"
#import "WMMUser.h"

extern NSString *const ZUOMMessageSendStateSending;
extern NSString *const ZUOMMessageSendStateSuccess;
extern NSString *const ZUOMMessageSendStateFailed;

@interface WMMessage : WMModel
{
    NSString *messageId;
    NSData *content;
    
    WMMUser *sender;
    
    NSDate *createAt;
    
    NSString *sendState;
    NSString *type;
    NSString *contentText;
    
    NSString *switchState;
    UIImage *image;
    NSString *imageUrl;
    NSString *audioUrl;
    NSNumber *audioLength;
}

@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *sendState;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSData *content;
@property (nonatomic, strong) NSDate *createAt;
@property (nonatomic, strong) WMMUser *sender;
@property (nonatomic, strong) NSString *contentText;
@property (nonatomic, strong) NSString *switchState;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *audioUrl;
@property (nonatomic, retain) NSNumber *audioLength;
@end
