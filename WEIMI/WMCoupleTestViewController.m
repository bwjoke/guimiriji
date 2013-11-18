//
//  WMCoupleTestViewController.m
//  WEIMI
//
//  Created by steve on 13-10-11.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMCoupleTestViewController.h"
#import "WMCoupleRateService.h"
#import "WMCoupleTestShareViewController.h"

@interface WMCoupleTestViewController ()
{
    UIImageView *womenAvatar,*manAvatar;
    UIImage *womenImage,*manImage;
    float score;
}
@end

@implementation WMCoupleTestViewController

#define degreesToRadians(x) (M_PI*(x)/180.0)
#define ADD_MAN_PHOTO 13101101
#define ADD_WOMEN_PHOTO 13101102

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
    self.titleLabel.text = @"夫妻相大测试";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    [self addBackButton];
    //[self addRightButtonWithTitle:@"下一步"];
    
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    
    [self.headBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] atIndex:0];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, SCREEN_HEIGHT-44)];
    if (SCREEN_HEIGHT==480) {
        bgImageView.image = [UIImage imageNamed:@"couple_bg_i4"];
    }else {
        bgImageView.image = [UIImage imageNamed:@"couple_bg_i5"];
    }
    [self.contentView addSubview:bgImageView];
    
    womenAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(20, 205, 120, 120)];
    womenAvatar.backgroundColor = [UIColor clearColor];
    womenAvatar.layer.cornerRadius = 6.0f;
    womenAvatar.contentMode = UIViewContentModeScaleAspectFill;
    womenAvatar.transform = CGAffineTransformMakeRotation(degreesToRadians(-15));
    [self.contentView addSubview:womenAvatar];
    
    manAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(180, 205, 120, 120)];
    manAvatar.transform = CGAffineTransformMakeRotation(degreesToRadians(15));
    manAvatar.backgroundColor = [UIColor clearColor];
    manAvatar.layer.cornerRadius = 6.0f;
    manAvatar.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:manAvatar];
    
    UIImageView *catImageView = [[UIImageView alloc] initWithFrame:CGRectMake(42, 273, 236, 93)];
    catImageView.image = [UIImage imageNamed:@"cat_image"];
    [self.contentView addSubview:catImageView];
    
    UIButton *addManPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(173, 378, 110, 42)];
    [addManPhotoButton setImage:[UIImage imageNamed:@"btn_add_man_photo_down"] forState:UIControlStateHighlighted];
    [addManPhotoButton setImage:[UIImage imageNamed:@"btn_add_man_photo"] forState:UIControlStateNormal];
    [addManPhotoButton addTarget:self action:@selector(addManPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addManPhotoButton];
    
    UIButton *addWomenPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(41, 378, 110, 42)];
    [addWomenPhotoButton setImage:[UIImage imageNamed:@"btn_add_women_photo_down"] forState:UIControlStateHighlighted];
    [addWomenPhotoButton setImage:[UIImage imageNamed:@"btn_add_women_photo"] forState:UIControlStateNormal];
    [addWomenPhotoButton addTarget:self action:@selector(addWomenPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addWomenPhotoButton];
}

//- (void)goBack:(id)sender {
//    [super goBack:sender];
//    
//    if (self.goBackAction) {
//        self.goBackAction();
//    }
//}

-(void)resetView
{
    [self.nkRightButton removeFromSuperview];
    self.nkRightButton = nil;
    manImage = nil;
    womenImage = nil;
    manAvatar.image = nil;
    womenAvatar.image = nil;
}

-(void)addManPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"相机", nil];
    actionSheet.tag = ADD_MAN_PHOTO;
    [actionSheet showInView:[NKNC view]];
}

-(void)addWomenPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"相机", nil];
    actionSheet.tag = ADD_WOMEN_PHOTO;
    [actionSheet showInView:[NKNC view]];
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
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    imagePickerController.view.tag = actionSheet.tag;
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
	//photo = [info objectForKey:UIImagePickerControllerEditedImage];
    if (picker.view.tag == ADD_WOMEN_PHOTO) {
        womenImage = [info objectForKey:UIImagePickerControllerEditedImage];
        womenAvatar.image = womenImage;
        womenAvatar.layer.cornerRadius = 6.0f;
        womenAvatar.layer.masksToBounds = YES;
    }else {
        manImage = [info objectForKey:UIImagePickerControllerEditedImage];
        manAvatar.image = manImage;
        manAvatar.layer.cornerRadius = 6.0f;
        manAvatar.layer.masksToBounds =YES;
    }
    if (womenAvatar.image && manAvatar.image) {
        [self uploadAvatar];
        if (!self.nkRightButton) {
            [self addRightButtonWithTitle:@"下一步"];
        }
    
    }
    
}

-(void)uploadAvatar
{
    ProgressWith(@"正在计算夫妻相...");
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(uploadOK:) andFailedSelector:@selector(uoloadFailed:)];
    NSData *manAvatarData = UIImageJPEGRepresentation(manImage, 0.5f);
    NSData *womenAvatarData = UIImageJPEGRepresentation(womenImage, 0.5f);
    [[WMCoupleRateService sharedWMCoupleRateService] rateCouple:manAvatarData women:womenAvatarData andRequestDelegate:rd];
}

-(void)uploadOK:(NKRequest *)request
{
    ProgressHide;
    NSString *scoreStr = [[request.originDic valueForKey:@"data"] valueForKey:@"score"];
    score = [scoreStr floatValue];
    if (scoreStr) {
        WMCoupleTestShareViewController *vc = [[WMCoupleTestShareViewController alloc] init];
        vc.manAvatar = manImage;
        vc.womanAvatar = womenImage;
        vc.score = score;
        NSString *remark = [request.originDic valueForKeyPath:@"data.comment"];
        if ([remark length]) {
            vc.remark = remark;
        }
        vc.goBackAction = ^(){
            [self resetView];
        };
        [NKNC pushViewController:vc animated:YES];
    }
    
}

-(void)uoloadFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightButtonClick:(id)sender {
    [self uploadAvatar];
}

@end
