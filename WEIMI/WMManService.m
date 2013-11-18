//
//  WMManService.m
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMManService.h"
#import "JSONKit.h"

@implementation WMManService

-(void)dealloc{
    [super dealloc];
}

$singleService(WMManService, @"man");

static NSString *const WMAPIGetMenCategory = @"/index";
-(NKRequest*)getMenCategoryWithRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetMenCategory];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMMenCategory class] resultType:NKResultTypeArray andResultKey:@""];
    
    [self addRequest:newRequest];
    return newRequest;
}

static NSString *const WMAPIGetMenWithCategory = @"/category";
-(NKRequest*)getMenWithCategory:(NSString*)cate offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetMenWithCategory];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMMan class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (cate) {
        [newRequest addPostValue:cate forKey:@"category"];
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

static NSString *const WMAPIGetMenFriendsAllFollowed = @"/friends_all_followed";
-(NKRequest*)getMenFriendsAllFollowed:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetMenFriendsAllFollowed];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMMan class] resultType:NKResultTypeResultSets andResultKey:@""];

    
    if (offset) {
        [newRequest addPostValue:[NSNumber numberWithInt:offset] forKey:@"offset"];
    }
    
    if (size) {
        [newRequest addPostValue:[NSNumber numberWithInt:size] forKey:@"size"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
    
    
}


static NSString *const WMAPIGetManDetail = @"/detail";
-(NKRequest*)getManDetailWithMID:(NSString*)mid andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetManDetail];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMMan class] resultType:NKResultTypeSingleObject andResultKey:@""];
    if (mid) {
        [newRequest addPostValue:mid forKey:@"id"];
    }
    
    [self addRequest:newRequest];
    return newRequest;

}

static NSString *const WMAPIGetManFeed = @"/feeds";
-(NKRequest*)getManFeedWithMID:(NSString*)mid type:(NSString *)type offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetManFeed];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMFeed class] resultType:NKResultTypeResultSets andResultKey:@""];
    if (mid) {
        [newRequest addPostValue:mid forKey:@"id"];
    }
    if (type) {
        [newRequest addPostValue:type forKey:@"type"];
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


static NSString *const WMAPIGetManUsers = @"/users";
-(NKRequest*)getManUsersWithMID:(NSString*)mid offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetManUsers];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMManUser class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"id"];
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





static NSString *const WMAPIFollowMan = @"/follow";
-(NKRequest*)followManWithMID:(NSString*)mid andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIFollowMan];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMMan class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"man_id"];
    }
    
    [self addRequest:newRequest];
    return newRequest;

    
}
static NSString *const WMAPIUNFollowMan = @"/unfollow";
-(NKRequest*)unfollowManWithMID:(NSString*)mid andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIUNFollowMan];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMMan class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"man_id"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
    
}

static NSString *const WMAPIFollowedMen = @"/followed";
-(NKRequest*)getFollowedMenWithUID:(NSString*)uid offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIFollowedMen];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMMan class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (uid) {
        [newRequest addPostValue:uid forKey:@"user_id"];
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

static NSString *const WMAPIWeiboFans = @"/weibo_fans";
-(NKRequest*)getManWeiboFansWithMID:(NSString*)mid type:(NSString *)type page:(int)page size:(int)size andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIWeiboFans];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMWeiboUser class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"man_id"];
    }
    if (type) {
        [newRequest addPostValue:type forKey:@"type"];
    }
    if (page) {
        [newRequest addPostValue:[NSNumber numberWithInt:page] forKey:@"page"];
    }
    if (size) {
        [newRequest addPostValue:[NSNumber numberWithInt:size] forKey:@"pagesize"];
    }
    
    
    [self addRequest:newRequest];
    return newRequest;
}

static NSString *const WMAPIGetFeedsOfGirlToManWithUID = @"/user/feed/list";
-(NKRequest*)getFeedsOfGirlToManWithUID:(NSString*)uid manID:(NSString*)manID isAnonymous:(NSNumber*)isAnonymous offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetFeedsOfGirlToManWithUID];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMFeed class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (uid) {
        [newRequest addPostValue:uid forKey:@"user_id"];
    }
    if (manID) {
        [newRequest addPostValue:manID forKey:@"man_id"];
    }
    if (isAnonymous) {
        [newRequest addPostValue:isAnonymous forKey:@"is_anonymous"];
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


static NSString *const WMAPIScoreManWithMID = @"/score";
-(NKRequest*)scoreManWithMID:(NSString*)mid scores:(NSString*)scores purview:(int)purview andRequestDelegate:(NKRequestDelegate*)rd{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIScoreManWithMID];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMActionResult class] resultType:NKResultTypeSingleObject andResultKey:@""];

    if (mid) {
        [newRequest addPostValue:mid forKey:@"man_id"];
    }
    
    if (scores) {
        [newRequest addPostValue:scores forKey:@"scores"];
    }

    [newRequest addPostValue:[NSNumber numberWithInt:purview] forKey:@"purview"];
    
    [self addRequest:newRequest];
    
    return newRequest;
    
}

