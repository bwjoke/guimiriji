//
//  WMFeedService.h
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMServiceBase.h"

@interface WMFeedService : WMServiceBase

dshared(WMFeedService);

-(NKRequest*)getFeedsWithUID:(NSString*)uid offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getFeedWithFID:(NSString*)fid andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getFeedCommentsWithFID:(NSString*)fid offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getFeedsNear:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getFeedsNearWithType:(int)type distance:(int)distance offset:(int)offset size:(int)size andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest *)addFeedComment:(NSString *)fid touser:(NKMUser *)touser content:(NSString *)content anonymous:(int)anonymous andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)addMiyuWithContent:(NSString*)content purview:(int)purview picture:(NSData*)picture audio:(NSData *)audio audio_seconds:(NSTimeInterval)audio_seconds andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)deleteFeedWithFID:(NSString*)fid andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)deleteFeedCommentWithFID:(NSString*)mid andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)praiseFeedWithFID:(NSString*)fid andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)reportFeedWithFID:(NSString*)fid andContent:(NSString *)content andRequestDelegate:(NKRequestDelegate*)rd;
@end
