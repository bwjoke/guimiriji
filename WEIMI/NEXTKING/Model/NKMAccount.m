//
//  NKMAccount.m
//  NEXTKING
//
//  Created by King on 10/24/12.
//  Copyright (c) 2012 NK.COM. All rights reserved.
//

#import "NKMAccount.h"

NSString *const NKWillLogoutNotificationKey = @"NKWillLogoutNotificationKey";
NSString *const NKLoginFinishNotificationKey = @"NKLoginFinishNotificationKey";

NSString *const NKAccountTypeOrigin = @"nk";
NSString *const NKAccountTypeWeibo = @"weibo";
NSString *const NKAccountTypeRenren = @"renren";
NSString *const NKAccountTypeTqq = @"qq";

@implementation NKMAccount

@synthesize account;
@synthesize password;
@synthesize shouldSavePassword;
@synthesize shouldAutoLogin;

@synthesize oauthID;
@synthesize accessToken;

@synthesize accountType;
@synthesize oauth;

-(void)dealloc{
    
    [account release];
    [password release];
    
    [shouldSavePassword release];
    [shouldAutoLogin release];
    
    [oauthID release];
    [accessToken release];
    
    [accountType release];
    [oauth release];
    
    [super dealloc];
}

static NKMAccount *_reg = nil;

+(id)registerAccount{
    
    if (!_reg) {
        _reg = [[NKMAccount alloc] init];
        _reg.createType = NKMUserCreateTypeFromWeb;
    }
    
    return _reg;
}

+(id)cleanRegisterAccout{
    
    [_reg release];
    _reg = nil;
    return nil;
}

-(NSString*)description{
    
    return [NSString stringWithFormat:@"<%@> account:%@,  ", NSStringFromClass([self class]), account];
}

+(id)accountWithAccount:(NSString *)aloginName password:(NSString *)apassword andShouldAutoLogin:(NSNumber *)autoLogin{
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:aloginName, @"account", apassword, @"password", autoLogin, @"shouldAutoLogin", nil];
    
    return [NKMAccount accountFromLocalDic:dic];
    
    
}

+(id)accountFromLocalDic:(NSDictionary*)dic{
    
    NKMAccount *newAccount = [[self alloc] init];
    if (newAccount) {
        
        newAccount.jsonDic = dic;
        newAccount.mid = [dic objectForKey:@"id"];
        newAccount.account = [dic objectForKey:@"account"];
        newAccount.password = [dic objectForKey:@"password"];
        newAccount.shouldAutoLogin = [dic objectForKey:@"shouldAutoLogin"];
        newAccount.oauthID = [dic objectOrNilForKey:@"oauthID"];
        newAccount.accessToken = [dic objectOrNilForKey:@"accessToken"];
        newAccount.accountType = [dic objectOrNilForKey:@"accountType"];
    }
    
    return  [newAccount autorelease];
    
}

- (id)init {
    self = [super init];
    if (self) {
        self.oauth = [NSMutableDictionary dictionary];
    }
    return self;
}

-(NSDictionary*)persistentDic{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    // ID  !!!

    NKBindValueToKeyForParameterToDic(@"id",self.mid,dic);
    
    // Name
    NKBindValueToKeyForParameterToDic(@"loginName",self.account,dic);
    NKBindValueToKeyForParameterToDic(@"password",self.password,dic);
    
    NKBindValueToKeyForParameterToDic(@"shouldAutoLogin",self.shouldAutoLogin,dic);
    NKBindValueToKeyForParameterToDic(@"oauthID",self.oauthID,dic);
    NKBindValueToKeyForParameterToDic(@"accessToken",self.accessToken,dic);
    NKBindValueToKeyForParameterToDic(@"accountType",self.accountType,dic);
    return dic;

}


@end