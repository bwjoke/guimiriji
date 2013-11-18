//
//  WMReplyTopicViewController.m
//  WEIMI
//
//  Created by ZUO on 7/3/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMReplyTopicViewController.h"
#import "WMTextField.h"
#import "WMTextView.h"
#import "WMMTopic.h"
#import "RegexKitLite.h"
#import "WMCustomLabel.h"
#import "WMAccountManager.h"
#import "UIImage+Resize.h"

#import "WMRecordPlugin.h"

enum tWMReplyTopicViewTag {
    kWMReplyTopicViewConfirmGoBack = 1
};

@interface WMReplyTopicViewController () <WMRecordPluginDelegate> {
    CGFloat _originWidth;
    CGFloat _originHeight;
    CGFloat _originContentHeight;
}

@property (nonatomic, unsafe_unretained) WMTextView *contentTextView;
@property (nonatomic, unsafe_unretained) WMTextField *nickTextField;
@property (nonatomic, unsafe_unretained) UIScrollView *wrapperView;

@property (nonatomic, unsafe_unretained) WMRecordPlugin *recordButton;

@end

@implementation WMReplyTopicViewController

- (void)dealloc {
    [_model release];
    [_userInfo release];
    _imageView.target = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.titleLabel.text = @"回复";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 44.0f;
    frame.size.height -= 44.0f;
    
    self.wrapperView = [[[UIScrollView alloc] initWithFrame:frame] autorelease];
    self.wrapperView.contentSize = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    self.wrapperView.delegate = self;
    
    [self.contentView addSubview:self.wrapperView];
    self.wrapperView.showsHorizontalScrollIndicator = NO;
    self.wrapperView.showsVerticalScrollIndicator = NO;
    
    CGFloat offsetY = 10.0f;
    
    if (self.model && [self.model isKindOfClass:[WMMTopicComment class]]) {
        WMMTopicComment *comment = self.model;
        NSNumber *floor = self.userInfo[@"floor"];
        
        WMCustomLabel *label = [[WMCustomLabel alloc] initWithFrame:CGRectMake(30, offsetY, 280, 10) font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"#A6937C"]];
        label.numberOfLines = 0;
        [self.wrapperView addSubview:label];
        
        NSString *prefix = nil;
        
        if ([comment.sender.topicName length]) {
            prefix = [NSString stringWithFormat:@"%@楼 %@：",floor,comment.sender.topicName];
        }else {
            prefix = [NSString stringWithFormat:@"%@楼 %@：",floor,comment.sender.name];
        }
        
        NSString *firstTextReply = [comment firstTxetReply];
        
        NSString *replyStr = [NSString stringWithFormat:@"%@%@", prefix, firstTextReply ? firstTextReply : @""];
        
        CGFloat height = [replyStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, 50) lineBreakMode:NSLineBreakByCharWrapping].height;
        CGRect frame = label.frame;
        frame.size.height = height;
        label.frame = frame;
        label.text = replyStr;
        [label setTextColor:[UIColor colorWithHexString:@"#F096A0"] range:NSMakeRange(0, prefix.length)];
        
        UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(20.0f, offsetY, 1.0f, label.frame.size.height)] autorelease];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#eae0d0"];
        [self.wrapperView addSubview:lineView];
        
        offsetY += label.frame.size.height + 10.0f;
    }
    
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] autorelease] atIndex:0];
    [self addHeadShadow];
    [self addBackButton];
    [self addRightButtonWithTitle:@"发布"];
    [self.showTableView removeFromSuperview];
    
    self.contentTextView = [[[WMTextView alloc] initWithFrame:CGRectMake(10.0f, offsetY, 300.0f, 101.0f)] autorelease];
    self.contentTextView.textView.delegate = self;
    self.contentTextView.textView.placeholder = @"内容";
    [self.wrapperView addSubview:self.contentTextView];
    self.contentTextView.insets = UIEdgeInsetsMake(2.0f, 2.0f, 10.0f, 2.0f);
    
    offsetY += self.contentTextView.frame.size.height + 10.0f;
    
    [self addImagePickViewWithOffsetY:&offsetY];
    
    BOOL hasNickName = [[[WMMUser me] topicName] length] > 0;
    
    if (!hasNickName) {
        self.nickTextField = [[[WMTextField alloc] initWithFrame:CGRectMake(10.0f, offsetY + 10.0f, 300.0f, 41.0f)] autorelease];
        self.nickTextField.placeholder = @"我的昵称";
        [self.wrapperView addSubview:self.nickTextField];
        self.nickTextField.margin = 10.0f;
        self.nickTextField.delegate = self;
        
        offsetY += self.nickTextField.frame.size.height + 10.0f;
    }
    
    CGSize size = self.wrapperView.contentSize;
    
    self.wrapperView.contentSize = size;
    
    _originHeight = self.wrapperView.frame.size.height;
    _originWidth = self.wrapperView.frame.size.width;
    
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
    CGRect rect = CGRectZero;
    
    if (textField == self.nickTextField) {
        rect = self.nickTextField.frame;
    }
    
    rect.size.height += 50.0f;
    
    [self.wrapperView scrollRectToVisible:rect animated:YES];
}

