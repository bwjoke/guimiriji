//
//  WMAddMiyuViewController.m
//  WEIMI
//
//  Created by steve on 13-4-16.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMAddMiyuViewController.h"
#import "UIImage+Resize.h"
#import "WMRecordPlugin.h"

#import "UIImage+NKImage.h"

@interface WMAddMiyuViewController () <WMRecordPluginDelegate>

@property (nonatomic, unsafe_unretained) UIScrollView *wrapperView;
@property (nonatomic, assign) NKInputView *commentView;

@property (nonatomic, unsafe_unretained) WMRecordPlugin *recordButton;

@end

@implementation WMAddMiyuViewController {
    CGFloat _originWidth;
    CGFloat _originHeight;
    
    BOOL _isListening;
}

#define MORE_ALERT 2013052901

-(void)dealloc{
    
    [_man release];
    
    [_content release];
    [_image release];
    _imageView.target = nil;
    
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

- (void)textViewDidChange:(UITextView *)textView{
    
    self.content = textView.text;
}

-(void)segmentControl:(NKSegmentControl*)control didChangeIndex:(NSInteger)index{
    
    self.selectedIndex = index;
    
}


-(void)rightButtonClick:(id)sender{
    self.content = self.textField.text;
    if (![self.content length]) {
        //ProgressFailedWith(@"请输入内容");
        UIAlertView *faildAlert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [faildAlert show];
        return;
    }
    
    [_textField resignFirstResponder];
    
    ProgressWith(@"正在发布");
    
    self.nkRightButton.enabled = NO;
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(postOK:) andFailedSelector:@selector(postFailed:)];
    
    [[WMFeedService sharedWMFeedService] addMiyuWithContent:self.content
                                                    purview:0
                                                    picture:self.image ? UIImageJPEGRepresentation(self.image, 0.5) : nil
                                                      audio:self.recordButton.audio
                                              audio_seconds:self.recordButton.audioSeconds
                                         andRequestDelegate:rd];
}


-(void)postOK:(NKRequest*)request{
    
    ProgressSuccess(@"发布成功");
    
    [_delegate tellReloadData];
    [self goBack:nil];
    
}

-(void)postFailed:(NKRequest*)request{
    
    ProgressErrorDefault;
    
    self.nkRightButton.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 44.0f;
    frame.size.height -= 44.0f;
    
    self.wrapperView = [[[UIScrollView alloc] initWithFrame:frame] autorelease];
    self.wrapperView.contentSize = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    _originHeight = self.wrapperView.frame.size.height;
    _originWidth = self.wrapperView.frame.size.width;
    
    self.wrapperView.delegate = self;
    
    [self.view addSubview:self.wrapperView];
    self.wrapperView.showsHorizontalScrollIndicator = NO;
    self.wrapperView.showsVerticalScrollIndicator = NO;
    
    // Do any additional setup after loading the view from its nib.
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    [self addBackButton];
    [self addRightButtonWithTitle:@"发送"];
    [self setShouldAutoRefreshData:NO];
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    
    self.titleLabel.text = @"蜜语";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    
    UIImageView *mazhi = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mazhi_back"]] autorelease];
    [self.wrapperView addSubview:mazhi];
    mazhi.frame = CGRectMake(0, 0, mazhi.frame.size.width, mazhi.frame.size.height);
    
    
    
    UIImageView *textBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wm_input_back"]] autorelease];
    [self.wrapperView addSubview:textBack];
    textBack.frame = CGRectMake((320-textBack.frame.size.width)/2, 16, textBack.frame.size.width, textBack.frame.size.height);
    
    
    self.textField = [[[NKTextViewWithPlaceholder alloc] initWithFrame:CGRectMake(15, textBack.frame.origin.y, 290, textBack.frame.size.height-1)] autorelease];
    [self.wrapperView addSubview:_textField];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.delegate = self;
    _textField.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _textField.placeholderLabel.text = @"这一刻在想...";
    
//    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 255, 280, 13)];
//    descLabel.font = [UIFont systemFontOfSize:12.0];
//    descLabel.text = @"对她们可见";
//    descLabel.textColor = [UIColor colorWithHexString:@"#b9a994"];
//    descLabel.backgroundColor = [UIColor clearColor];
//    [self.contentView addSubview:descLabel];
    
    
    
    
    [self addImagePickView];
    
    [self setUIForData];
    
    [self addInputView];
}

- (void)addInputView {
    self.commentView = [NKInputView inputViewWithTableView:self.showTableView dataSource:self.dataSource otherView:nil];
    _commentView.managedTextView = _textField;
    _commentView.backgroundColor = [UIColor colorWithHexString:@"#f5eee3"];
    _commentView.target = self;
    _commentView.action = @selector(addComment:);
    self.commentView.nimingButton.hidden = YES;
    _commentView.textView.hidden = YES;
    _commentView.textViewBack.hidden = YES;
    _commentView.sendButton.hidden = YES;
    CGRect emojoFrame = _commentView.emojoButton.frame;
    emojoFrame.origin.x = 4;
    _commentView.emojoButton.frame = emojoFrame;
    _commentView.jianpanButton.frame = emojoFrame;
    
    [self.view addSubview:_commentView];
}

