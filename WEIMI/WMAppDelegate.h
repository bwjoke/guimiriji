//
//  WMAppDelegate.h
//  WEIMI
//
//  Created by King on 10/24/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKPasscodeLock.h"
#import "KKPasscodeViewController.h"
#import "WXApi.h"
#import "UMFeedback.h"

#define kAppKey             @"596106848"
#define kAppSecret          @"e4d68eee62327a4cb236233fb698fca6"

//#define kAppRedirectURI     @"http://www.weimi.com/oauth/weibo_callback"
#define kAppRedirectURI     @"http://www.weimi.com"



extern NSString *const ZUOVersionRC;
extern NSString *const ZUOVersionProduct;

@class NKBadgeView;
@interface WMAppDelegate : UIResponder <UIApplicationDelegate,KKPasscodeViewControllerDelegate,WXApiDelegate,UMFeedbackDataDelegate>{
    
    NSArray *mFeedbackDatas;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)BOOL isLogin;
@property (nonatomic)BOOL isShareWeixinToAddWeimi;
@property (nonatomic)BOOL shouldHideNoti;
@property (nonatomic, retain) NSDictionary *sysFunctionRaw;
@property (nonatomic)int tabIndex;
@property (nonatomic,retain)NSArray *OauthArray;
@property (nonatomic, assign)NKBadgeView *totalBadge2,*totalBadge3;

+(WMAppDelegate *)shareAppDelegate;
-(void)saveSystemFunctionToUserDefalts;
-(void)saveSystemFunction;

// Get latest user's binding accounts
- (void)refreshBindAccounts;
-(void)getSysytemForbid;

@end
