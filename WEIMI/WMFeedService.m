//
//  WMFeedService.m
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMFeedService.h"

@implementation WMFeedService

-(void)dealloc{
    [super dealloc];
}

$singleService(WMFeedService, @"feed");


static NSString *const WMAPIGetFeedsOfUser = @"/user_list";
-(NKRequest*)getFeedsWithUID:(NSString*)uid offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetFeedsOfUser];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMFeed class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (uid) {
        [newRequest addPostValue:uid forKey:@"id"];
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

static NSString *const WMAPIGetFeedOfFeed = @"/detail";
-(NKRequest*)getFeedWithFID:(NSString*)fid andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetFeedOfFeed];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (fid) {
        [newRequest addPostValue:fid forKey:@"id"];
    }
        
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIGetFeedCommentOfFeed = @"/comments";
-(NKRequest*)getFeedCommentsWithFID:(NSString*)fid offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetFeedCommentOfFeed];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMComment class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (fid) {
        [newRequest addPostValue:fid forKey:@"id"];
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

static NSString *const WMAPIGetFeedsNear = @"/near";
-(NKRequest*)getFeedsNear:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetFeedsNear];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMFeed class] resultType:NKResultTypeResultSets andResultKey:@""];
    

    if (offset) {
        [newRequest addPostValue:[NSNumber numberWithInt:offset] forKey:@"offset"];
    }
    if (size) {
        [newRequest addPostValue:[NSNumber numberWithInt:size] forKey:@"size"];
    }
    if (![[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]){
        [newRequest addPostValue:@"1" forKey:@"review"];
    }
    [self addRequest:newRequest];
    
    return newRequest;
    
}

static NSString *const WMAPIGetFeedsNearWithType = @"/near_with_type";
-(NKRequest*)getFeedsNearWithType:(int)type distance:(int)distance offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetFeedsNearWithType];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMFeed class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (type) {
        [newRequest addPostValue:[NSNumber numberWithInt:type] forKey:@"type"];
    }
    
    if (distance) {
        [newRequest addPostValue:[NSNumber numberWithInt:distance] forKey:@"distance"];
    }else {
        [newRequest addPostValue:@"all" forKey:@"distance"];
    }
    
    if (offset) {
        [newRequest addPostValue:[NSNumber numberWithInt:offset] forKey:@"offset"];
    }
    if (size) {
        [newRequest addPostValue:[NSNumber numberWithInt:size] forKey:@"size"];
    }
    if (![[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]){
        [newRequest addPostValue:@"1" forKey:@"review"];
    }
    [self addRequest:newRequest];
    
    return newRequest;
}


static NSString *const WMAPIAddFeedComment = @"/comment/create";
-(NKRequest *)addFeedComment:(NSString *)fid touser:(NKMUser *)touser content:(NSString *)content anonymous:(int)anonymous andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIAddFeedComment];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMComment class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (fid) {
        [newRequest addPostValue:fid forKey:@"id"];
    }
    
    if (touser) {
        [newRequest addPostValue:touser.mid forKey:@"touserid"];
        //if ([touser.mid floatValue]< 0) {
        content = [NSString stringWithFormat:@"回复%@：%@",touser.name,content];
        //}
    }
    
    if (content) {
        [newRequest addPostValue:content forKey:@"content"];
    }
    
    [newRequest addPostValue:[NSNumber numberWithInt:anonymous] forKey:@"anonymous"];
    
    
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIAddMiyuWithMID = @"/create";
-(NKRequest*)addMiyuWithContent:(NSString*)content purview:(int)purview picture:(NSData*)picture audio:(NSData *)audio audio_seconds:(NSTimeInterval)audio_seconds andRequestDelegate:(NKRequestDelegate *)rd {
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIAddMiyuWithMID];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMActionResult class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (content) {
        [newRequest addPostValue:content forKey:@"content"];
    }
    
    [newRequest addPostValue:[NSNumber numberWithInt:purview] forKey:@"purview"];
    
    if (picture) {
        [newRequest addData:picture withFileName:@"fromIphone.jpg" andContentType:@"image/jpeg" forKey:@"attachment"];
    }
    
    if (audio != nil) {
        [newRequest addData:audio withFileName:@"fromIphone.amr" andContentType:@"audio/amr" forKey:@"audio"];
        [newRequest addPostValue:@(audio_seconds) forKey:@"audio_seconds"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
    
    
}


static NSString *const WMAPIDeleteMiyuWithMID = @"/delete";
-(NKRequest*)deleteFeedWithFID:(NSString*)fid andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIDeleteMiyuWithMID];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMActionResult class] resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (fid) {
        [newRequest addPostValue:fid forKey:@"id"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIDeleteCommentWithMID = @"/comment/delete";
-(NKRequest*)deleteFeedCommentWithFID:(NSString*)mid andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIDeleteCommentWithMID];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMActionResult class] resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"id"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIPraiseMiyuWithMID = @"/like";
-(NKRequest*)praiseFeedWithFID:(NSString*)fid andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIPraiseMiyuWithMID];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMFeed class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (fid) {
        [newRequest addPostValue:fid forKey:@"id"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIReportFeed = @"/report";
-(NKRequest*)reportFeedWithFID:(NSString*)fid andContent:(NSString *)content andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIReportFeed];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (fid) {
        [newRequest addPostValue:@"feed" forKey:@"type"];
        [newRequest addPostValue:fid forKey:@"id"];
        [newRequest addPostValue:content forKey:@"content"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

@end
