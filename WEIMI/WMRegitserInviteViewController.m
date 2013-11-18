//
//  WMRegitserInviteViewController.m
//  WEIMI
//
//  Created by steve on 13-4-24.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMRegitserInviteViewController.h"
#import "WMSetAvatarViewController.h"
#import "RegexKitLite.h"
#import "WMAppDelegate.h"

@interface WMRegitserInviteViewController ()

@end

@implementation WMRegitserInviteViewController

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
	// Do any additional setup after loading the view.
    UIButton *btn = [self addBackButton];
    [btn setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    btn = [self addRightButtonWithTitle:@"下一步"];
    [btn setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    self.titleLabel.text = @"邀请闺蜜";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
    
    UIImageView *sepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 2)];
    sepLine.image = [UIImage imageNamed:@"register_sep"];
    [self.contentView addSubview:sepLine];
    [sepLine release];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 54, 228, 13)];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.text = @"填写你和最亲闺蜜的手机号，一起免费开通";
    descLabel.textColor = [UIColor colorWithHexString:@"#9a8874"];
    [self.contentView addSubview:descLabel];
    [descLabel release];
    
    UILabel *meLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 80, 228, 13)];
    meLabel.backgroundColor = [UIColor clearColor];
    meLabel.font = [UIFont systemFontOfSize:12];
    meLabel.text = @"我的手机号码";
    meLabel.textColor = [UIColor colorWithHexString:@"#9a8874"];
    [self.contentView addSubview:meLabel];
    [meLabel release];
    
    UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, 80, 228, 13)];
    starLabel.backgroundColor = [UIColor clearColor];
    starLabel.font = [UIFont systemFontOfSize:12];
    starLabel.text = @"*";
    starLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:starLabel];
    [starLabel release];
    
    myNumber = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 210, 41)];
    myNumber.font = [UIFont systemFontOfSize:14];
    myNumber.placeholder = @"手机号是用来互相加为闺蜜的哦";
    [myNumber setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    myNumber.textColor = [UIColor colorWithHexString:@"bfb2a3"];
    
    honeyNumber = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 210, 41)];
    honeyNumber.placeholder = @"请输入她的手机号";
    honeyNumber.font = [UIFont systemFontOfSize:14];
    [honeyNumber setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    honeyNumber.textColor = [UIColor colorWithHexString:@"bfb2a3"];
    
    
    for (int i=0; i<2; i++) {
        UIImageView *inputBg = [[UIImageView alloc] initWithFrame:CGRectMake(40, 100+i*74, 240, 41)];
        inputBg.image = [UIImage imageNamed:@"register_input"];
        inputBg.userInteractionEnabled = YES;
        [self.contentView addSubview:inputBg];
        [inputBg release];
        switch (i) {
            case 0:
                [inputBg addSubview:myNumber];
                myNumber.keyboardType = UIKeyboardTypePhonePad;
                [myNumber becomeFirstResponder];
                break;
            case 1:
                [inputBg addSubview:honeyNumber];
                honeyNumber.keyboardType = UIKeyboardTypePhonePad;
                break;
            default:
                break;
        }
    }
    [myNumber release];
    [honeyNumber release];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addButton.center = CGPointMake(260, 194);
    addButton.userInteractionEnabled = YES;
    [addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addButton];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 154, 320, 13)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.text = @"闺蜜的手机号码 (选填)";
    textLabel.textColor = [UIColor colorWithHexString:@"#9a8874"];
    [self.contentView addSubview:textLabel];
    [textLabel release];
    
    UILabel *addMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 228, 228, 13)];
    addMoreLabel.backgroundColor = [UIColor clearColor];
    addMoreLabel.font = [UIFont systemFontOfSize:12];
    addMoreLabel.text = @"注册成功后还能邀请3位";
    addMoreLabel.textColor = [UIColor colorWithHexString:@"#9a8874"];
    [self.contentView addSubview:addMoreLabel];
    [addMoreLabel release];
}

-(void)goBack:(id)sender
{
    [[NKSocial social] removeSocial];
    [NKNC popViewControllerAnimated:YES];
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
        //phone = ( NSString *)ABMultiValueCopyValueAtIndex(phoneNumbers, identifier);
    }
    NSLog(@"retrieved number: %@", phone);
    
    //retrieve first and last name
    NSString* firstName = ( NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString* lastName = ( NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSLog(@"retrieved first name: %@", firstName);
    NSLog(@"retrieve last name: %@", lastName);
    
    phone = [[phone description] stringByReplacingOccurrencesOfRegex:@"[^\\d]" withString:@""];
    
    honeyNumber.text = phone;
    
    [NKNC dismissModalViewControllerAnimated:YES];
    return NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [myNumber resignFirstResponder];
    [honeyNumber resignFirstResponder];
}

- (void)animateView:(CGFloat)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    rect.origin.y = [[UIScreen mainScreen] bounds].size.height-216-105 -1.0f * tag ;
    rect.size.height = 42;
    self.contentView.frame = rect;
    [UIView commitAnimations];
}

-(void)rightButtonClick:(id)sender
{
    NSString *mobileNumber = [[[myNumber text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    NSString *honeyNum = [[[honeyNumber text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    if ([mobileNumber length]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"我的手机号是必填的哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else if ((mobileNumber.length > 0 && ![self isValidateMobile:mobileNumber]) || (honeyNum.length > 0 && ![self isValidateMobile:honeyNum])) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"手机号只能填写11位或8位数字哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    _theAccount.mobile = mobileNumber;
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(loginOK:) andFailedSelector:@selector(loginFailed:)];
    [[NKUserService sharedNKUserService] socialReginvite:mobileNumber uid:_uid friendAcount:honeyNum andRequestDelegate:rd];
    Progress(@"正在提交");
}

-(BOOL) isValidateMobile:(NSString *)mobile {
    if ([mobile isMatchedByRegex:@"^\\d{8,11}$"]) {
        return YES;
    }
    return NO;
}

-(void)loginOK:(NKRequest *)request
{
    WMSetAvatarViewController *setAvatarViewController = [[[WMSetAvatarViewController alloc] init] autorelease];
    setAvatarViewController.theAccount = _theAccount;
    [NKNC pushViewController:setAvatarViewController animated:YES];
    ProgressHide;
}

-(void)loginFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Get the system configure
    [[WMAppDelegate shareAppDelegate] getSysytemForbid];
}

@end
