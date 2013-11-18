//
//  NKMUser.m
//  NEXTKING
//
//  Created by King on 10/24/12.
//  Copyright (c) 2012 NK.COM. All rights reserved.
//

#import "NKMUser.h"
#import "NKConfig.h"


NSString *const NKRelationFriend = @"friend";
NSString *const NKRelationFollowing = @"following";
NSString *const NKRelationFollower = @"follower";

NSString *const NKGenderKeyMale = @"male";
NSString *const NKGenderKeyFemale = @"female";
NSString *const NKGenderKeyUnknown = @"unknown";

static NSArray *oauthTypes;

@implementation NKMUser

@synthesize createType;

@synthesize showName;
@synthesize name;
@synthesize topicName;
@synthesize searchKey;

@synthesize mobile;
@synthesize email;

@synthesize gender;
@synthesize company;
@synthesize location;
@synthesize birthday;
@synthesize sign;
@synthesize city;

@synthesize avatarPath;

@synthesize avatar;

@synthesize relation;

@synthesize rate;


+ (void)initialize {
    oauthTypes = [@[@"weibo", @"renren"] retain];
}


-(void)dealloc{
    
    [self.avatarRequest clearDelegatesAndCancel];
    
    
    [showName release];
    [name release];
    [topicName release];
    [searchKey release];
    
    [mobile release];
    [email release];
    
    [gender release];
    [company release];
    [location release];
    [birthday release];
    [sign release];
    [city release];

    [avatarPath release];
    [_avatarBigPath release];
    [avatar release];
    [_avatarBig release];
    
    [relation release];
    
    [rate release];
    
    [_universityId release];
    [_universityName release];
    [_universityProvinceId release];
    [_universityProvinceName release];
    [_notiSwitch release];
    [super dealloc];
}



static NKMUser *_me = nil;
+(id)meFromUser:(NKMUser*)User{
    _me = User;
    return _me;
    
}
+(id)me{
    
    return _me;
}

+(id)user{
    NKMUser *newUser = [[self alloc] init];
    newUser.createType = NKMUserCreateTypeFromContact;
    return [newUser autorelease];
}
#if TARGET_OS_IPHONE
+(id)userWithName:(NSString*)tname phoneNumber:(NSString*)tphoneNumber andAvatar:(UIImage*)tavatar{
	
	NKMUser *newUser = [[self alloc] init];
	newUser.createType = NKMUserCreateTypeFromContact;
	newUser.name = tname;
    newUser.mobile = tphoneNumber;
	newUser.avatar = tavatar;
    //    newUser.invited = NO;
	return [newUser autorelease];
}
#endif

+(id)modelFromDic:(NSDictionary*)dic{
    
    return [self userFromDic:dic];
}

/*
 -(void)logCount{
 
 NSLog(@"%d", [name retainCount]);
 [self performSelector:@selector(logCount) withObject:nil afterDelay:1.0];
 
 }
 */

-(NSString*)description{
    
    return [NSString stringWithFormat:@" <%@> name:%@, id:%@, city:%@, avatar:%@, sign:%@", NSStringFromClass([self class]), name, mid, city, avatarPath, sign];
}

-(NSString*)showRate{
    
    NSString *rateString = @"";
    for (NSDictionary *dic in self.rate) {
        rateString = [rateString stringByAppendingFormat:@"%@:%@;", [[dic allKeys] lastObject], [[dic allValues] lastObject]];
    }
    
    return rateString;
}

-(NSDictionary*)cacheDic{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    // ID  !!!
    NKBindValueToKeyForParameterToDic(@"id",self.mid,dic);
    
    // Name
    NKBindValueToKeyForParameterToDic(@"name",self.name,dic);
    NKBindValueToKeyForParameterToDic(@"search_key",self.searchKey,dic);
    
    // Contact
    NKBindValueToKeyForParameterToDic(@"email", self.email, dic);
    NKBindValueToKeyForParameterToDic(@"mobile", self.mobile, dic);
    
    // Avatar
    NKBindValueToKeyForParameterToDic(@"avatar", self.avatarPath, dic);
    //NKBindValueToKeyForParameterToDic(@"avatarBig", self.bigAvatarPath, dic);
    
    //TopicName
    NKBindValueToKeyForParameterToDic(@"topicnick", self.topicName, dic);
    // Gender
    //    NKBindValueToKeyForParameterToDic(@"gender", self.gender, dic);
    //    NKBindValueToKeyForParameterToDic(@"company", self.company, dic);
    //    NKBindValueToKeyForParameterToDic(@"brief", self.brief, dic);
    //    NKBindValueToKeyForParameterToDic(@"city", self.city, dic);
    //    NKBindValueToKeyForParameterToDic(@"birthday", self.birthday, dic);
    
    return dic;
}

