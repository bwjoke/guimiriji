//
//  WMManService.h
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMServiceBase.h"

@interface WMManService : WMServiceBase

dshared(WMManService);


-(NKRequest*)getMenCategoryWithRequestDelegate:(NKRequestDelegate*)rd;
-(NKRequest*)getMenWithCategory:(NSString*)cate offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getManDetailWithMID:(NSString*)mid andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getManFeedWithMID:(NSString*)mid type:(NSString *)type offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getManUsersWithMID:(NSString*)mid offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;


-(NKRequest*)followManWithMID:(NSString*)mid andRequestDelegate:(NKRequestDelegate*)rd;
-(NKRequest*)unfollowManWithMID:(NSString*)mid andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getFollowedMenWithUID:(NSString*)uid offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getManWeiboFansWithMID:(NSString*)mid type:(NSString *)type page:(int)page size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getFeedsOfGirlToManWithUID:(NSString*)uid manID:(NSString*)manID isAnonymous:(NSNumber*)isAnonymous offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)scoreManWithMID:(NSString*)mid scores:(NSString*)scores purview:(int)purview andRequestDelegate:(NKRequestDelegate*)rd;
-(NKRequest*)addBaoliaoWithMID:(NSString*)mid content:(NSString*)content purview:(int)purview picture:(NSData*)picture audio:(NSData *)audio audio_seconds:(NSTimeInterval)audio_seconds andRequestDelegate:(NKRequestDelegate*)rd;


-(NKRequest*)getManPhotosWithMID:(NSString*)mid offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)addManTagWithMID:(NSString*)mid tag:(NSString*)tag andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)inviteManFansWithMID:(NSString*)mid weibos:(NSArray*)fans andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)reportManWithMID:(NSString*)mid andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)supportTagWithTID:(NSString*)tagID andRequestDelegate:(NKRequestDelegate*)rd;

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
                universityName:(NSString *)universityName;

-(NKRequest*)searchManWithString:(NSString*)string offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getManScoreWithMID:(NSString*)mid andRequestDelegate:(NKRequestDelegate*)rd;


-(NKRequest*)getMenFriendsAllFollowed:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;
//-(NKRequest*)addMiyuWithMID:(NSString*)mid content:(NSString*)content purview:(int)purview picture:(NSData*)picture andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest *)getMenGrilFriends:(NSString *)mid andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest *)createGrilFriend:(NSString *)man_id name:(NSString *)name year:(NSString *)year weibo:(NSString *)weibo desc:(NSString *)desc andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest *)voteGrilFriend:(NSString *)mid weibo:(NSString *)weibo desc:(NSString *)desc andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest *)getManLists:(NKRequestDelegate*)rd;

-(NKRequest *)getManListWithId:mid offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;

// 男人喜好
-(NKRequest *)getMenInterest:(NSString *)mid andRequestDelegate:(NKRequestDelegate*)rd;
-(NKRequest *)createInterest:(NSString *)man_id name:(NSString *)name type:(NSString *)type desc:(NSString *)desc andRequestDelegate:(NKRequestDelegate*)rd;
-(NKRequest *)voteInterest:(NSString *)mid desc:(NSString *)desc andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)feedbackManWithID:(NSString*)man_id
                          name:(NSString*)name
                    weibo_name:(NSString*)weibo_name
                      birthday:(NSString*)birthday
                        avatar:(NSData*)avatar
                     univ_name:(NSString *)univ_name
            andRequestDelegate:(NKRequestDelegate*)rd;

@end
