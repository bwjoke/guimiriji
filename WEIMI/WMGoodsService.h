//
//  WMGoodsService.h
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "NKUserService.h"
#import "WMMUser.h"

@interface WMGoodsService : NKUserService

dshared(WMGoodsService);

-(NKRequest*)sharedToTimelineSuccessWithRequestDelegate:(NKRequestDelegate*)rd;
-(NKRequest*)paidSuccessWithRequestDelegate:(NKRequestDelegate*)rd;

@end