-(void)listFriends{
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(listFriendsOK:) andFailedSelector:@selector(listFriendsFailed:)];
    [[WMUserService  sharedWMUserService] getRelatedUsersWithUID:nil andRequestDelegate:rd];
    
}

-(void)listFriendsOK:(NKRequest*)request{
    _userFriends = [[[NSMutableArray alloc] init] autorelease];
    
    CGFloat startX = 21;
    CGFloat avatarDistance = 291;
    CGFloat avatarWidth = 50;
    
    self.dataSource = [NSMutableArray arrayWithArray:request.results];
    for (WMMUser *user in self.dataSource) {
        if ([user.relation isEqualToString:NKRelationFriend]) {
            [_userFriends addObject:user];
        }
    }
    
    for (WMMUser *user in _userFriends) {
        
        NKKVOImageView *avatar = [[NKKVOImageView alloc] initWithFrame:CGRectMake(startX, avatarDistance, avatarWidth, avatarWidth)];
        avatar.layer.cornerRadius = 6.0f;
        avatar.layer.masksToBounds = YES;
        [avatar bindValueOfModel:user forKeyPath:@"avatar"];
        [self.contentView addSubview:avatar];
        UIImageView *coverView = [[UIImageView alloc] initWithFrame:CGRectMake(startX-6, avatarDistance-6, avatarWidth+12, avatarWidth+12)];
        coverView.image = [UIImage imageNamed:@"post_honey_use"];
        [self.contentView addSubview:coverView];
        [coverView release];
        [avatar release];
        
    }
    
}

-(void)addImagePickView{
    
    UIImageView *imageBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baoliao_image_back"]] autorelease];
    [self.wrapperView addSubview:imageBack];
    imageBack.frame = CGRectMake(15, 102, imageBack.frame.size.width, imageBack.frame.size.height);
    imageBack.userInteractionEnabled = YES;
    
    self.pickButton = [[[UIButton alloc] initWithFrame:CGRectMake(12, 10, 81, 81)] autorelease];
    [imageBack addSubview:_pickButton];
    
    [_pickButton setImage:[UIImage imageNamed:@"baoliao_photo"] forState:UIControlStateNormal];
    [_pickButton setImage:[UIImage imageNamed:@"baoliao_photo_click"] forState:UIControlStateHighlighted];
    [_pickButton addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
    
    WMRecordPlugin *recordButton = [[[WMRecordPlugin alloc] initWithFrame:CGRectMake(93, 0, 100, 100)] autorelease];
    recordButton.delegate = self;
    
    [imageBack addSubview:recordButton];
    
    self.recordButton = recordButton;
    
    self.moreButton = [[[UIButton alloc] initWithFrame:CGRectMake(194, 10, 81, 81)] autorelease];
    [imageBack addSubview:_moreButton];
    
    [_moreButton setImage:[UIImage imageNamed:@"miyu_send_more"] forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:@"miyu_send_more_click"] forState:UIControlStateHighlighted];
    [_moreButton addTarget:self action:@selector(pickMore:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rect = _pickButton.bounds;
    rect.size.width += 20.0f;
    rect.size.height += 20.0f;
    
    // Image preview button
    
    self.preView = [[[UIView alloc] initWithFrame:rect] autorelease];
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

-(void)pickMore:(id)sender
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:@"即将推出更多插件，敬请期待~如果有好点子，欢迎通过微博@薇蜜，或点击设置->建议反馈告诉我们" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
    //alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = MORE_ALERT;
    [alert show];
}

-(void)preViewImage:(UIGestureRecognizer*)gesture{
    
    NKPictureViewer *viewer = [NKPictureViewer pictureViewerForView:self.imageView];
    [viewer showPictureForObject:self andKeyPath:@"image"];
}

-(void)deleteImage:(id)sender{
    
    self.image = nil;
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.wrapperView == scrollView) {
        [self findAndResignFirstResponder:self.view];
        
        CGRect frame = self.wrapperView.frame;
        frame.size.width = _originWidth;
        frame.size.height = _originHeight;
        
        [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.wrapperView.frame = frame;
        } completion:NULL];
        
        [self.commentView hide];
    }
}

- (void)findAndResignFirstResponder:(UIView *)view
{
    if (view.isFirstResponder) {
        [view resignFirstResponder];
    }
    for (UIView *subView in view.subviews) {
        [self findAndResignFirstResponder:subView];
    }
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
    
    self.image = selectedImage;
    [self setUIForData];
    [picker dismissNKViewControllerAnimated:YES completion:nil];
    
} /* imagePickerController */


-(void)setUIForData{
    
    _textField.text = self.content;
    
    self.pickButton.hidden = self.image;
    self.preView.hidden = !self.image;
    self.imageView.image = self.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WMRecordPluginDelegate

- (void)recordPlugin:(WMRecordPlugin *)recordPlugin placePlayList:(UIView *)playlist {
    playlist.center = CGPointMake(self.view.bounds.size.width / 2.0f - 2, 285.0f);
    [self.view addSubview:playlist];
}

@end
