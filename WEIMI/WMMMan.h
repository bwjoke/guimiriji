//
//  WMMMan.h
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMModel.h"
#import "WMMUser.h"


extern NSString *const WMMManUserRelationSelf;
extern NSString *const WMMManUserRelationGuimi;
extern NSString *const WMMManUserRelationMoshen;


@interface WMMManUser : WMModel{
    
}

@property (nonatomic, retain) WMMUser  *user;
@property (nonatomic, retain) NSNumber *isAnonymous;

@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, retain) NSNumber *scoreCount;
@property (nonatomic, retain) NSNumber *commentCount;
@property (nonatomic, retain) NSNumber *baoliaoCount;

@property (nonatomic, retain) NSString *relation;

@end



@interface WMMScore : WMModel {
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *score;

-(NSDictionary *)uploadDic;

@end




@interface WMMTag : WMModel {
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *supportCount;
@property (nonatomic, retain) NSNumber *iSupport;

@end





@interface WMMMan : WMModel {
    

    
}

@property (nonatomic, retain) NSString     *name;

@property (nonatomic, retain) NSDictionary *birth;
@property (nonatomic, retain) NSDate       *birthday;
@property (nonatomic, retain) NSDictionary *university;
@property (nonatomic, retain) NSString     *constellation;

@property (nonatomic, retain) NSString     *avatarPath;
@property (nonatomic, retain) NSString     *avatarBigPath;

@property (nonatomic, retain) UIImage      *avatar;
@property (nonatomic, retain) UIImage      *avatarBig;

@property (nonatomic, retain) NSNumber     *scoreCount;
@property (nonatomic, retain) NSNumber     *baoliaoCount;
@property (nonatomic, retain) NSNumber     *viewCount;
@property (nonatomic, retain) NSNumber     *followCount;
@property (nonatomic, retain) NSNumber     *commentCount;

@property (nonatomic, retain) NSNumber     *opCount;

@property (nonatomic, retain) NSNumber     *score;

@property (nonatomic, retain) NSMutableArray *tags;

@property (nonatomic, retain) NSNumber     *followed;

@property (nonatomic, retain) NSString     *weiboName;

@property (nonatomic, retain) NSString     *weiboUrl;

@property (nonatomic, retain) NSString     *flatformId;

@property (nonatomic, retain) NSString     *flatform;

@property (nonatomic, retain) NSNumber     *hasRate;

@property (nonatomic, retain) NSNumber     *gfCount;

@property (nonatomic, retain) NSNumber     *interestCount;

@property (nonatomic, retain) NSString     *gfStatus;

// Score description based on the @property score
- (NSString *)scoreDescription;

// Score level based on the @property score
- (NSInteger)scoreLevel;

@end


@interface WMMMenCategory : WMModel {
    
}

@property (nonatomic, retain) NSString       *name;
@property (nonatomic, retain) NSString       *type;

@property (nonatomic, retain) NSMutableArray *men;

@end

@interface WMMRelation : WMModel

@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *desc;

@end

@interface WMManGrilFriend : WMModel {

}
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *year;
@property(nonatomic,retain) NSNumber *count;
@property (nonatomic, retain) NSNumber *isSupport;
@property (nonatomic, retain) NSArray *relations;


@end

@interface WMManList : WMModel

@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *bigAvatarPath;
@property(nonatomic,retain)UIImage *avatarImage;
@property(nonatomic,retain)NSMutableArray *smallImages;
@property(nonatomic,retain)NSString *desc;

@end

@interface WMManInterest : WMModel {
    
}
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *type;
@property(nonatomic,retain) NSNumber *count;
@property (nonatomic, retain) NSNumber *voted;
@property (nonatomic, retain) NSArray *relations;


@end