static NSString *const WMAPIAddBaoliaoWithMID = @"/baoliao/create";
-(NKRequest*)addBaoliaoWithMID:(NSString*)mid content:(NSString*)content purview:(int)purview picture:(NSData*)picture audio:(NSData *)audio audio_seconds:(NSTimeInterval)audio_seconds andRequestDelegate:(NKRequestDelegate *)rd {
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIAddBaoliaoWithMID];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMActionResult class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"man_id"];
    }
    
    if (content) {
        [newRequest addPostValue:content forKey:@"content"];
    }
    
    [newRequest addPostValue:[NSNumber numberWithInt:purview] forKey:@"purview"];
    
    if (picture) {
        [newRequest addData:picture withFileName:@"fromIphone.jpg" andContentType:@"image/jpeg" forKey:@"attachment"];
    }
    
    if (audio) {
        [newRequest addData:audio withFileName:@"fromIphone.amr" andContentType:@"audio/amr" forKey:@"audio"];
        [newRequest addPostValue:@(audio_seconds) forKey:@"audio_seconds"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
    
    
}


static NSString *const WMAPIGetManPhotosWithMID = @"/photos";
-(NKRequest*)getManPhotosWithMID:(NSString*)mid offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetManPhotosWithMID];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMAttachment class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"id"];
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


static NSString *const WMAPIAddManTagWithMID = @"/add/tag";
-(NKRequest*)addManTagWithMID:(NSString*)mid tag:(NSString*)tag andRequestDelegate:(NKRequestDelegate*)rd{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIAddManTagWithMID];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMTag class] resultType:NKResultTypeArray andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"man_id"];
    }
    if (tag) {
        [newRequest addPostValue:tag forKey:@"tag"];
    }

    [self addRequest:newRequest];
    return newRequest;
    
}

static NSString *const WMAPIInviteFansWithMID = @"/batch_invite_weibo_fans";
-(NKRequest*)inviteManFansWithMID:(NSString*)mid weibos:(NSArray*)fans andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIInviteFansWithMID];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"man_id"];
    }
    if (fans) {
        [newRequest addPostValue:[fans JSONString] forKey:@"weibos"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
}

static NSString *const WMAPIReportWithTID = @"/mansubmit";
-(NKRequest*)reportManWithMID:(NSString*)mid andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIReportWithTID];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"id"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
}

static NSString *const WMAPISupportTagWithTID = @"/support/tag";
-(NKRequest*)supportTagWithTID:(NSString*)tagID andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPISupportTagWithTID];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMTag class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (tagID) {
        [newRequest addPostValue:tagID forKey:@"tag_id"];
    }
    
    [self addRequest:newRequest];
    return newRequest;
    
}


static NSString *const WMAPICreateManWithName = @"/man/create";

/*!
 * @param birthday: must format as "月-日-年", if no year component, just pass the "月-日"
 */

-(NKRequest*)createManWithName:(NSString*)name
                        avatar:(NSData*)avatar
                      birthday:(NSString*)birthday
                          tags:(NSString*)tags
                     weiboName:(NSString*)weiboName
                       weiboId:(NSString *)weiboId
                      flatform:(NSString *)flatform
                        scores:(NSString*)scores
                       purview:(int)purview
            andRequestDelegate:(NKRequestDelegate*)rd
                  universityID:(NSNumber *)universityID
                universityName:(NSString *)universityName
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPICreateManWithName];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMMan class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (name) {
        [newRequest addPostValue:name forKey:@"name"];
    }
    if (avatar) {
        [newRequest addData:avatar withFileName:@"fromIphone.jpg" andContentType:@"image/jpeg" forKey:@"avatar"];
    }
    
    if (birthday) {
        [newRequest addPostValue:birthday forKey:@"birthday"];
    }
    if (tags) {
        [newRequest addPostValue:tags forKey:@"tags"];
    }
    if (weiboName) {
        [newRequest addPostValue:weiboName forKey:@"weibo_name"];
    }
    if (scores) {
        [newRequest addPostValue:scores forKey:@"scores"];
    }
    
    if (flatform) {
        [newRequest addPostValue:flatform forKey:@"flatform"];
    }
    
    if (weiboId) {
        [newRequest addPostValue:weiboId forKey:@"flatform_id"];
    }
    
    if (universityID) {
        [newRequest addPostValue:universityID forKey:@"uinv_id"];
    }
    
    if (universityName) {
        [newRequest addPostValue:universityName forKey:@"univ_name"];
    }
    
    [newRequest addPostValue:[NSNumber numberWithInt:purview] forKey:@"purview"];
    
    
    [self addRequest:newRequest];
    
    return newRequest;
    
    
}