//-(oneway void)release{
//
//    [super release];
//
//    NSLog(@"%d", [self retainCount]);
//}

-(void)bindValuesForDic:(NSDictionary*)dic{
    
    // Name
    NKBindValueWithKeyForParameterFromDic(@"name", self.name, dic);
    NKBindValueWithKeyForParameterFromDic(@"search_key", self.searchKey, dic);
    
    // Contact
    NKBindValueWithKeyForParameterFromDic(@"mobile", self.mobile, dic);
    NKBindValueWithKeyForParameterFromDic(@"email", self.email, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"avatar", self.avatarPath, dic);
    NKBindValueWithKeyForParameterFromDic(@"avatar_big", self.avatarBigPath, dic);
    
    // Gender
    NKBindValueWithKeyForParameterFromDic(@"gender", self.gender, dic);
    NKBindValueWithKeyForParameterFromDic(@"company", self.company, dic);
    NKBindValueWithKeyForParameterFromDic(@"location", self.location, dic);
    NKBindValueWithKeyForParameterFromDic(@"sign", self.sign, dic);
    NKBindValueWithKeyForParameterFromDic(@"birthday", self.birthday, dic);
    NKBindValueWithKeyForParameterFromDic(@"city", self.city, dic);
    
    
    NKBindValueWithKeyForParameterFromDic(@"relation", self.relation, dic);
    
    NKBindValueWithKeyForParameterFromDic(@"id", self.universityId, [dic valueForKey:@"university"]);
    NKBindValueWithKeyForParameterFromDic(@"name", self.universityName, [dic valueForKey:@"university"]);
    NKBindValueWithKeyForParameterFromDic(@"id", self.universityProvinceId, [[dic valueForKey:@"university"] valueForKey:@"province"]);
    NKBindValueWithKeyForParameterFromDic(@"name", self.universityProvinceName, [[dic valueForKey:@"university"] valueForKey:@"province"]);
    if ([[dic valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
        NKBindValueWithKeyForParameterFromDic(@"switch", self.notiSwitch, [dic valueForKey:@"data"]);
    }
    
    self.topicName = [dic objectOrNilForKey:@"topicnick"];
    
    NSDictionary *extraInfo = [dic valueForKey:@"data"];
    
    if ([extraInfo isKindOfClass:[NSDictionary class]]) {
        if (extraInfo[@"switch"]) {
            self.notiSwitch = extraInfo[@"switch"];
        }
        
        if (extraInfo[@"max_friends"]) {
            self.maxFriends = [extraInfo[@"max_friends"] integerValue];
        } else {
            self.maxFriends = DEFAULT_MAX_FRINEDS;
        }
        
        if (extraInfo[@"shared"]) {
            self.sharedToTimeline = [extraInfo[@"shared"] boolValue];
        } else {
            self.sharedToTimeline = NO;
        }
    }
}

+(id)modelFromCache:(NSDictionary*)dic{
    return [self userFromDic:dic isCache:YES];
}

-(void)bindValuesFromCache:(NSDictionary*)dic{
    
    // Name
    NKBindValueWithKeyForParameterFromCache(@"name",self.name,dic);
    NKBindValueWithKeyForParameterFromCache(@"search_key",self.searchKey,dic);
    
    // Contact
    //NKBindValueWithKeyForParameterFromCache(@"mobile", self.mobilePhone, dic);
    
    // Avatar
    NKBindValueWithKeyForParameterFromCache(@"avatar", self.avatarPath, dic);
    //    NKBindValueWithKeyForParameterFromCache(@"avatarBig", self.bigAvatarPath, dic);
    
}

+(id)userFromDic:(NSDictionary*)dic isCache:(BOOL)cache{
    if (!dic) {
        
        return [[[self alloc] init] autorelease];
    }
    
    NSString *theUID = [NSString stringWithFormat:@"%@", [dic objectOrNilForKey:@"id"]];
    NKMUser *cachedUser = [[[NKMemoryCache sharedMemoryCache] cachedUsers] objectOrNilForKey:theUID];
    if (cachedUser) {
        
        [cachedUser bindValuesForDic:dic];
        
        return cachedUser;
    }
    else{
        NKMUser *newUser = [[self alloc] init];
		newUser.createType = NKMUserCreateTypeFromWeb;
        newUser.jsonDic = dic;
        // ID
        newUser.mid  = theUID;
        [newUser bindValuesForDic:dic];
        [[[NKMemoryCache sharedMemoryCache] cachedUsers] setObject:newUser forKey:theUID];
        return [newUser autorelease];
    }
    
}

+(id)userFromDic:(NSDictionary*)dic{
    
    return [self userFromDic:dic isCache:NO];
}


-(NSString*)profileUpdateString{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObjectOrNil:self.name forKey:@"name"];
    [dic setObjectOrNil:self.sign forKey:@"sign"];
    [dic setObjectOrNil:self.gender forKey:@"gender"];
    
    
    /*
     NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
     self.name, @"name",
     self.brief, @"brief",
     self.city, @"city",
     self.company, @"company",
     self.gender, @"gender",
     self.birthday, @"birthday",
     nil];
     */
    
    return [dic JSONString];
}


+(NSPredicate*)predicateWithSearchString:(NSString*)searchString{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(mobile BEGINSWITH[cd] %@) OR (showName contains [cd] %@) OR (name contains [cd] %@) OR (searchKey contains [cd] %@)",searchString,searchString,searchString, searchString];
    
    return predicate;
    
}



#if TARGET_OS_IPHONE
-(UIImage*)avatar{
    if (!avatar && self.createType==NKMUserCreateTypeFromWeb /* the User from web, will have the uid, and we can get avatar from web, the User we create by ourself has no uid*/) {
        if (!self.downloadingAvatar) {
            [self downLoadAvatar];
        }
        return [UIImage imageNamed:@"default_portrait.png"];
        
    }
    
    if (!avatar && self.createType==NKMUserCreateTypeFromContact) {
        self.avatar = [UIImage imageNamed:@"default_portrait.png"];
    }
    return avatar;
}
-(void)downLoadAvatarFinish:(ASIHTTPRequest*)request{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        UIImage *avatarImage = [UIImage imageWithContentsOfFile:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]];
        if (avatarImage) {
            self.avatar = avatarImage;
            self.downloadingAvatar = NO;
        }
        
        self.avatarRequest = nil;
    });
    
}


