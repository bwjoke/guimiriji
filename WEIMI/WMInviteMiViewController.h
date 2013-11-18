//
//  WMInviteMiViewController.h
//  WEIMI
//
//  Created by King on 11/19/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>

@protocol WMInviteDelegate;

@interface WMInviteMiViewController : WMViewController<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate>
{
    

}

@property (nonatomic, assign) IBOutlet UITextField *email;
@property (nonatomic, assign) IBOutlet UITextField *phone;
@property (nonatomic, assign) id <WMInviteDelegate> delegate;

-(IBAction)invite:(id)sender;

@end


@protocol WMInviteDelegate <NSObject>

@optional
-(void)inviteController:(WMInviteMiViewController*)controller didInviteUser:(NKMUser*)user;

@end


