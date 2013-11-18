//
//  WMSettingViewController.h
//  WEIMI
//
//  Created by King on 11/14/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "UMFeedback.h"
#import "WMBindDetailViewController.h"
#import "RennSDK/RennSDK.h"

#import "WMCoupleTestViewController.h"

#import "MPNotificationView.h"

@interface WMSettingViewController : WMTableViewController <UMFeedbackDataDelegate, WMBindDetailViewDelegate, RennLoginDelegate>
{
    UMFeedback *_umFeedback;
    NSArray *mFeedbackDatas;
}
@end
