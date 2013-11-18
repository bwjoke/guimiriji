//
//  WMDataService.h
//  WEIMI
//
//  Created by King on 2/26/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "NKServiceBase.h"
#import "NKUI.h"

#import "NKDataStore.h"
#import "WMUserService.h"
#import "WMFeedService.h"
#import "WMManService.h"
#import "WMSystemService.h"
#import "WMTopicService.h"




extern NSString *const WMCachePathMyFeeds;
extern NSString *const WMCachePathMenCategory;
extern NSString *const WMCachePathHotMen;
extern NSString *const WMCachePathDianpingMen;
extern NSString *const WMCachePathScores;
extern NSString *const WMCachePathNearByMen;

extern NSString *const WMCacheTopicList;
extern NSString *const WMCacheCards;

@interface WMDataService : NKServiceBase

@end
