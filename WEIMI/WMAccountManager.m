//
//  WMAccountManager.m
//  WEIMI
//
//  Created by King on 2/26/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMAccountManager.h"

@implementation WMAccountManager

static WMAccountManager *_sharedAccountsManager = nil;

+(id)sharedAccountsManager{
    
    if (!_sharedAccountsManager) {
        _sharedAccountsManager = [[self alloc] init];
    }
    
    return _sharedAccountsManager;
}


-(id)init{
    self = [super init];
    if (self) {
        
        self.allAccounts = [NSMutableArray arrayWithContentsOfFile:[[NKDataStore sharedDataStore] accountsPath]];
        if ([allAccounts count]>0) {
            NSDictionary *firstDic = [allAccounts objectAtIndex:0];
            self.currentAccount = [NKMAccount accountFromLocalDic:firstDic];
            
        }
        else{
            self.allAccounts = [NSMutableArray array];
        }
    }
    return self;
}


-(void)saveAccountsFile{
    
    if (!self.currentAccount) {
        return;
    }
    
    NSDictionary *dic = [self.currentAccount persistentDic];
    
    NKMAccount *tempA = nil;
    for (NSDictionary *alreadyhave in allAccounts) {
        
        tempA = [NKMAccount accountFromLocalDic:alreadyhave];
        if ([tempA.mid isEqualToString: [(NKMAccount*)self.currentAccount mid]]) {
            [allAccounts removeObject:alreadyhave];
            break;
        }
    }
    [self.allAccounts insertObject:dic atIndex:0];
    [self.allAccounts writeToFile:[[NKDataStore sharedDataStore] accountsPath] atomically:YES];
}



#pragma mark Login and Logout
-(BOOL)canAutoLogin{
    //return YES;
    
    BOOL autoLoginFlag = [self.currentAccount.shouldAutoLogin boolValue];
    BOOL socialFlag = !([[(NKMAccount*)self.currentAccount accountType] isEqualToString:NKAccountTypeOrigin]);
    BOOL savePasswordFlag = (self.currentAccount.password != nil);
    
    return autoLoginFlag && (socialFlag || savePasswordFlag);
}
-(void)logOut{
    // Will set the current account to nil if we do not want to show the email and password again
    
    [[NKUserService sharedNKUserService] logoutWithRequestDelegate:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NKWillLogoutNotificationKey object:nil];
    
    [[NKSocial social] removeSocial];

    self.currentAccount.shouldAutoLogin = [NSNumber numberWithBool:NO];
    self.currentAccount.password = @"";
    [self saveAccountsFile];
    
}

-(BOOL)autoLogin{
    
    // Should AutoLogin?
    if ([self canAutoLogin]) {
        [self loginWithAccount:self.currentAccount];
        return YES;
    }
    return NO;
}

-(void)loginFinish:(NKRequest*)request{
    
    WMMUser *me = [WMMUser meFromUser: [WMMUser modelFromDic:[request.originDic objectOrNilForKey:@"data"]]];

    [self saveAccountsFile];
    [[NKDataStore sharedDataStore] cacheObject:me forCacheKey:NKCachePathProfile];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NKLoginFinishNotificationKey object:nil];
    
}

- (void)cacheMe:(WMMUser *)me {
    [self saveAccountsFile];
    [[NKDataStore sharedDataStore] cacheObject:me forCacheKey:NKCachePathProfile];
    [[NSNotificationCenter defaultCenter] postNotificationName:NKLoginFinishNotificationKey object:nil];
}

-(void)loginWithAccount:(NKMAccount*)account andRequestDelegate:(NKRequestDelegate*)rd{
    
    self.currentAccount = (NKMAccount*)account;
    
    rd.inspector = self;
    rd.finishInspectorSelector = @selector(loginFinish:);
    
    [WMMUser meFromUser:[[NKDataStore sharedDataStore] cachedObjectOf:NKCachePathProfile andClass:[WMMUser class]]];
    
    if ([[self.currentAccount accountType] isEqualToString:NKAccountTypeOrigin]) {
        [[NKUserService sharedNKUserService] loginWithUsername:account.account password:account.password andRequestDelegate:rd];
    }
    else {

        [[NKUserService sharedNKUserService] socialLoginWithType:account.accountType
                                                           oauthID:account.oauthID
                                                             token:account.accessToken
                                                             uname:nil
                                                andRequestDelegate:rd];
    
    }
}

-(void)loginWithAccount:(id)account{
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:nil finishSelector:nil andFailedSelector:nil];
    
    [self loginWithAccount:account andRequestDelegate:rd];
    
}




@end
