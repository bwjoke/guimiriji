//
//  WMReplyTopicViewController.h
//  WEIMI
//
//  Created by ZUO on 7/3/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"

@protocol WMReplyTopicViewDelegate <NSObject>

@optional
- (void)replyTopicDidSuccess;

@end

@interface WMReplyTopicViewController : WMTableViewController <UITextViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) id model;
@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic, assign) id <WMReplyTopicViewDelegate> delegate;

@property (nonatomic, assign) UIButton *pickButton,*moreButton;
@property (nonatomic, assign) UIView *preView;
@property (nonatomic, assign) NKKVOImageView *imageView;
@property (nonatomic, retain) UIImage  *image;

@property (nonatomic, assign) NKInputView *commentView;

@end
