//
//  WMCreateManViewController.h
//  WEIMI
//
//  Created by King on 4/17/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMChooseSchoolViewController.h"
#import "MonthAndDayPickerViewController.h"
#import "RennSDK/RennSDK.h"

@interface WMCreateManViewController : WMTableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, WMChooseSchoolViewDelegate, RenrenDelegate, MonthAndDayPickerViewDelegate>

@property (nonatomic, retain) WMMMan *man;

@property (nonatomic, assign) UIView         *preView;
@property (nonatomic, assign) NKKVOImageView *imageView;
@property (nonatomic, assign) UIButton *pickButton;

@property (nonatomic, assign) UITextField *name;
@property (nonatomic, assign) UITextField *weiboName;

@property (nonatomic, assign) UIImageView *tagsBack;
@property (nonatomic, assign) UIButton *tags;
@property (nonatomic, assign) UIButton *birthday;
@property (nonatomic, assign) UIButton *school;
@property (nonatomic, assign) UIButton *relationship;

@property (nonatomic, assign) UIActionSheet *dateSheet;
@property (nonatomic, assign) UIDatePicker  *datePicker;

@property (nonatomic) BOOL isFromUniversity;

@property (nonatomic, copy) void(^viewFinishLoad)(WMCreateManViewController *viewController);

@property (nonatomic, assign) BOOL isManAvatarChanged;

-(void)setUIForData;
-(void)addOtherInfor;

@end
