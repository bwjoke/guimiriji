//
//  WMMFeed.h
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMModel.h"
#import "WMMAttachment.h"
#import "WMMUser.h"
#import "WMMMan.h"


typedef enum{
	WMMFeedTypeDefault,
	WMMFeedTypeCreate
}WMMFeedType;


extern NSString *const WMFeedTypeCommon;
extern NSString *const WMFeedTypeBaoliao;
extern NSString *const WMFeedTypeDafen;


@interface WMMComment : WMModel

@property (nonatomic, retain) WMMUser  *sender;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *prefix;
@property (nonatomic, retain) NSString *content_orgin;
@property (nonatomic, retain) NSDate   *createTime;

@end




@interface WMMFeed : WMModel


@property (nonatomic, retain) WMMUser  *sender;
@property (nonatomic, retain) WMMMan    *man;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;

@property (nonatomic, retain) NSString *type;

@property (nonatomic, retain) NSNumber *isAnonymous;
@property (nonatomic, retain) NSString *purview;

@property (nonatomic, retain) NSString *client;

@property (nonatomic, retain) NSString *distance;

@property (nonatomic, retain) NSString *dist;

@property (nonatomic, retain) NSDate   *createTime;

@property (nonatomic, retain) NSNumber *commentCount;

@property (nonatomic, retain) NSMutableArray  *attachments;

@property (nonatomic, retain) NSMutableArray  *comments;

@property (nonatomic, assign) WMMFeedType     feedType;

@property (nonatomic, retain) NSDictionary    *score;

@property (nonatomic, retain) NSNumber *praise;

@property (nonatomic, retain) NSNumber *praised;

@property (nonatomic, retain) NSString *audioURLString;
@property (nonatomic, retain) NSNumber *audioSecond;

@end
