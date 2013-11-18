//
//  
//  WEIMI
//
//  Created by King on 4/8/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"

@class WMRecordPlugin;

@interface WMAddBaoliaoViewController : WMTableViewController<NKSegmentControlDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>


@property (nonatomic, retain) WMMMan *man;
@property (nonatomic, assign) NKSegmentControl *seg;

@property (nonatomic, assign) NKTextViewWithPlaceholder *textField;

@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) UIImage  *image;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) UIView         *preView;
@property (nonatomic, assign) NKKVOImageView *imageView;
@property (nonatomic, unsafe_unretained) UIButton *pickButton,*askButtn;

@property (nonatomic, unsafe_unretained) WMRecordPlugin *recordButton;

@property (nonatomic, assign) UILabel *notice;

@property (nonatomic, assign) WMTableViewController *father;


@end
