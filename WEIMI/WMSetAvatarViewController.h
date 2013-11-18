//
//  WMSetAvatarViewController.h
//  WEIMI
//
//  Created by steve on 13-4-25.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMMAcount.h"

@interface WMSetAvatarViewController : WMTableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL downloadingAvatar;
}
@property(nonatomic,assign)WMMAcount *theAccount;
@end
