//
//  WMRelationViewController.h
//  WEIMI
//
//  Created by steve on 13-7-31.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//
@protocol WMRelationViewControllerDelegate <NSObject>

@optional
-(void)shouldGetManInfo;

@end


#import "WMTableViewController.h"
#import "WMMMan.h"
#import "WMInputAlertView.h"
#import "WMPopView.h"

@interface WMRelationViewController : WMTableViewController<UIAlertViewDelegate,WMPopViewDelegate>

@property(nonatomic,strong)WMMMan *man;
@property(nonatomic,unsafe_unretained)id<WMRelationViewControllerDelegate>delegate;
@end
