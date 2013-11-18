//
//  WMCreateManViewController.m
//  WEIMI
//
//  Created by King on 4/17/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMCreateManViewController.h"
#import "UIImage+Resize.h"
#import "WMAddRateViewController.h"
#import "WMDafenViewController.h"
#import "WMCreateTagViewController.h"
#import "WMTagLabel.h"
#import "RegexKitLite.h"

enum tWMCreateManViewTagForDetailButton {
    kWMCreateManViewTagForDetailButtonRightArrow = 1
};

@interface WMCreateManViewController ()

@property (nonatomic, retain) MonthAndDayPickerViewController *monthAndDayPickerVC;

// For KVO
@property (nonatomic, copy) NSString *horoscope;

@end

@implementation WMCreateManViewController {
    UIScrollView *_scrollView;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [_man release];
    [_monthAndDayPickerVC release];
    _imageView.target = nil;
    [_horoscope release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.man = [[[WMMMan alloc] init] autorelease];
        self.man.tags = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}


#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)note{
    
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    UIView *firstResponder = nil;
    if ([self.name isFirstResponder]) {
        firstResponder = self.name;
    }
    else if ([self.weiboName isFirstResponder]){
        firstResponder = self.weiboName;
    }
    else
        return;
    
    CGRect frameInWindow = [firstResponder convertRect:firstResponder.bounds toView:self.view];
    CGFloat lastY = frameInWindow.origin.y + frameInWindow.size.height;
    
    CGRect frame = self.view.frame;
    frame.origin.y = MIN(0, self.view.bounds.size.height - (lastY+keyboardBounds.size.height+10)) ;
    [UIView animateWithDuration:[duration doubleValue] delay:0 options:UIViewAnimationOptionBeginFromCurrentState|[curve intValue] animations:^{
        self.view.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)keyboardWillHide:(NSNotification *)note{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    
    [UIView animateWithDuration:[duration doubleValue] delay:0 options:UIViewAnimationOptionBeginFromCurrentState|[curve intValue] animations:^{
        self.view.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}


-(void)panMoved:(UIPanGestureRecognizer*)gest{
    
   // [_textField resignFirstResponder];
    
    [_name resignFirstResponder];
    [_weiboName resignFirstResponder];
    
}

-(void)rightButtonClick:(id)sender{
    
    if (!self.man.avatar) {
        [_name resignFirstResponder];
        [_weiboName resignFirstResponder];
        ProgressFailedWith(@"请设置他的头像");
        return;
    }
    
    if (![self.man.name length]) {
        [_name resignFirstResponder];
        [_weiboName resignFirstResponder];
        ProgressFailedWith(@"请设置他的姓名");
        return;
    }
    
    WMDafenViewController *addRate = [[WMDafenViewController alloc] init];
    if (_isFromUniversity) {
        addRate.isFromUniversity = _isFromUniversity;
    }
    addRate.man = self.man;
    [self.navigationController pushViewController:addRate animated:YES];
    [addRate release];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMoved:)];
    [self.view addGestureRecognizer:pan];
    [pan release];
    
    CGRect frame = self.view.bounds;
    frame.size.height -= 50.0f;
    frame.origin.y = 50.0f;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    [scrollView release];
    
    UIButton *tap = [[UIButton alloc] initWithFrame:_scrollView.bounds];
    [_scrollView insertSubview:tap atIndex:0];
    [tap addTarget:self action:@selector(panMoved:) forControlEvents:UIControlEventTouchUpInside];
    [tap release];
    
    
    
    // Do any additional setup after loading the view from its nib.
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    [self addBackButton];
    [self addRightButtonWithTitle:@"下一步"];
    CGRect rightButtonFrame = nkRightButton.frame;
    rightButtonFrame.size.width += 10;
    rightButtonFrame.origin.x -= 10;
    nkRightButton.frame = rightButtonFrame;
    
    [self setShouldAutoRefreshData:NO];
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    
    self.titleLabel.text = @"他的基本信息";
    
    UIImageView *mazhi = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mazhi_back"]] autorelease];
    [self.contentView addSubview:mazhi];
    mazhi.frame = CGRectMake(0, 44, mazhi.frame.size.width, mazhi.frame.size.height);
    
    [self addImagePickView];
    
    [self addOtherInfor];
    
    
    [self setUIForData];
    
    self.monthAndDayPickerVC = [[[MonthAndDayPickerViewController alloc] init] autorelease];
    self.monthAndDayPickerVC.delegate = self;
    
    // Change the frame of self.monthAndDayPickerVC
    frame = self.monthAndDayPickerVC.view.frame;
    frame.origin.y = 44.0f;
    self.monthAndDayPickerVC.view.frame = frame;
    
    [self getRenrenUserInfo];
    
    [self initializeKVOValue];
    
    if (self.viewFinishLoad) {
        self.viewFinishLoad(self);
    }
    
}

- (void)getRenrenUserInfo {
    if ((self.man.university == nil || self.man.birth == nil) && [[self.man flatform] isEqualToString:@"renren"]) {
        [self getManUserInfo:self.man];
    }
}

- (void)initializeKVOValue {
    // Initialize the KVOLabel value
    
    NSDictionary *birth = [self validManBirth];
    
    if (birth) {
        NSInteger month = [birth[@"month"] integerValue];
        NSInteger day = [birth[@"day"] integerValue];
        
        self.horoscope = [self getHoroscopeByMonth:month andDay:day];
    } else {
        // Initialize at
        self.horoscope = @"摩羯座";
    }
}

- (void)getManUserInfo:(WMMMan *)man {
    Progress(@"获取用户信息");
    
    GetUserParam *param = [[GetUserParam alloc] init];
    param.userId = [man.flatformId description];
    [RennClient sendAsynRequest:param delegate:self];
}

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response {
    ProgressHide;
    
    NSArray *education = response[@"education"];
    
    if (education && [education isKindOfClass:[NSArray class]] && education.count > 0) {
        id lastUniversity = nil;
        
        // Get the last university
        for (NSDictionary *school in education) {
            if ([school[@"educationBackground"] isEqualToString:@"COLLEGE"]) {
                if (lastUniversity == nil || [school[@"year"] integerValue] > [lastUniversity[@"year"] integerValue]) {
                    lastUniversity = school;
                }
            }
        }
        
        if (lastUniversity != nil) {
            [self.school setTitle:lastUniversity[@"name"] forState:UIControlStateNormal];
            self.man.university = @{@"name": lastUniversity[@"name"]};
        }
    }
    
    NSDictionary *basicInformation = response[@"basicInformation"];
    static NSString *dateFormatString = @"^\\d+\\-(\\d+)\\-(\\d+)$";
    
    if (basicInformation && [basicInformation isKindOfClass:[NSDictionary class]] && basicInformation[@"birthday"] != nil) {
        NSString *birthdayString = basicInformation[@"birthday"];
        birthdayString = [birthdayString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([birthdayString isMatchedByRegex:dateFormatString]) {
            NSArray *component = [birthdayString captureComponentsMatchedByRegex:dateFormatString];
            if (component.count == 3) {
                NSInteger month = [component[1] integerValue];
                NSInteger day = [component[2] integerValue];
                
                if (month > 0 && month <= 12 && day > 0 && day <= 31) {
                    self.man.birth = @{@"month": @(month), @"day": @(day)};
                    [self setUIForData];
                }
            }
        }
    }
    
    [self setUIForData];
}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error {
    //ProgressFailedWith(error.localizedDescription);
    ProgressHide;
}

-(void)addOtherInfor{
    
    CGFloat startY = 61;
    
    UIImageView *textBack = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"wm_input_back"] resizeImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]] autorelease];
    [_scrollView addSubview:textBack];
    textBack.frame = CGRectMake(15, startY+59, textBack.frame.size.width, 37);
    
    self.name = [[[UITextField alloc] initWithFrame:CGRectMake(25, textBack.frame.origin.y, textBack.frame.size.width-20, textBack.frame.size.height)] autorelease];
    [_scrollView addSubview:_name];
    _name.placeholder = @"姓名(必填)";
    _name.font = [UIFont systemFontOfSize:15];
    _name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _name.delegate = self;
    
    textBack = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"wm_input_back"] resizeImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]] autorelease];
    [_scrollView addSubview:textBack];
    textBack.frame = CGRectMake(15, startY+105, textBack.frame.size.width, 37);
    
    self.weiboName = [[[UITextField alloc] initWithFrame:CGRectMake(25, textBack.frame.origin.y, textBack.frame.size.width-20, textBack.frame.size.height)] autorelease];
    [_scrollView addSubview:_weiboName];
    _weiboName.placeholder = @"微博昵称(选填)";
    _weiboName.font = [UIFont systemFontOfSize:15];
    _weiboName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _weiboName.delegate = self;
    
    self.tagsBack = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"man_add_tag_back"] resizeImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]] autorelease];
    
    self.tags = [self detailButtonWithFrame:CGRectMake(13.5, startY+104+46, _tagsBack.frame.size.width, 44)];
    [self.tags addTarget:self action:@selector(addTags) forControlEvents:UIControlEventTouchUpInside];
    
    self.birthday = [self detailButtonWithFrame:CGRectMake(13.5, startY+104+46+51, _tagsBack.frame.size.width, 44)];
    [self.birthday addTarget:self action:@selector(birthdayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.school = [self detailButtonWithFrame:CGRectMake(13.5, startY+104+46+51+51, _tagsBack.frame.size.width, 44)];
    [self.school addTarget:self action:@selector(schoolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.relationship = [self detailButtonWithFrame:CGRectMake(13.5, startY+104+46+51+51+51, _tagsBack.frame.size.width, 44)];
//    [self.relationship addTarget:self action:@selector(changeRelationship:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)detailButtonWithFrame:(CGRect)frame {
    UIButton *button = [[[UIButton alloc] initWithFrame:frame] autorelease];
    [button setBackgroundImage:[[UIImage imageNamed:@"man_add_tag_back"] resizeImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    UIImageView *rightArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right.png"]] autorelease];
    [button addSubview:rightArrow];
    
    rightArrow.tag = kWMCreateManViewTagForDetailButtonRightArrow;
    
    rightArrow.center = CGPointMake(frame.size.width - rightArrow.image.size.width - 5.0f, frame.size.height / 2.0f);
    
    [_scrollView addSubview:button];
    
    return button;
}

- (void)layoutSubViews {
    // Layout from self.tags
    CGFloat gap = 10.0f;
    CGFloat offsetY = _tags.frame.origin.y + _tags.frame.size.height;
    
    NSArray *views = @[
        _birthday,
        _school,
//        _relationship
    ];
    
    for (UIView *view in views) {
        offsetY += gap;
        CGRect frame = view.frame;
        frame.origin.y = offsetY;
        view.frame = frame;
        offsetY += frame.size.height;
    }
    
    offsetY += gap;
    
    CGSize size = _scrollView.contentSize;
    size.height = offsetY;
    _scrollView.contentSize = size;
}

-(void)birthdayButtonClick:(id)sender{
    
    [self pickDate:nil];
}


-(void)schoolButtonClick:(id)sender{
    WMChooseSchoolViewController *vc = [[WMChooseSchoolViewController alloc] init];
    vc.delegate = self;
    [NKNC pushViewController:vc animated:YES];
    [vc release];
}

- (void)changeRelationship:(id)sender {
    // TODO
}

#pragma mark - WMChooseSchoolViewDelegate

- (void)schoolDidSelect:(NSDictionary *)university {
    NSAssert(university[@"id"] != nil && university[@"name"] != nil, @"School require an id and a name");
    
    self.man.university = university;
    [self setUIForData];
    [NKNC popToViewController:self animated:YES];
}

#pragma mark -

-(void)addTags {
    WMCreateTagViewController *createTag = [[WMCreateTagViewController alloc] init];
    createTag.man = self.man;
    createTag.father = self;
    [self.navigationController pushViewController:createTag animated:YES];
    [createTag release];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.name) {
        self.man.name = textField.text;
    }
    else if (textField == self.weiboName) {
        self.man.weiboName = textField.text;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.name) {
        self.man.name = text;
    }
    else if (textField == self.weiboName) {
        self.man.weiboName = text;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if (textField == self.name) {
        [self.weiboName becomeFirstResponder];
    }
    
    return YES;
}

-(void)addImagePickView{
    
    UIImageView *imageBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baoliao_image_back"]] autorelease];
    [_scrollView addSubview:imageBack];
    imageBack.frame = CGRectMake(15, 9, imageBack.frame.size.width, imageBack.frame.size.height);
    imageBack.userInteractionEnabled = YES;
    
    self.pickButton = [[[UIButton alloc] initWithFrame:CGRectMake(12, 10, 81, 81)] autorelease];
    [imageBack addSubview:_pickButton];
    
    [_pickButton setImage:[UIImage imageNamed:@"man_add_avatar_normal"] forState:UIControlStateNormal];
    [_pickButton setImage:[UIImage imageNamed:@"man_add_avatar_click"] forState:UIControlStateHighlighted];
    [_pickButton addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
    
    self.preView = [[[UIView alloc] initWithFrame:imageBack.bounds] autorelease];
    [imageBack addSubview:_preView];
    
    UIImageView *imageMask = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_cell_picture"]] autorelease];
    [_preView addSubview:imageMask];
    imageMask.userInteractionEnabled = YES;
    imageMask.frame = CGRectMake(8, 6, imageMask.frame.size.width, imageMask.frame.size.height);
    
    self.imageView = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(7, 6.5, 75, 75)] autorelease];
    [imageMask addSubview:_imageView];
    _imageView.target = self;
    _imageView.singleTapped = @selector(preViewImage:);
    
    UIButton *deleteButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
    [_preView addSubview:deleteButton];
    [deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setImage:[UIImage imageNamed:@"baoliao_image_delete"] forState:UIControlStateNormal];
    deleteButton.center = CGPointMake(92, 13);
    
    
}

-(void)preViewImage:(UIGestureRecognizer*)gesture{
    
    NKPictureViewer *viewer = [NKPictureViewer pictureViewerForView:self.imageView];
    [viewer showPictureForObject:self.man andKeyPath:@"avatar"];
    
    
}

-(void)deleteImage:(id)sender{
    self.man.avatar = nil;
    self.man.avatarBig = nil;
    [self setUIForData];
}

#pragma mark SelectPhoto
-(void)pickImage:(id)sender{
    
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
    actionSheet.actionSheetStyle = NKActionSheetStyle;
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
    [actionSheet release];
    
    
}



#pragma mark -
#pragma mark UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
            
        case 0:{
            UIImagePickerController * pickerController = [[UIImagePickerController alloc] init];
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.delegate = self;
            [self presentModalViewController:pickerController animated:YES];
            [pickerController release];
            
        }
            break;
        case 1:{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController * pickerController = [[UIImagePickerController alloc] init];
                pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerController.delegate = self;
                [self presentModalViewController:pickerController animated:YES];
                [pickerController release];
            }
            else{
                
                UIImagePickerController * pickerController = [[UIImagePickerController alloc] init];
                pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                pickerController.delegate = self;
                [self presentModalViewController:pickerController animated:YES];
                [pickerController release];
            }
            
            
        }
            break;
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage * pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage * selectedImage = nil;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil);
        selectedImage = [pickedImage resizedImage:CGSizeMake(pickedImage.size.width / pickedImage.size.height * 960, 960) interpolationQuality:kCGInterpolationMedium];
    }else {
        selectedImage = pickedImage;
    }
    
    
    
    self.man.avatar = selectedImage;
    
    self.isManAvatarChanged = YES;
    
    [self setUIForData];
    [picker dismissNKViewControllerAnimated:YES completion:nil];
    
} /* imagePickerController */


