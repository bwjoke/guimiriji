//
//  WMSetAvatarViewController.m
//  WEIMI
//
//  Created by steve on 13-4-25.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMSetAvatarViewController.h"
#import "WMAppDelegate.h"

@interface WMSetAvatarViewController ()
{
    UIImageView *avatarView;
    UIImage *photo;
}
@end

@implementation WMSetAvatarViewController

-(void)dealloc
{
//    [avatarView release];
//    [photo release];
    [super dealloc];
}

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
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    UIButton *btn = [self addBackButton];
    [btn setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    btn = [self addRightButtonWithTitle:@"提交"];
    [btn setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    self.titleLabel.text = @"设置头像";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
    
    UIImageView *sepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 2)];
    sepLine.image = [UIImage imageNamed:@"register_sep"];
    [self.contentView addSubview:sepLine];
    [sepLine release];
    
    avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 70, 150, 151)];
    avatarView.image = [UIImage imageNamed:@"set_avatar_default"];
    [self.contentView addSubview:avatarView];
    [avatarView release];
    
    UIImageView *avatarBg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 70, 150, 151)];
    avatarBg.image = [UIImage imageNamed:@"set_avatar_bg"];
    [self.contentView addSubview:avatarBg];
    [avatarBg release];
    
    UIImageView *noticIcon = [[UIImageView alloc] initWithFrame:CGRectMake(54, 280, 32, 33)];
    noticIcon.image = [UIImage imageNamed:@"set_avatar_notic"];
    [self.contentView addSubview:noticIcon];
    [noticIcon release];
    
    for (int i=0; i<2; i++) {
        UIButton *addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(190, 70+i*81, 106, 71)];
        [self.contentView addSubview:addImageButton];
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(102, 281+i*20, 200, 11)];
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.font = [UIFont systemFontOfSize:10];
        descLabel.textColor = [UIColor colorWithHexString:@"#9a8874"];
        [self.contentView addSubview:descLabel];
        [descLabel release];
        switch (i) {
            case 0:
                [addImageButton setBackgroundImage:[UIImage imageNamed:@"btn_set_avatar_camara"] forState:UIControlStateNormal];
                [addImageButton setBackgroundImage:[UIImage imageNamed:@"btn_set_avatar_camara_click"] forState:UIControlStateHighlighted];
                [addImageButton addTarget:self action:@selector(addImageByCamera) forControlEvents:UIControlEventTouchUpInside];
                descLabel.text = @"放心，你在薇蜜上发布的点评、八卦，";
                break;
            case 1:
                [addImageButton setBackgroundImage:[UIImage imageNamed:@"btn_set_avatar_lib"] forState:UIControlStateNormal];
                [addImageButton setBackgroundImage:[UIImage imageNamed:@"btn_set_avatar_lib_click"] forState:UIControlStateHighlighted];
                [addImageButton addTarget:self action:@selector(addImageByLib) forControlEvents:UIControlEventTouchUpInside];
                descLabel.text = @"默认情况下都是匿名且不显示头像的～";
                break;
            default:
                break;
        }
        [addImageButton release];
    }
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 244, 320, 13)];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.textAlignment = UITextAlignmentCenter;
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.text = @"真实的头像方便你的闺蜜找到你";
    descLabel.textColor = [UIColor colorWithHexString:@"#9a8874"];
    [self.contentView addSubview:descLabel];
    [descLabel release];
    
    if (self.theAccount.type != NKAccountTypeTqq) {
        [self downLoadAvatar];
    }
}

-(void)addImageByCamera
{
    UIImagePickerController *imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentModalViewController:imagePickerController animated:YES];
}

-(void)addImageByLib
{
    UIImagePickerController *imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
	photo = [info objectForKey:UIImagePickerControllerEditedImage];
    [[WMMUser me] setAvatar:photo];
	avatarView.image = photo;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

-(void)downLoadAvatar{
    
    if (downloadingAvatar) {
        return;
    }
    downloadingAvatar = YES;
    
    NSString *finalString = _theAccount.headeUrl;
    
    //ASIHTTPRequest *request = [ASIHTTPRequest requestWithImageURL:[NSURL URNKithUnEncodeString:self.avatarPath]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithImageURL:[NSURL URLWithString:finalString]];
    request.delegate = self;
    //self.avatarRequest = request;
    [request setDidFinishSelector:@selector(downLoadAvatarFinish:)];
    [request setDidFailSelector:@selector(downLoadAvatarFailed:)];
    
    //[[NKSDK sharedSDK] addTicket:(NKTicket*)request];
    [request startAsynchronous];
    
}

-(void)downLoadAvatarFinish:(ASIHTTPRequest*)request{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        UIImage *avatarImage = [UIImage imageWithContentsOfFile:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]];
        if (avatarImage) {
            photo = avatarImage;
            avatarView.image = avatarImage;
            downloadingAvatar = NO;
        }
        
        //self.avatarRequest = nil;
    });
    
}

-(void)rightButtonClick:(id)sender
{
    NSData *imageData = UIImageJPEGRepresentation(photo, 0.5f);
    
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(uploadOK:) andFailedSelector:@selector(uoloadFailed:)];
    
    ProgressWith(@"正在上传头像");
    [[WMUserService sharedWMUserService] setUserAvatar:imageData andRequestDelegate:rd];
}

-(void)uploadOK:(NKRequest*)request
{
    //[[WMMUser me] setAvatar:photo];
    ProgressSuccess(@"头像上传成功");
    
    NKMAccount *theAccount = [[[NKMAccount alloc] init] autorelease];
    theAccount.accountType = _theAccount.type;
    theAccount.shouldAutoLogin = [NSNumber numberWithBool:YES];
    theAccount.oauthID = _theAccount.socialID;
    theAccount.accessToken = _theAccount.accessToken;
    
    [[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] setCurrentAccount:theAccount];
    
    [[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] loginFinish:request];
    
    [[NKNavigator sharedNavigator] showLoginOKView];
    
    [WMMAcount clean];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Get the system configure
    [[WMAppDelegate shareAppDelegate] getSysytemForbid];
}

@end