#else
-(NSImage*)avatar{
    if (!avatar && self.createType==NKMUserCreateTypeFromWeb /* the User from web, will have the uid, and we can get avatar from web, the User we create by ourself has no uid*/) {
        if (!self.downloadingAvatar) {
            [self downLoadAvatar];
        }
        return [NSImage imageNamed:@"default_portrait.png"];
        
    }
    
    if (!avatar && self.createType==NKMUserCreateTypeFromContact) {
        self.avatar = [NSImage imageNamed:@"default_portrait.png"];
    }
    return avatar;
}
-(void)downLoadAvatarFinish:(ASIHTTPRequest*)request{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSImage *avatarImage = [[[NSImage alloc] initWithContentsOfFile:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]] autorelease];
        if (avatarImage) {
            self.avatar = avatarImage;
            self.downloadingAvatar = NO;
        }
        self.avatarRequest = nil;
    });
}
#endif


#pragma mark DownloadAndUpload
@synthesize downloadingAvatar;
@synthesize avatarRequest;

-(void)downLoadAvatarFailed:(ASIHTTPRequest*)request{
    self.downloadingAvatar = NO;
    self.avatarRequest = nil;
}

-(void)downLoadAvatar{
    
    if (self.downloadingAvatar) {
        return;
    }
    self.downloadingAvatar = YES;
    
    NSString *finalString = self.avatarPath;
    
    //ASIHTTPRequest *request = [ASIHTTPRequest requestWithImageURL:[NSURL URNKithUnEncodeString:self.avatarPath]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithImageURL:[NSURL URLWithString:finalString]];
    request.delegate = self;
    self.avatarRequest = request;
    [request setDidFinishSelector:@selector(downLoadAvatarFinish:)];
    [request setDidFailSelector:@selector(downLoadAvatarFailed:)];
    
    //[[NKSDK sharedSDK] addTicket:(NKTicket*)request];
    [request startAsynchronous];
    
}


-(UIImage*)avatarBig{
    
    if (!_avatarBig) {
        
        [[NKImageLoader imageLoader] addImageLoadObject:[NKImageLoadObject imageLoadObjectWithObject:self url:self.avatarBigPath andKeyPath:@"avatarBig"]];
    }
    
    return _avatarBig;
    
    
}



- (BOOL)isAllOauthBined {
    NSDictionary *oauth = [[[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] currentAccount] oauth];
    
    for (NSString *oauthType in oauthTypes) {
        // Have not binded or expired
        if (!oauth[oauthType] || [oauth[oauthType] boolValue]) {
            return NO;
        }
    }
    
    return YES;
}

- (NSInteger)realMaxFriekds {
    if (self.maxFriends != nil) {
        return [self.maxFriends intValue];
    } else {
        return DEFAULT_MAX_FRINEDS;
    }
}

-(oneway void)release{
    
    if ([self retainCount]==2) {
        self.avatar = nil;
        self.avatarBig = nil;
    }
    
    [super release];
    
    
}


@end

