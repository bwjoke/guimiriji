//
//  WMMMan.m
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMMMan.h"



NSString *const WMMManUserRelationSelf = @"自己";
NSString *const WMMManUserRelationGuimi = @"闺密";
NSString *const WMMManUserRelationMoshen = @"陌生人";


@implementation WMMManUser

-(void)dealloc{
    
    [_user release];
    [_isAnonymous release];
    
    [_score release];
    [_scoreCount release];
    
    [_commentCount release];
    [_baoliaoCount release];
    
    [_relation release];
    
    [super dealloc];
}

+(id)modelFromDic:(NSDictionary *)dic{
    
    WMMManUser *manUser = [super modelFromDic:dic];
    
    NSDictionary *user = [dic objectOrNilForKey:@"user"];
    if (user) {
        manUser.user = [WMMUser modelFromDic:user];
    }
    
    NKBindValueWithKeyForParameterFromDic(@"is_anonymous", manUser.isAnonymous, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"score", manUser.score, dic);
    NKBindValueWithKeyForParameterFromDic(@"score_count", manUser.scoreCount, dic);
    NKBindValueWithKeyForParameterFromDic(@"baoliao_count", manUser.baoliaoCount, dic);
    NKBindValueWithKeyForParameterFromDic(@"comment_count", manUser.commentCount, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"relation", manUser.relation, dic);
    
    return manUser;
    
}

@end


@implementation WMMScore


-(void)dealloc{
    
    [_name release];
    [_score release];
    
    [super dealloc];
}

+(id)modelFromDic:(NSDictionary *)dic{
    
    WMMScore *tag = [super modelFromDic:dic];
    
    NKBindValueWithKeyForParameterFromDic(@"name", tag.name, dic);
    NKBindValueWithKeyForParameterFromDic(@"score", tag.score, dic);
    
    return tag;
}

-(NSDictionary *)uploadDic{
    
    return @{@"name":self.name, @"score":self.score};
    
}
@end


@implementation WMMTag

-(void)dealloc{
    
    [_name release];
    [_supportCount release];
    [_iSupport release];
    
    [super dealloc];
}

+(id)modelFromDic:(NSDictionary *)dic{
    
    WMMTag *tag = [super modelFromDic:dic];
    
    NKBindValueWithKeyForParameterFromDic(@"name", tag.name, dic);
    NKBindValueWithKeyForParameterFromDic(@"support_count", tag.supportCount, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"supported", tag.iSupport, dic);
    
    return tag;
}

@end



@implementation WMMMan


-(void)dealloc{
    
    [_name release];
    [_birth release];
    [_birthday release];
    [_university release];
    [_constellation release];
    
    [_avatarPath release];
    [_avatarBigPath release];
    [_avatar release];
    [_avatarBig release];
    
    [_scoreCount release];
    [_baoliaoCount release];
    [_viewCount release];
    [_followCount release];
    [_commentCount release];
    
    [_opCount release];
    
    [_score release];
    
    [_tags release];
    
    [_followed release];
    
    [_weiboName release];

    [_weiboUrl release];
    
    [_flatform release];
    
    [_flatformId release];
    
    [_hasRate release];
    
    [_gfCount release];
    
    [_interestCount release];
    
    [_gfStatus release];
    
    [super dealloc];
}


+(id)modelFromDic:(NSDictionary *)dic{
    
    WMMMan *man = [super modelFromDic:dic];
    
    NKBindValueWithKeyForParameterFromDic(@"name", man.name, dic);
    NKBindValueWithKeyForParameterFromDic(@"birth", man.birth, dic);
    NKBindValueWithKeyForParameterFromDic(@"university", man.university, dic);
    NKBindValueWithKeyForParameterFromDic(@"constellation", man.constellation, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"avatar", man.avatarPath, dic);
    NKBindValueWithKeyForParameterFromDic(@"avatar_big", man.avatarBigPath, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"score_count", man.scoreCount, dic);
    NKBindValueWithKeyForParameterFromDic(@"baoliao_count", man.baoliaoCount, dic);
    NKBindValueWithKeyForParameterFromDic(@"view_count", man.viewCount, dic);
    NKBindValueWithKeyForParameterFromDic(@"follow_count", man.followCount, dic);
    NKBindValueWithKeyForParameterFromDic(@"comment_count", man.commentCount, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"op_count", man.opCount, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"score", man.score, dic);
    
    NSArray *tags = [dic objectOrNilForKey:@"tags"];
    if ([tags isKindOfClass:[NSArray class]] && tags.count) {
        
        man.tags = [NSMutableArray arrayWithCapacity:tags.count];
        for (NSDictionary *tag in tags) {
            [man.tags addObject:[WMMTag modelFromDic:tag]];
        }
    }
    
    NKBindValueWithKeyForParameterFromDic(@"followed", man.followed, dic);
    NKBindValueWithKeyForParameterFromDic(@"weibo_name", man.weiboName, dic);
    NKBindValueWithKeyForParameterFromDic(@"weibourl", man.weiboUrl, dic);
    NKBindValueWithKeyForParameterFromDic(@"flatform", man.flatform, dic);
    NKBindValueWithKeyForParameterFromDic(@"flatform_id", man.flatformId, dic);
    NKBindValueWithKeyForParameterFromDic(@"rated", man.hasRate, dic);
    NKBindValueWithKeyForParameterFromDic(@"gf_count", man.gfCount, dic);
    NKBindValueWithKeyForParameterFromDic(@"gf_status", man.gfStatus, dic);
    //interest_count
    NKBindValueWithKeyForParameterFromDic(@"interest_count", man.interestCount, dic);
    return man;
}


