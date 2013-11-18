//
//  WMNewTopicViewController.h
//  WEIMI
//
//  Created by ZUO on 7/1/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"

@protocol WMNewTopicViewDelegate <NSObject>

@optional
- (void)newTopicDidSuccess;

@end

@interface WMNewTopicViewController : WMTableViewController <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, unsafe_unretained) id <WMNewTopicViewDelegate> delegate;

@property (nonatomic, retain) id boardID;

@property (nonatomic, unsafe_unretained) UIButton *pickButton,*moreButton;
@property (nonatomic, unsafe_unretained) UIView *preView;
@property (nonatomic, unsafe_unretained) NKKVOImageView *imageView;
@property (nonatomic, retain) UIImage  *image;

@property (nonatomic, unsafe_unretained) NKInputView *commentView;

@end
