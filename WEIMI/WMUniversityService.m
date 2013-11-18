//
//  WMUniversityService.m
//  WEIMI
//
//  Created by steve on 13-8-10.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMUniversityService.h"

@implementation WMUniversityService

$singleService(WMUniversityService, @"university");

static NSString *const WMAPIGetMyUniversityList = @"/home";
-(NKRequest*)getMyUniversityList:(NKRequestDelegate *)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?id=%@",[self serviceBaseURL], WMAPIGetMyUniversityList,[[WMMUser me] universityId]];
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMUniversityManList class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIGetUniversityManList = @"/get_man_list";
-(NKRequest *)getMyUniversityManList:(NSString *)universityId bid:(NSString *)bid offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate *)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetUniversityManList];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMMan class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (universityId) {
        [newRequest addPostValue:universityId forKey:@"id"];
    }
    
    if (bid) {
        [newRequest addPostValue:bid forKey:@"bid"];
    }
    
    if (offset) {
        [newRequest addPostValue:[NSNumber numberWithInt:offset] forKey:@"offset"];
    }
    
    if (size) {
        [newRequest addPostValue:[NSNumber numberWithInt:size] forKey:@"size"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
}

static NSString *const WMAPISearchUniversityManList = @"/search";
-(NKRequest *)searchSchoolMan:(NSString *)universityId keyword:(NSString *)keyword andRequestDelegate:(NKRequestDelegate *)rd {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPISearchUniversityManList];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMMan class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (universityId) {
        [newRequest addPostValue:universityId forKey:@"id"];
    }
    
    if (keyword) {
        [newRequest addPostValue:keyword forKey:@"query"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

@end