- (NSDictionary *)validManBirth {
    NSDictionary *birth = self.man.birth;
    
    if (birth && birth[@"month"] && birth[@"day"]) {
        if (![birth[@"month"] isKindOfClass:[NSNull class]] && ![birth[@"day"] isKindOfClass:[NSNull class]]) {
            return birth;
        }
    }
    
    return nil;
}


-(void)setUIForData{
    
    
    self.weiboName.text = self.man.weiboName;
    self.name.text = self.man.name;
    
    NSDictionary *birth = [self validManBirth];
    
    if (birth) {
        NSInteger month = [birth[@"month"] integerValue];
        NSInteger day = [birth[@"day"] integerValue];
        
        NSString *birthday = [NSString stringWithFormat:@"%d月%d日(%@)", month, day, [self getHoroscopeByMonth:month andDay:day]];
        [self.birthday setTitle:birthday forState:UIControlStateNormal];
        
        [self.birthday.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [self.birthday setTitleColor:[UIColor colorWithHexString:@"#535353"] forState:UIControlStateNormal];
        [self.birthday setTitleColor:[UIColor colorWithHexString:@"#535353"] forState:UIControlStateHighlighted];
    }
    else{
        [self.birthday setTitle:@"他的生日(选填)" forState:UIControlStateNormal];
    }
    
    NSArray *tags = self.man.tags;
    
    for (UIView *view in [self.tags subviews]) {
        if ([view isKindOfClass:[WMTagLabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (tags.count > 0) {
        [self.tags setTitle:@"" forState:UIControlStateNormal];
        UIImage *color = [UIImage imageNamed:@"tag_bg_1"];
        
        int numOfLine = 0;
        CGFloat tagHeight = 10;
        CGFloat totalWidth = 10;
        
        for (WMMTag *tag in tags) {
            NSString *manTag = [NSString stringWithFormat:@"%@", tag.name];
            
            if (totalWidth + [WMTagLabel widthOfLabel:manTag type:1] > 280) {
                totalWidth = 10;
                tagHeight += 35;
                numOfLine += 1;
            }
            WMTagLabel *tagLabel = [[WMTagLabel alloc] initWithFrame:CGRectMake(totalWidth, tagHeight, [WMTagLabel widthOfLabel:manTag type:1], 30) tag:manTag color:color type:1];
            totalWidth += [WMTagLabel widthOfLabel:manTag type:1] + 5;
            
            [self.tags addSubview:tagLabel];
            [tagLabel release];
        }
        
        CGRect frame = self.tags.frame;
        frame.size.height = tagHeight + 30 + 11.5;
        self.tags.frame = frame;
    } else {
        CGRect frame = self.tags.frame;
        [self.tags setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 44.0f)];
        [self.tags setTitle:@"添加他的特点/优点/缺点标签(选填)" forState:UIControlStateNormal];
    }
    
    UIImageView *arrow = (UIImageView *)[self.tags viewWithTag:kWMCreateManViewTagForDetailButtonRightArrow];
    CGPoint center = arrow.center;
    center.y = self.tags.bounds.size.height / 2.0f;
    arrow.center = center;
    
    if (self.man.university) {
        [self.school setTitle:self.man.university[@"name"] forState:UIControlStateNormal];
        
        [self.school.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [self.school setTitleColor:[UIColor colorWithHexString:@"#535353"] forState:UIControlStateNormal];
        [self.school setTitleColor:[UIColor colorWithHexString:@"#535353"] forState:UIControlStateHighlighted];
    } else {
        [self.school setTitle:@"他的学校(选填)" forState:UIControlStateNormal];
    }
    
    [self.relationship setTitle:@"交往历史(选填)" forState:UIControlStateNormal];
    
    self.pickButton.hidden = self.man.avatar || self.man.avatarBig;
    self.preView.hidden = !(self.man.avatar || self.man.avatarBig);
    self.imageView.image = self.man.avatar ? self.man.avatar : self.man.avatarBig;

    [self layoutSubViews];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Date

-(void)pickDate:(id)sender{
    
    self.dateSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"hello" destructiveButtonTitle:@"hello" otherButtonTitles:@"hello", @"hello", nil] autorelease];
    
    UIImageView *white = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    white.image = [UIImage imageNamed:@"mazhi_back"];
    white.contentMode = UIViewContentModeTop;
    white.clipsToBounds = YES;
    white.userInteractionEnabled = YES;
    [_dateSheet addSubview:white];
    [white release];
    
    UIButton *dateCancelButton = [self addleftButtonWithTitle:@"取消"];
    [white addSubview:dateCancelButton];
    [dateCancelButton removeTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [dateCancelButton addTarget:self action:@selector(dateCancel:) forControlEvents:UIControlEventTouchUpInside];
    dateCancelButton.center = CGPointMake(dateCancelButton.center.x, dateCancelButton.center.y+3);
    
    UIButton *sendButton = [self addRightButtonWithTitle:@"确定"];
    UIButton *dateOKButton = sendButton;
    [white addSubview:dateOKButton];
    [dateOKButton removeTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [dateOKButton addTarget:self action:@selector(dateOK:) forControlEvents:UIControlEventTouchUpInside];
    dateOKButton.center = CGPointMake(dateOKButton.center.x, dateOKButton.center.y+3);
    
    NKKVOLabel *lable = [[[NKKVOLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)] autorelease];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    lable.font = [UIFont boldSystemFontOfSize:20];
    
    lable.backgroundColor = [UIColor clearColor];
    lable.center = CGPointMake(160, 25);
    lable.shadowColor = [UIColor whiteColor];
    lable.shadowOffset = CGSizeMake(0, 1);
    [white addSubview:lable];
    [lable bindValueOfModel:self forKeyPath:@"horoscope"];
    
    [_dateSheet addSubview:self.monthAndDayPickerVC.view];
    [_dateSheet showInView:self.view];
    
    NSDictionary *birth = [self validManBirth];
    
    if (birth) {
        NSInteger month = [birth[@"month"] integerValue];
        NSInteger day = [birth[@"day"] integerValue];
        
        self.horoscope = [self getHoroscopeByMonth:month andDay:day];
        [self.monthAndDayPickerVC setMonth:month andDay:day];
    }
    
}

-(void)dateCancel:(id)sender{
    [_dateSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)dateOK:(id)sender{
    
    self.man.birth = self.monthAndDayPickerVC.monthAndDay;
    [self setUIForData];
    [_dateSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)monthAndDayPickerViewController:(MonthAndDayPickerViewController *)viewController
                       didChangeToMonth:(NSInteger)month
                                 andDay:(NSInteger)day {
    
    self.horoscope = [self getHoroscopeByMonth:month andDay:day];
}

- (NSString *)getHoroscopeByMonth:(NSInteger)month andDay:(NSInteger)day {
    if (month < 1 || month > 12) {
        month = 1;
    }
    
    if (day < 1 || day > 31) {
        day = 1;
    }
    
    NSString *horoscopeString = @"摩羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手摩羯";
    NSString *horoscopeFormat = @"102123444543";
    NSString *result = [NSString stringWithFormat:@"%@",
                        [horoscopeString substringWithRange:NSMakeRange(month * 2 - (day < [[horoscopeFormat substringWithRange:NSMakeRange((month - 1), 1)] intValue] - (-19)) * 2,2)]];
    result = [result stringByAppendingString:@"座"];
    return result;
}

@end
