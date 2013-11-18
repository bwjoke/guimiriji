//
//  WMNewTopicViewController.m
//  WEIMI
//
//  Created by ZUO on 7/1/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "WMNewTopicViewController.h"
#import "WMTextView.h"
#import "WMTextField.h"
#import "RegexKitLite.h"
#import "WMAccountManager.h"
#import "UIImage+Resize.h"

#import "WMRecordPlugin.h"

static const CGFloat __gap_of_views = 10.0f;

enum tWMNewTopicViewTag {
    kWMNewTopicViewTagConfirmGoBack = 1
};

@interface WMNewTopicViewController () <WMRecordPluginDelegate> {
    CGFloat _originWidth;
    CGFloat _originHeight;
    CGFloat _keyboardHeight;
}

@property (nonatomic, retain) UIScrollView *wrapperView;

@property (nonatomic, retain) WMTextField *titleTextField;
@property (nonatomic, retain) WMTextView *contentTextView;
@property (nonatomic, retain) WMTextField *nickTextField;

@property (nonatomic, unsafe_unretained) WMRecordPlugin *recordButton;

@end

@implementation WMNewTopicViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self doInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self doInit];
    }
    return self;
}

- (id)init {
    if ((self = [super init])) {
        [self doInit];
    }
    return self;
}

- (void)doInit {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShowNotification:)
     name:UIKeyboardWillShowNotification
     object:nil];
}

- (void)dealloc {
    [_boardID release];
    
    [_titleTextField release];
    [_contentTextView release];
    [_nickTextField release];
    [_wrapperView release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.titleLabel.text = @"新话题";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] autorelease] atIndex:0];
    [self addHeadShadow];
    [self addBackButton];
    [self addRightButtonWithTitle:@"发布"];
    [self.showTableView removeFromSuperview];
    
    
    CGRect frame = self.view.frame;
    frame.origin.y = 44.0f;
    frame.size.height -= 44.0f;
    
    _originHeight = frame.size.height;
    _originWidth = frame.size.width;
    
    self.wrapperView = [[[UIScrollView alloc] initWithFrame:frame] autorelease];
    self.wrapperView.contentSize = CGSizeMake(frame.size.width, frame.size.height + 1);
    self.wrapperView.delegate = self;
    
    
    [self.contentView addSubview:self.wrapperView];
    self.wrapperView.showsHorizontalScrollIndicator = NO;
    self.wrapperView.showsVerticalScrollIndicator = NO;
    
    CGFloat offsetY = __gap_of_views;
    
    self.titleTextField = [[[WMTextField alloc] initWithFrame:CGRectMake(10.0f, offsetY, 300.0f, 41.0f)] autorelease];
    self.titleTextField.placeholder = @"标题";
    [self.wrapperView addSubview:self.titleTextField];
    self.titleTextField.margin = 10.0f;
    self.titleTextField.delegate = self;
    
    offsetY += 41.0f + __gap_of_views;
    
    self.contentTextView = [[[WMTextView alloc] initWithFrame:CGRectMake(10.0f, offsetY, 300.0f, 101.0f)] autorelease];
    self.contentTextView.textView.placeholder = @"内容";
    [self.wrapperView addSubview:self.contentTextView];
    self.contentTextView.insets = UIEdgeInsetsMake(2.0f, 2.0f, 10.0f, 2.0f);
    self.contentTextView.textView.delegate = self;
    
    offsetY += 101.0f + __gap_of_views;
    
    [self addImagePickViewWithOffsetY:&offsetY];
    
    offsetY += __gap_of_views;
    
    BOOL hasNickName = [[[WMMUser me] topicName] length] > 0;
    
    if (!hasNickName) {
        self.nickTextField = [[[WMTextField alloc] initWithFrame:CGRectMake(10.0f, offsetY, 300.0f, 41.0f)] autorelease];
        self.nickTextField.placeholder = @"我的昵称";
        [self.wrapperView addSubview:self.nickTextField];
        self.nickTextField.margin = 10.0f;
        self.nickTextField.delegate = self;
    }
    
    [self setUIForData];
    
    [self addInputView];
}

