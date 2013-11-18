//
//  WMRegitserInviteViewController.h
//  WEIMI
//
//  Created by steve on 13-4-24.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMMAcount.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>

@interface WMRegitserInviteViewController : WMTableViewController<ABPeoplePickerNavigationControllerDelegate>
{
    UITextField *myNumber,*honeyNumber;
}

@property(nonatomic,assign)WMMAcount *theAccount;
@property(nonatomic,copy)NSString *uid;
@end