- (void)keyboardWillShowNotification:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    CGFloat during = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
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
    [self submitReply];
}

- (void)submitReply {
    [self.commentView hide];
    [self.contentTextView.textView resignFirstResponder];
    
    NSString *content = self.contentTextView.textView.text;
    
    if (!content || content.length < 2) {
        ProgressFailedWith(@"回复内容至少2个字");
        return;
    } else if (content.length > 5000) {
        ProgressFailedWith(@"回复内容最多5000个字");
        return;
    }
    
    NSString *topicnick = nil;
    NSMutableDictionary *userInfo = nil;
    
    if ([[[WMMUser me] topicName] length] > 0) {
        // If user has topic name, don't pass it to server
        userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"content": content}];
    } else {
        topicnick = [self.nickTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (!topicnick || !topicnick.length) {
            ProgressFailedWith(@"请填写想在讨论区使用的昵称");
            [self.nickTextField becomeFirstResponder];
            return;
        }
        
        if (topicnick.length > 14) {
            ProgressFailedWith(@"昵称最多最多7个汉字，14个英文字");
            return;
        }
        
        userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"content": content, @"topicnick": topicnick}];
    }
    
    if (self.image != nil) {
        // Currently, just support only one picture
        userInfo[@"attachments"] = @[UIImageJPEGRepresentation(self.image, 0.5)];
    }
    
    if ([self.model isKindOfClass:[WMMTopic class]]) {
        WMMTopic *topic = self.model;
        
        if (topic.mid) {
            userInfo[@"topicid"] = topic.mid;
        }
    } else if ([self.model isKindOfClass:[WMMTopicComment class]]) {
        WMMTopicComment *comment = self.model;
        WMMTopic *topic = self.userInfo[@"topic"];
        NSNumber *floor = self.userInfo[@"floor"];
        
        if (topic.mid) {
            userInfo[@"topicid"] = topic.mid;
        }
        
        NSString *prefix = [NSString stringWithFormat:@"%@楼 %@：", floor, comment.sender.name ? comment.sender.name : @""];
        
        userInfo[@"reply_prefix"] = prefix;
        
        if (comment.mid) {
            userInfo[@"reply_commentid"] = comment.mid;
        }
        
        if (comment.firstTxetReply) {
            userInfo[@"reply_commentcontent"] = comment.firstTxetReply;
        }
        
        if (comment.sender.mid) {
            userInfo[@"reply_userid"] = comment.sender.mid;
        }
    }
    
    if (self.recordButton.audio) {
        userInfo[@"audio"] = [self.recordButton amrData];
        userInfo[@"audio_seconds"] = @([self.recordButton amrDataSeconds]);
    }
    
    Progress(@"回复中");
    self.nkRightButton.enabled = NO;
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(submitReplyOK:) andFailedSelector:@selector(submitReplyFailed:)];
    
    [[WMTopicService sharedWMTopicService]
     createComment:rd
     withUserInfo:userInfo];
}

- (void)submitReplyOK:(NKRequest *)request {
    if (request.originDic) {
        NSString *topicnick = [request.originDic valueForKeyPath:@"data.user.topicnick"];
        if (topicnick) {
            [[WMMUser me] setTopicName:topicnick];
            [[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] cacheMe:[WMMUser me]];
        }
    }
    
    [NKNC popViewControllerAnimated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(replyTopicDidSuccess)]) {
        [self.delegate replyTopicDidSuccess];
    }
    
    ProgressHide;
}

- (void)submitReplyFailed:(NKRequest *)request {
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
        alert.tag = kWMReplyTopicViewConfirmGoBack;
        alert.delegate = self;
        [alert show];
    } else {
        [super goBack:sender];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kWMReplyTopicViewConfirmGoBack) {
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
    playlist.center = CGPointMake(self.view.bounds.size.width / 2.0f - 2, 303.0f);
    [self.view addSubview:playlist];
}

@end