static NSString *const WMAPISearchMan = @"/search";
-(NKRequest*)searchManWithString:(NSString*)string offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPISearchMan];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMMan class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (string) {
        [newRequest addPostValue:string forKey:@"name"];
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

static NSString *const WMAPIGetManScore = @"/score/info";
-(NKRequest*)getManScoreWithMID:(NSString*)mid andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetManScore];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMScore class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"man_id"];
    }
//    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",[self serviceBaseURL], WMAPIGetManScore,mid];
//    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMScore class] resultType:NKResultTypeResultSets andResultKey:@""];
    [self addRequest:newRequest];
    
    return newRequest;
    
    
}

static NSString *const WMAPIGetManGrilfriends = @"/gf";
-(NKRequest *)getMenGrilFriends:(NSString *)mid andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?man_id=%@",[self serviceBaseURL], WMAPIGetManGrilfriends,mid];
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPICreateGrilfriend = @"/gf/create";
-(NKRequest *)createGrilFriend:(NSString *)man_id name:(NSString *)name year:(NSString *)year weibo:(NSString *)weibo desc:(NSString *)desc andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPICreateGrilfriend];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMManGrilFriend class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (man_id) {
        [newRequest addPostValue:man_id forKey:@"man_id"];
    }
    
    if (name) {
        [newRequest addPostValue:name forKey:@"name"];
    }
    
    if (year) {
        [newRequest addPostValue:year forKey:@"year"];
    }
    
    if (weibo) {
        [newRequest addPostValue:weibo forKey:@"weibo"];
    }
    
    if (desc) {
        [newRequest addPostValue:desc forKey:@"desc"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIVoteGrilfriend = @"/gf/vote";
-(NKRequest *)voteGrilFriend:(NSString *)mid weibo:(NSString *)weibo desc:(NSString *)desc andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIVoteGrilfriend];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"gf_id"];
    }
    if (weibo) {
        [newRequest addPostValue:weibo forKey:@"weibo"];
    }
    if (desc) {
        [newRequest addPostValue:desc forKey:@"desc"];
    }
    [self addRequest:newRequest];
    
    return newRequest;
}







static NSString *const WMAPIGetManInterest = @"/interest";
-(NKRequest *)getMenInterest:(NSString *)mid andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?man_id=%@",[self serviceBaseURL], WMAPIGetManInterest,mid];
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPICreateInterest = @"/interest/create";
-(NKRequest *)createInterest:(NSString *)man_id name:(NSString *)name type:(NSString *)type desc:(NSString *)desc andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPICreateInterest];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMManGrilFriend class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (man_id) {
        [newRequest addPostValue:man_id forKey:@"man_id"];
    }
    
    if (name) {
        [newRequest addPostValue:name forKey:@"name"];
    }
    
    if (type) {
        [newRequest addPostValue:type forKey:@"type"];
    }
    
    if (desc) {
        [newRequest addPostValue:desc forKey:@"desc"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIVoteInterest = @"/interest/vote";
-(NKRequest *)voteInterest:(NSString *)mid desc:(NSString *)desc andRequestDelegate:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIVoteInterest];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"interest_id"];
    }
    
    if (desc) {
        [newRequest addPostValue:desc forKey:@"desc"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}


static NSString *const WMAPIGetManLists = @"/lists";
-(NKRequest *)getManLists:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetManLists];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMManList class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIGetManListById = @"/list";
-(NKRequest *)getManListWithId:mid offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIGetManListById];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMMan class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    if (mid) {
        [newRequest addPostValue:mid forKey:@"id"];
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


static NSString *const WMAPIFeedbackManWithName = @"/feedback";

/*!
 * @param birthday: must format as "月-日-年", if no year component, just pass the "月-日"
 */

- (NKRequest *)feedbackManWithID:(NSString *)man_id
                            name:(NSString *)name
                      weibo_name:(NSString *)weibo_name
                        birthday:(NSString *)birthday
                          avatar:(NSData *)avatar
                       univ_name:(NSString *)univ_name
              andRequestDelegate:(NKRequestDelegate *)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPIFeedbackManWithName];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMMan class] resultType:NKResultTypeSingleObject andResultKey:@""];
    
    if (man_id) {
        [newRequest addPostValue:man_id forKey:@"man_id"];
    }
    if (name) {
        [newRequest addPostValue:name forKey:@"name"];
    }
    if (weibo_name) {
        [newRequest addPostValue:weibo_name forKey:@"weibo_name"];
    }
    if (birthday) {
        [newRequest addPostValue:birthday forKey:@"birthday"];
    }
    if (avatar) {
        [newRequest addData:avatar withFileName:@"fromIphone.jpg" andContentType:@"image/jpeg" forKey:@"avatar"];
    }
    if (univ_name) {
        [newRequest addPostValue:univ_name forKey:@"univ_name"];
    }
    
    [self addRequest:newRequest];
    
    return newRequest;
}

@end
