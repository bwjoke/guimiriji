//
//  WMAddMiyuViewController.h
//  WEIMI
//
//  Created by steve on 13-4-16.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"

@protocol WMAddMiyuViewControllerDelegate <NSObject>

@optional
-(void)tellReloadData;

@end

@interface WMAddMiyuViewController : WMTableViewController <UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) WMMMan *man;

@property (nonatomic, retain) NSMutableArray *userFriends;

@property (nonatomic, assign) NKTextViewWithPlaceholder *textField;

@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) UIImage  *image;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) UIView         *preView;
@property (nonatomic, unsafe_unretained) UIView *audioPreview;
@property (nonatomic, assign) NKKVOImageView *imageView;
@property (nonatomic, unsafe_unretained) UIButton *pickButton, *moreButton;

@property (nonatomic, assign)id<WMAddMiyuViewControllerDelegate>delegate;

@end
