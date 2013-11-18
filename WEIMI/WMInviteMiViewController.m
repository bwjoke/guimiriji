//
//  WMInviteMiViewController.m
//  WEIMI
//
//  Created by King on 11/19/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMInviteMiViewController.h"
#import "RegexKitLite.h"

@interface WMInviteMiViewController ()

@end

@implementation WMInviteMiViewController

@synthesize email;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.headBar.hidden = YES;
    
    UIImageView *topShadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_top"]] autorelease];
    [self.view addSubview:topShadow];
    CGRect topShadowFrame = topShadow.frame;
    topShadowFrame.origin.y = -2;
    topShadow.frame = topShadowFrame;
    
    UIImageView *phoneBg = [[[UIImageView alloc] initWithFrame:CGRectMake(40, 28, 240, 40)] autorelease];
    phoneBg.image = [[UIImage imageNamed:@"miyu_input"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    phoneBg.userInteractionEnabled = YES;
    [self.contentView addSubview:phoneBg];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addButton.center = CGPointMake(260, 48);
    addButton.userInteractionEnabled = YES;
    [addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addButton];
    
    self.phone = [[[UITextField alloc] initWithFrame:CGRectMake(16, 12, 208, 18)] autorelease];
    self.phone.placeholder = @"闺蜜的手机号码";
    self.phone.font = [UIFont systemFontOfSize:14.0];
    self.phone.tag = 1;
    self.phone.textColor = [UIColor colorWithHexString:@"#cac0b4"];
    self.phone.keyboardType = UIKeyboardTypePhonePad;
    self.phone.delegate = self;
    
    
    
//    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addContact:)] autorelease];
//    [self.phone addGestureRecognizer:tap];
    
    [phoneBg addSubview:self.phone];

    
    UIButton *doneButton = [[[UIButton alloc] initWithFrame:CGRectMake(40, 93, 240, 40)] autorelease];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"btn_invite"] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"btn_invite_click"] forState:UIControlStateHighlighted];
    [doneButton setTitle:@"邀请她" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor colorWithHexString:@"7e6b5a"] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    [doneButton addTarget:self action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    
    for (int i=0; i<3; i++) {
        UILabel *helpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 159+i*14, 320, 12)];
        helpLabel.backgroundColor = [UIColor clearColor];
        helpLabel.textAlignment = UITextAlignmentCenter;
        helpLabel.textColor = [UIColor colorWithHexString:@"#7e6b5a"];
        helpLabel.font = [UIFont systemFontOfSize:10];
        switch (i) {
            case 0:
                helpLabel.text = @"邀请加为闺蜜后，可以互相查看彼此";
                break;
            case 1:
                helpLabel.text = @"关注的男纸，分享蜜语心情小秘密";
                break;
            case 2:
                helpLabel.text = @"还有聊天以及更多互动功能";
                break;
            default:
                break;
        }
        [self.view addSubview:helpLabel];
        [helpLabel release];
    }
    
    
}

- (IBAction)addContact:(UIButton *)sender {
    NSLog(@"adding contact");
    ABPeoplePickerNavigationController *picker = [[[ABPeoplePickerNavigationController alloc] init] autorelease];
    picker.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
    picker.peoplePickerDelegate = self;
    [NKNC presentModalViewController:picker animated:YES];
    
}

- (void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [NKNC dismissModalViewControllerAnimated:YES];
}

- (BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    NSLog(@"got person record");
    return YES;
}

- (BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    //retrieve number
    NSLog(@"tapped number");
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, property);
    NSString *phone = nil;
    if ((ABMultiValueGetCount(phoneNumbers) > 0)) {
        phone = ( NSString *)ABMultiValueCopyValueAtIndex(phoneNumbers, identifier);
    } else {
        phone = @"[None]";
    }
    NSLog(@"retrieved number: %@", phone);
    
    //retrieve first and last name
    NSString* firstName = ( NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString* lastName = ( NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSLog(@"retrieved first name: %@", firstName);
    NSLog(@"retrieve last name: %@", lastName);
    
    phone = [[phone description] stringByReplacingOccurrencesOfRegex:@"[^\\d]" withString:@""];
    
    self.phone.text = phone;
    
    [NKNC dismissModalViewControllerAnimated:YES];
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.email resignFirstResponder];
    [self invite:self];
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self animateView:0];
    [self.email resignFirstResponder];
    [self.phone resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Invite

-(IBAction)invite:(id)sender{
    
    if (![self.email.text length] && ![self.phone.text length]) {
        return;
    }
    Progress(@"正在邀请");
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(inviteOK:) andFailedSelector:@selector(inviteFailed:)];

    [[WMUserService sharedWMUserService] inviteUserWithAccount:[self.email.text length]>0?self.email.text:self.phone.text andRequestDelegate:rd];
}

-(void)inviteOK:(NKRequest*)request{

    ProgressSuccess(@"邀请成功");
    if ([delegate respondsToSelector:@selector(inviteController:didInviteUser:)]) {
        [delegate inviteController:self didInviteUser:[request.results lastObject]];
    }
    
    
}
-(void)inviteFailed:(NKRequest*)request{
    
    ProgressErrorDefault;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    NSUInteger tag = [textField tag];
//    [self animateView:tag];
}

- (void)animateView:(CGFloat)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (tag>= 1) {
        rect.origin.y = -30.0f * tag ;
    } else {
        rect.origin.y = 0;
    }
    self.contentView.frame = rect;
    [UIView commitAnimations];
}

@end
