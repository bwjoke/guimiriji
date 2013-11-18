//
//  WMPersonalSettingViewController.h
//  WEIMI
//
//  Created by steve on 13-4-8.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMTopicNameViewController.h"
#import "WMPersonalCell.h"
#import "KKPasscodeViewController.h"
#import "KKPasscodeLock.h"
#import "KKKeychain.h"

@interface WMPersonalSettingViewController : WMTableViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate, WMTopicNameViewDelegate,WMPersonalCellDelegate,KKPasscodeViewControllerDelegate>

@end
