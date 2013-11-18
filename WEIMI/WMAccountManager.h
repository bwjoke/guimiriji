//
//  WMAccountManager.h
//  WEIMI
//
//  Created by King on 2/26/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "NKAccountManager.h"
#import "WMDataService.h"

@interface WMAccountManager : NKAccountManager

-(BOOL)canAutoLogin;
-(void)loginWithAccount:(id)account andRequestDelegate:(NKRequestDelegate*)rd;
-(BOOL)autoLogin;
-(void)logOut;

-(void)saveAccountsFile;
-(void)cacheMe:(WMMUser *)me;



@end
