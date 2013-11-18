//
//  WMConverstionViewController.h
//  WEIMI
//
//  Created by steve on 13-9-9.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//
@protocol WMConverstionViewControllerDelegate <NSObject>

@optional
-(void)updateMessageCount:(int)count;

@end


#import "WMTableViewController.h"
#import "WMIMService.h"
#import "WMChatCell.h"
#import "WMNotificationCenter.h"
#import <AudioToolbox/AudioToolbox.h>
#import "WMIMInputView.h"

#define MESSAGECOUNT 35

@interface WMConverstionViewController : WMTableViewController<UIGestureRecognizerDelegate,WMIMInputViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UIView   *showMoreView;
    IBOutlet UIButton *showMoreButton;
    BOOL hasMore;
    NSString *newMessageId;
    int newMessageCount;
    CGFloat startOffset,currentOffset;
    BOOL hasChangeStartOffset;
    NSTimer *timer;
}


@property (nonatomic, strong) UIView   *showMoreView;
@property (nonatomic, strong) UIButton *showMoreButton;

@property (nonatomic, strong) WMMUser *user;
@property (nonatomic, strong) WMMFeed *feed;
@property (nonatomic, strong) UILabel *day;
@property (nonatomic, strong) UILabel *month;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, unsafe_unretained) id<WMConverstionViewControllerDelegate>delegate;

+(id)conversationViewControllerForUser:(WMMUser *)user;
@end