-(UIImage*)avatar{
    
    if (!_avatar) {
        
        [[NKImageLoader imageLoader] addImageLoadObject:[NKImageLoadObject imageLoadObjectWithObject:self url:self.avatarPath andKeyPath:@"avatar"]];
    }
    
    return _avatar;
    
    
}

-(UIImage*)avatarBig{
    
    if (!_avatarBig) {
        
        [[NKImageLoader imageLoader] addImageLoadObject:[NKImageLoadObject imageLoadObjectWithObject:self url:self.avatarBigPath andKeyPath:@"avatarBig"]];
    }
    
    return _avatarBig;
    
    
}



-(oneway void)release{
    
    if ([self retainCount]==2) {
        //self.avatar = nil;
        self.avatarBig = nil;
    }
    
    [super release];

}

- (NSString *)scoreDescription {
    if (!self.score) return @"0.0";
    
    CGFloat value = [self.score floatValue];
    
    return value < 0 ? @"负分" : [NSString stringWithFormat:(value == 10.0f ? @"%.0f" : @"%.1f"), value];
}

- (NSInteger)scoreLevel {
    if (!self.score) return NSNotFound;
    
    CGFloat value = [self.score floatValue];
    
    return value < 0 ? -1 : (NSInteger)((value + 2.0f) / 2.0f);
}

@end

@implementation WMMMenCategory

-(void)dealloc{
    
    [_name release];
    [_type release];
    [_men release];
    
    [super dealloc];
}

+(id)modelFromDic:(NSDictionary *)dic{
    
    WMMMenCategory *category = [super modelFromDic:dic];
    
    NKBindValueWithKeyForParameterFromDic(@"category", category.name, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"type", category.type, dic);
    
    NSArray *men = [dic objectOrNilForKey:@"men"];
    
    if ([men isKindOfClass:[NSArray class]] && men.count) {
        
        category.men = [NSMutableArray arrayWithCapacity:men.count];
        for (NSDictionary *man in men) {
            [category.men addObject:[WMMMan modelFromDic:man]];
        }
    }
    
    
    return category;
    
}

@end

@implementation WMMRelation

- (void)dealloc {
    [_name release];
    [_desc release];
    [super dealloc];
}

+ (id)modelFromDic:(NSDictionary *)dic {
    WMMRelation *relation = [super modelFromDic:dic];
    NKBindValueWithKeyForParameterFromDic(@"anonyname", relation.name, dic);
    NKBindValueWithKeyForParameterFromDic(@"user_id", relation.mid, dic);
    NKBindValueWithKeyForParameterFromDic(@"desc", relation.desc, dic);
    return relation;
}

@end

@implementation WMManGrilFriend

-(void)dealloc
{
    [_name release];
    [_year release];
    [_count release];
    [_isSupport release];
    [_relations release];
    [super dealloc];
}

+(id)modelFromDic:(NSDictionary *)dic{
    WMManGrilFriend *manGrilFriend = [super modelFromDic:dic];
    NKBindValueWithKeyForParameterFromDic(@"name", manGrilFriend.name, dic);
    NKBindValueWithKeyForParameterFromDic(@"year", manGrilFriend.year, dic);
    NKBindValueWithKeyForParameterFromDic(@"count", manGrilFriend.count, dic);
    NKBindValueWithKeyForParameterFromDic(@"voted", manGrilFriend.isSupport, dic);
    
    NSMutableArray *relations = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSDictionary *log in dic[@"logs"]) {
        [relations addObject:[WMMRelation modelFromDic:log]];
    }
    
    manGrilFriend.relations = relations;
    
    return manGrilFriend;
}

@end

@implementation WMManList

-(void)dealloc
{
    [_name release];
    [_bigAvatarPath release];
    [_smallImages release];
    [_avatarImage release];
    [_desc release];
    [super dealloc];
}

+(id)modelFromDic:(NSDictionary *)dic
{
    WMManList *list = [super modelFromDic:dic];
    NKBindValueWithKeyForParameterFromDic(@"name", list.name, dic);
    NKBindValueWithKeyForParameterFromDic(@"description", list.desc, dic);
    NKBindValueWithKeyForParameterFromDic(@"big", list.bigAvatarPath, [dic valueForKey:@"data"]);
    NSArray *images = [[dic valueForKey:@"data"] valueForKey:@"small"];
    list.smallImages = [NSMutableArray array];
    for (int i=0; i<[images count]; i++) {
        [list.smallImages addObject:[images objectAtIndex:i]];
    }
    return list;
}


-(UIImage *)avatarImage
{
    if (!_avatarImage) {
        [[NKImageLoader imageLoader] addImageLoadObject:[NKImageLoadObject imageLoadObjectWithObject:self url:_bigAvatarPath andKeyPath:@"avatarImage"]];
    }
    return _avatarImage;
}
@end

@implementation WMManInterest

-(void)dealloc
{
    [_name release];
    [_type release];
    [_count release];
    [_voted release];
    [_relations release];
    [super dealloc];
}

+(id)modelFromDic:(NSDictionary *)dic{
    WMManInterest *manInterest = [super modelFromDic:dic];
    NKBindValueWithKeyForParameterFromDic(@"name", manInterest.name, dic);
    NKBindValueWithKeyForParameterFromDic(@"type", manInterest.type, dic);
    NKBindValueWithKeyForParameterFromDic(@"count", manInterest.count, dic);
    NKBindValueWithKeyForParameterFromDic(@"voted", manInterest.voted, dic);
    
    NSMutableArray *relations = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSDictionary *log in dic[@"logs"]) {
        [relations addObject:[WMMRelation modelFromDic:log]];
    }
    
    manInterest.relations = relations;
    
    return manInterest;
}

@end
