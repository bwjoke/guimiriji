//
//  WMFeedDetailViewController.h
//  WEIMI
//
//  Created by King on 11/21/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

@protocol WMFeedDetailDelegate <NSObject>

@optional
-(void)deleteFeed;

-(void)commentFinished;

@end

#import "WMTableViewController.h"

@interface WMFeedDetailViewController : WMTableViewController <UIGestureRecognizerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>{
    
    NKMRecord *record;
    NKInputView *commentView;
    
    int offSet;
    
    
}
@property (nonatomic, retain) NKMRecord *record;
@property (nonatomic, assign) NKInputView *commentView;

@property (nonatomic, retain) WMMFeed *feed;

@property (nonatomic,assign) NSIndexPath *parseIndexPath;

@property (nonatomic, assign) UILabel *day;
@property (nonatomic, assign) UILabel *month;
@property (nonatomic, assign) UILabel *time;

@property (nonatomic, assign)id<WMFeedDetailDelegate>delegate;

+(id)feedDetailWithRecord:(NKMRecord*)theRecord;
+(id)feedDetailWithFeed:(WMMFeed*)feed;

@end
