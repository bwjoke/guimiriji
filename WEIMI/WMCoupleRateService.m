//
//  WMCoupleRateService.m
//  WEIMI
//
//  Created by steve on 13-10-11.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMCoupleRateService.h"

@implementation WMCoupleRateService
$singleService(WMCoupleRateService, @"couple_rate");
static NSString *const WMAPICheck = @"/check";
-(NKRequest *)rateCouple:(NSData *)manAvatar women:(NSData *)womenAvatar andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPICheck];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (manAvatar) {
        [newRequest addData:manAvatar withFileName:@"manavatar.jpg" andContentType:@"image/jpeg" forKey:@"male_pic"];
    }
    
    if (womenAvatar) {
        [newRequest addData:womenAvatar withFileName:@"womenavatar.jpg" andContentType:@"image/jpeg" forKey:@"female_pic"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

@end