- (void)addInputView {
    self.commentView = [NKInputView inputViewWithTableView:self.showTableView dataSource:self.dataSource otherView:nil];
    _commentView.managedTextView = _contentTextView.textView;
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

-(void)addImagePickViewWithOffsetY:(CGFloat *)offsetY {
    
    UIImage *image = [[UIImage imageNamed:@"baoliao_image_back"] resizeImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
    
    UIImageView *imageBack = [[[UIImageView alloc] initWithImage:image] autorelease];
    [self.wrapperView addSubview:imageBack];
    
    imageBack.frame = CGRectMake(10, *offsetY, 300.0f, imageBack.frame.size.height);
    imageBack.userInteractionEnabled = YES;
    
    *offsetY += imageBack.frame.size.height;
    
    self.pickButton = [[[UIButton alloc] initWithFrame:CGRectMake(12, 10, 81, 81)] autorelease];
    [imageBack addSubview:_pickButton];
    
    [_pickButton setImage:[UIImage imageNamed:@"baoliao_photo"] forState:UIControlStateNormal];
    [_pickButton setImage:[UIImage imageNamed:@"baoliao_photo_click"] forState:UIControlStateHighlighted];
    [_pickButton addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
    
    // Record plugin {{{
    
    WMRecordPlugin *recordButton = [[[WMRecordPlugin alloc] initWithFrame:CGRectMake(93, 0, 100, 100)] autorelease];
    recordButton.delegate = self;
    
    [imageBack addSubview:recordButton];
    
    self.recordButton = recordButton;
    
    // }}}
    
    self.moreButton = [[[UIButton alloc] initWithFrame:CGRectMake(194, 10, 81, 81)] autorelease];
    [imageBack addSubview:_moreButton];
    
    [_moreButton setImage:[UIImage imageNamed:@"miyu_send_more"] forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:@"miyu_send_more_click"] forState:UIControlStateHighlighted];
    [_moreButton addTarget:self action:@selector(pickMore:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rect = _pickButton.bounds;
    rect.size.width += 20.0f;
    rect.size.height += 20.0f;
    
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

-(void)preViewImage:(UIGestureRecognizer*)gesture{
    NKPictureViewer *viewer = [NKPictureViewer pictureViewerForView:self.imageView];
    [viewer showPictureForObject:self andKeyPath:@"image"];
}

-(void)setUIForData{
    self.pickButton.hidden = self.image;
    self.preView.hidden = !self.image;
    self.imageView.image = self.image;
}

#pragma mark SelectPhoto
-(void)pickImage:(id)sender{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
    actionSheet.actionSheetStyle = NKActionSheetStyle;
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

-(void)pickMore:(id)sender
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:@"即将推出更多插件，敬请期待~如果有好点子，欢迎通过微博@薇蜜，或点击设置->建议反馈告诉我们" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
    [alert show];
}

#pragma mark -

-(void)deleteImage:(id)sender{
    self.image = nil;
    [self setUIForData];
}

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
            } else {
                
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
    
}

#pragma mark -


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.nickTextField) {
        CGFloat offsetY;
        
        [self.wrapperView.layer removeAllAnimations];
        
        if (self.wrapperView.frame.size.height > 300.0f) {
            offsetY = 165.0f;
            [UIView animateWithDuration:0.25f
                                  delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^(void) {
                                 self.wrapperView.contentOffset = CGPointMake(0.0f, offsetY);
                             }
                             completion:NULL];
        }
    }
    
    self.commentView.hidden = YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.commentView.hidden = NO;
    
    [UIView
     animateWithDuration:0.25f
     delay:0
     options:UIViewAnimationOptionBeginFromCurrentState
     animations:^{
         self.wrapperView.contentOffset = CGPointMake(0.0f, 32.0f);
     }
     completion:NULL];
    
    // If the comment view at bottom
    if (self.commentView.frame.origin.y > self.view.frame.size.height - 100.0f) {
        CGRect frame = self.commentView.frame;
        frame.origin.y = self.view.frame.size.height - _keyboardHeight - 40.0f;
        self.commentView.frame = frame;
    }
}

- (void)keyboardWillShowNotification:(NSNotification *)noti {
    [self keyboardWillChangeNotification:noti];
}

- (void)keyboardWillChangeNotification:(NSNotification *)noti {
    
    NSDictionary *userInfo = noti.userInfo;
    CGFloat during = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _keyboardHeight = endRect.size.height;
    
    CGRect wrapperFrame = self.wrapperView.frame;
    CGFloat endKeyboardHeight = endRect.size.height;
    wrapperFrame.size.height = _originHeight - endKeyboardHeight;
    
    [UIView
     animateWithDuration:during
     delay:0
     options:UIViewAnimationOptionBeginFromCurrentState
     animations:^{
         self.wrapperView.frame = wrapperFrame;
     }
     completion:NULL];
}

- (void)rightButtonClick:(id)sender {
    [self submitTopic];
}

- (void)submitTopic {
    [self.commentView hide];
    [self.contentTextView.textView resignFirstResponder];
    
    [self scrollViewWillBeginDragging:self.wrapperView];
    
    NSString *title = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!title || title.length < 2) {
        ProgressFailedWith(@"标题至少2个字");
        return;
    } else if (title.length > 50) {
        ProgressFailedWith(@"标题最多50个字");
        return;
    }
    
    NSString *content = [self.contentTextView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!content || content.length < 5) {
        ProgressFailedWith(@"内容至少5个字");
        return;
    } else if (content.length > 5000) {
        ProgressFailedWith(@"内容最多5000个字");
        return;
    }
    
    NSString *nick = nil;
    NSMutableDictionary *userInfo = nil;
    
    if ([[[WMMUser me] topicName] length] > 0) {
        // If user has topic name, don't pass it to server
        userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"title":title, @"content":content}];
    } else {
        nick = [self.nickTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (!nick || !nick.length) {
            ProgressFailedWith(@"请填写想在讨论区使用的昵称");
            
            if ([self haveFirstResponder]) {
                [self.nickTextField becomeFirstResponder];
                [self showNickField];
            } else {
                [self.nickTextField becomeFirstResponder];
            }
            
            return;
        }
        
        if (nick.length > 14) {
            ProgressFailedWith(@"昵称最多最多7个汉字，14个英文字");
            return;
        }
        
        userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"title":title, @"content":content, @"topicnick":nick}];
    }
    
    if (self.image != nil) {
        userInfo[@"attachments"] = @[UIImageJPEGRepresentation(self.image, 0.5)];
    }
    
    if (self.recordButton.audio) {
        userInfo[@"audio"] = [self.recordButton amrData];
        userInfo[@"audio_seconds"] = @([self.recordButton amrDataSeconds]);
    }
    
    Progress(@"发布中");
    self.nkRightButton.enabled = NO;
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(submitTopicOK:) andFailedSelector:@selector(submitTopicFailed:)];
    
    [[WMTopicService sharedWMTopicService]
     createTopic:rd
     withBoardID:_boardID
     andUserInfo:userInfo];
}

