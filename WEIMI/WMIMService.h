//
//  WMIMService.h
//  WEIMI
//
//  Created by steve on 13-9-10.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMServiceBase.h"
#import "WMMessage.h"

@interface WMIMService : WMServiceBase

dshared(WMIMService);

-(NKRequest*)getIMList:(NSString *)uid last_id:(NSString *)last_id size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;
-(NKRequest*)postIM:(NSString *)type user_id:(NSString *)uid content:(NSData *)content audio_seconds:(NSString *)audio_seconds switchState:(NSString *)switchState andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)checkForNewMessage:(NSString *)uid last_id:(NSString *)last_id andRequestDelegate:(NKRequestDelegate*)rd;
-(NKRequest*)deleteOneMessage:(WMMessage *)message andRequestDelegate:(NKRequestDelegate*)rd;
-(NKRequest*)deleteAllMessage:(WMMUser *)yourFriend andRequestDelegate:(NKRequestDelegate*)rd;
@end
