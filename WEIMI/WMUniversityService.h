//
//  WMUniversityService.h
//  WEIMI
//
//  Created by steve on 13-8-10.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMServiceBase.h"
#import "WMUniversity.h"
#import "WMMenCell.h"

@interface WMUniversityService : WMServiceBase

dshared(WMUniversityService);

-(NKRequest *)getMyUniversityList:(NKRequestDelegate *)rd;
-(NKRequest *)getMyUniversityManList:(NSString *)universityId bid:(NSString *)bid offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate *)rd;
-(NKRequest *)searchSchoolMan:(NSString *)universityId keyword:(NSString *)keyword andRequestDelegate:(NKRequestDelegate *)rd;

@end
