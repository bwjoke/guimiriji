//
//  WMGoodsService.m
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMGoodsService.h"

@implementation WMGoodsService

$singleService(WMGoodsService, @"goods");

static NSString *const WMAPIShareToTimelineSuccess = @"/share";
- (NKRequest *)sharedToTimelineSuccessWithRequestDelegate:(NKRequestDelegate *)rd {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIShareToTimelineSuccess];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMUser class] resultType:NKResultTypeOrigin andResultKey:@""];
    
    [self addRequest:newRequest];
    return newRequest;
}

static NSString *const WMAPIPaidSuccess = @"/paid";
- (NKRequest *)paidSuccessWithRequestDelegate:(NKRequestDelegate *)rd {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIPaidSuccess];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMUser class] resultType:NKResultTypeOrigin andResultKey:@""];
    
    [self addRequest:newRequest];
    return newRequest;
}

@end