- (void)showNickField {
    [self.wrapperView.layer removeAllAnimations];
    
    CGRect frame = self.nickTextField.frame;
    frame.size.height += 50.0f;
    [self.wrapperView scrollRectToVisible:frame animated:YES];
}

- (BOOL)haveFirstResponder {
    return [self isFirstResponder:self.view];
}

- (BOOL)isFirstResponder:(UIView *)view {
    if ([view isFirstResponder]) {
        return YES;
    } else {
        for (UIView *subview in [view subviews]) {
            if ([self isFirstResponder:subview]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)submitTopicOK:(NKRequest *)request {
    if (request.originDic) {
        NSString *topicnick = [request.originDic valueForKeyPath:@"data.user.topicnick"];
        if (topicnick) {
            [[WMMUser me] setTopicName:topicnick];
            [[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] cacheMe:[WMMUser me]];
        }
    }
    
    [NKNC popViewControllerAnimated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(newTopicDidSuccess)]) {
        [self.delegate newTopicDidSuccess];
    }
    
    ProgressSuccess(@"发布成功");
}

- (void)submitTopicFailed:(NKRequest *)request {
    self.nkRightButton.enabled = YES;
    ProgressErrorDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack:(id)sender {
    NSString *content = self.contentTextView.textView.text;
    
    if (content && content.length > 5) {
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:nil message:@"确认要放弃这次编辑？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        alert.tag = kWMNewTopicViewTagConfirmGoBack;
        alert.delegate = self;
        [alert show];
    } else {
        [super goBack:sender];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kWMNewTopicViewTagConfirmGoBack) {
        if (buttonIndex == 0) {
            [NKNC popViewControllerAnimated:YES];
        }
    }
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

#pragma mark - WMRecordPluginDelegate

- (void)recordPlugin:(WMRecordPlugin *)recordPlugin placePlayList:(UIView *)playlist {
    playlist.center = CGPointMake(self.view.bounds.size.width / 2.0f - 2, 354.0f);
    [self.view addSubview:playlist];
}

@end
