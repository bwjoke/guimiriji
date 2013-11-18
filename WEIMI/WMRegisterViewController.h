//
//  WMRegisterViewController.h
//  WEIMI
//
//  Created by steve on 13-4-24.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMViewController.h"
#import "WMMAcount.h"
#import "WMAutocompleteTextField.h"
#import "WMAutocompleteManager.h"
#import "WMTableViewController.h"

@interface WMRegisterViewController : WMTableViewController<UITextFieldDelegate>
{
    WMAutocompleteTextField *email;
    UITextField *password;
}
@property(nonatomic,retain)NSString *weimiID;
@property(nonatomic,retain)WMMAcount *theAccount;
@end
