//
//  WMPersonalSettingViewController.m
//  WEIMI
//
//  Created by steve on 13-4-8.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMPersonalSettingViewController.h"
#import "WMSetNameViewController.h"
#import "WMSetMobileViewController.h"
#import "WMHoneyView.h"
#import "WMCustomLabel.h"

@interface WMPersonalSettingViewController ()
{
    UIImage *photo;
    UITableView *personalSettingTableView;
}

@property (nonatomic, assign) UITableView *settingTableView;

@end

@implementation WMPersonalSettingViewController

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
    self.titleLabel.text = @"个人设置";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    [self addBackButton];
    
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] autorelease] atIndex:0];
    [self addHeadShadow];
    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y + 44;
    UIView *mainView = [[[UIView alloc] initWithFrame:frame] autorelease];
    [self.view insertSubview:mainView atIndex:0];
    mainView.backgroundColor = [UIColor clearColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"mazhi_back"]];
    
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    
    personalSettingTableView = [[[UITableView alloc] initWithFrame:CGRectMake(15, 15+44, 290, self.view.frame.size.height-44-15) style:UITableViewStyleGrouped] autorelease];
    personalSettingTableView.backgroundView = nil;
    personalSettingTableView.backgroundColor = [UIColor clearColor];
    personalSettingTableView.delegate = self;
    personalSettingTableView.dataSource = self;
    [self.contentView addSubview:personalSettingTableView];
    
    
    //self.settingTableView = tableView;
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}


-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"WMPersonalSettingCellIdentifier";
    WMPersonalCell *cell = (WMPersonalCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[WMPersonalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.delegate = self;
    }
    [cell refreshWithIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 5) {
        return 20;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)] autorelease];
    if (section == 5) {
        WMCustomLabel *label = [[WMCustomLabel alloc] initWithFrame:CGRectMake(10, 0, 300, 18) font:[UIFont systemFontOfSize:10] textColor:[UIColor colorWithHexString:@"#A6937C"]];
        label.text = @"开启后，薇蜜将自动屏蔽23:00-08:00间的任何提醒。";
        //label.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:label];
    }
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 76;
    }
    return 42;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"相机", nil] autorelease];
            [actionSheet showInView:[NKNC view]];
            break;
        }
        case 1:{
            WMSetNameViewController *setNameViewController = [[[WMSetNameViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            [NKNC pushViewController:setNameViewController animated:YES];
            break;
        }
        case 2:{
            WMTopicNameViewController *setTopicNameController = [[[WMTopicNameViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            setTopicNameController.delegate = self;
            [NKNC pushViewController:setTopicNameController animated:YES];
            break;
        }
        case 3:{
            WMSetMobileViewController *setMobileViewController = [[[WMSetMobileViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            [NKNC pushViewController:setMobileViewController animated:YES];
            break;
        }
        case 4: {
            
            break;
        }
        case 6:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出当前登录账号吗？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [alert show];
            
            break;
        }
        default:
            break;
    }
}

-(void)switchValueChange:(UISwitch *)switchButton
{
    if ([switchButton isOn]) {
        //set password
        KKPasscodeViewController* vc = [[KKPasscodeViewController alloc] initWithNibName:nil
                                                                                  bundle:nil];
        vc.delegate = self;
        vc.mode = KKPasscodeModeSet;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [NKNC presentModalViewController:nav animated:YES];
    }else {
        //clear password
        if ([[KKPasscodeLock sharedLock] isPasscodeRequired]) {
            KKPasscodeViewController *vc = [[KKPasscodeViewController alloc] initWithNibName:nil bundle:nil];
            vc.mode = KKPasscodeModeEnter;
            vc.delegate = self;
            
            dispatch_async(dispatch_get_main_queue(),^ {
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBarHidden = YES;
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    nav.modalPresentationStyle = UIModalPresentationFormSheet;
                    nav.navigationBar.barStyle = UIBarStyleBlack;
                    nav.navigationBar.opaque = NO;
                } else {
                    nav.navigationBar.tintColor = NKNC.navigationBar.tintColor;
                    nav.navigationBar.translucent = NKNC.navigationBar.translucent;
                    nav.navigationBar.opaque = NKNC.navigationBar.opaque;
                    nav.navigationBar.barStyle = NKNC.navigationBar.barStyle;
                }
                
                [NKNC presentModalViewController:nav animated:YES];
            });
            
        }
        [KKKeychain setString:@"NO" forKey:@"passcode_on"];
    }
}

-(void)setNoNotification:(UISwitch *)switchButton
{
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(setDisturbOK:) andFailedSelector:@selector(setDisturbFailed:)];
    Progress(@"");
    if ([switchButton isOn]) {
        [[WMSystemService sharedWMSystemService] setNoDisturb:@"on" andRequestDelegate:rd];
    }else {
        [[WMSystemService sharedWMSystemService] setNoDisturb:@"off" andRequestDelegate:rd];
    }
}

-(void)setDisturbOK:(NKRequest *)request
{
    NSDictionary *dic = [request.originDic valueForKey:@"data"];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        if ([[dic valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            if ([[[dic valueForKey:@"data"] valueForKey:@"switch"] isEqualToString:@"on"]) {
                [[WMMUser me] setNotiSwitch:@"on"];
            }else {
                [[WMMUser me] setNotiSwitch:@"off"];
            }
        }
    }
    ProgressSuccess(@"设置成功");
}

-(void)setDisturbFailed:(NKRequest *)request
{
    ProgressSuccess(@"设置失败");
}

-(void)didSettingsChanged:(KKPasscodeViewController *)viewController
{
    //[self.showTableView reloadData];
}

-(void)didCancle
{
    [personalSettingTableView reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self logout:self];
    }
}

-(void)logout:(id)sender{
    [WMHoneyView clean];
    [[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] logOut];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            default:
                return;
        }
    } else {
        if (buttonIndex == 2) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    UIImagePickerController *imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
	photo = [info objectForKey:UIImagePickerControllerEditedImage];
    [[WMMUser me] setAvatar:photo];
	//[photoButton setImage:self.photo forState:UIControlStateNormal];
    NSData *imageData = UIImageJPEGRepresentation(photo, 0.5f);

    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(uploadOK:) andFailedSelector:@selector(uoloadFailed:)];
    
    ProgressWith(@"正在上传头像");
    [[WMUserService sharedWMUserService] setUserAvatar:imageData andRequestDelegate:rd];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

-(void)uploadOK:(NKRequest*)request
{
    //[[WMMUser me] setAvatar:photo];
    ProgressSuccess(@"头像上传成功");
}

-(void)uoloadFailed:(NKRequest*)request
{
    ProgressErrorDefault;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WMTopicNameViewDelegate

- (void)updateTopicnickSuccess {
    [self.settingTableView reloadData];
}

@end
