//
//  WMCoupleRateService.h
//  WEIMI
//
//  Created by steve on 13-10-11.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMServiceBase.h"

@interface WMCoupleRateService : WMServiceBase
dshared(WMCoupleRateService);
-(NKRequest *)rateCouple:(NSData *)manAvatar women:(NSData *)womenAvatar andRequestDelegate:(NKRequestDelegate*)rd;

@end
