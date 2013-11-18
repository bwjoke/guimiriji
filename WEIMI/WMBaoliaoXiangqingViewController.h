//
//  WMBaoliaoXiangqingViewController.h
//  WEIMI
//
//  Created by King on 4/12/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//
@protocol WMBaoliaoXiangqingDelegate <NSObject>

@optional
-(void)deleteFeed;

-(void)commentFinished;

@end


#import "WMTableViewController.h"

@interface WMBaoliaoXiangqingViewController : WMTableViewController <UIGestureRecognizerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    int offSet;
}

@property (nonatomic, retain) WMMFeed *feed;
@property (nonatomic, retain) WMMMan  *man;
@property (nonatomic, retain) WMMManUser *manUser;

@property (nonatomic, assign) NKInputView *commentView;

@property (nonatomic, assign) UIView *scoreView;

@property (nonatomic, assign) id<WMBaoliaoXiangqingDelegate>delegate;

@property (nonatomic, assign) NSString *titleString;

+(id)feedDetailWithFeed:(WMMFeed*)feed;

@end
