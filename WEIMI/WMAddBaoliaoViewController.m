//
//  WMAddBaoliaoViewController.m
//  WEIMI
//
//  Created by King on 4/8/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMAddBaoliaoViewController.h"
#import "UIImage+Resize.h"
#import <stdlib.h>

#import "WMRecordPlugin.h"

@interface WMAddBaoliaoViewController () <WMRecordPluginDelegate>
{
    NSMutableArray *questionList;
    int alertCount,lastX;
    UIButton *senderButton;
}
@end

@implementation WMAddBaoliaoViewController

#define ASK_ALERT 121200
#define MORE_ALERT 121201

-(void)dealloc{
    
    [_man release];
    
    [_content release];
    [_image release];
    _imageView.target = nil;
    [questionList release];
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

-(void)panMoved:(UIPanGestureRecognizer*)gest{
    
    if (gest.state == UIGestureRecognizerStateEnded) {
        [self.recordButton stopRecord];
    }
    
    [_textField resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    self.content = textView.text;
}

-(void)segmentControl:(NKSegmentControl*)control didChangeIndex:(NSInteger)index{
    
    self.selectedIndex = index;
    
    switch (index) {
        case 0:{
            _notice.text = @"匿名发布，别人看不到妳是谁，但能看到妳发布的内容";
        }
            break;
        case 1:{
            _notice.text = @"只有你的姐妹闺蜜才能看这条内容哦~";
        }
            break;
        case 2:{
            _notice.text = @"公开发布，所有人都能看到妳发布的内容和妳是谁";
        }
            break;
            
        default:
            break;
    }
    
    
}


-(void)rightButtonClick:(id)sender{
    
    if (![self.content length] && !self.image) {
        
        //ProgressFailedWith(@"请输入爆料内容或上传一张图片");
        UIAlertView *faildAlert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入爆料内容或上传一张图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [faildAlert show];
        return;
    }
    
    [_textField resignFirstResponder];
    
    ProgressWith(@"正在发布");
    [self.nkRightButton setEnabled:NO];
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(postOK:) andFailedSelector:@selector(postFailed:)];
    
    [[WMManService sharedWMManService] addBaoliaoWithMID:self.man.mid
                                                 content:self.content
                                                 purview:(self.selectedIndex+1)%3
                                                 picture:self.image ? UIImageJPEGRepresentation(self.image, 0.5) : nil
                                                   audio:[self.recordButton amrData]
                                           audio_seconds:[self.recordButton amrDataSeconds]
                                      andRequestDelegate:rd];
}


-(void)postOK:(NKRequest*)request{
    
    ProgressSuccess(@"发布成功");
    [self.father refreshData];
    [self goBack:nil];
    
}

-(void)postFailed:(NKRequest*)request{
    [self.nkRightButton setEnabled:YES];
    ProgressErrorDefault;
}

-(NSMutableArray *)parseArray:(NSArray *)array
{
    NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<[array count]; i++) {
        //NSString *str = [NSString stringWithFormat:@"%@%@",self.man.name,[array objectAtIndex:i]];
        NSString *str = [[array objectAtIndex:i] stringByReplacingOccurrencesOfString:@"$姓名$" withString:self.man.name];
        [arr addObject:str];
    }
    return arr;
}

-(void)getQuestionList
{
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getListOK:) andFailedSelector:@selector(getListFailed:)];
    [[WMSystemService sharedWMSystemService] getQuestionList:rd];
}

-(void)getListOK:(NKRequest *)request
{
    NSArray *counts = (NSArray *)[request.originDic objectOrNilForKey:@"data"];
    if ([counts count]>0) {
        [questionList removeAllObjects];
        for (int i=0; i<[counts count]; i++) {
            [questionList addObject:[[counts objectAtIndex:i] stringByReplacingOccurrencesOfString:@"$姓名$" withString:self.man.name]];
        }
        
    }
    
    
}

-(void)getListFailed:(NKRequest *)request
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    questionList = [[NSMutableArray alloc] init];
    NSArray *questions = [NSArray arrayWithObjects:@"$姓名$喜欢什么颜色？",@"$姓名$喜欢什么类型的女生？",@"$姓名$喜欢平胸还是巨乳？",@"$姓名$会喜欢比自己年龄大的么？",@"$姓名$初恋在什么时候？",@"$姓名$谈过几次恋爱？",@"$姓名$经常运动么？",@"$姓名$劈过腿么？",@"$姓名$交往的女朋友中最长的多久？",@"$姓名$以前分手都有些什么原因？",@"$姓名$体毛重不？",@"$姓名$现在是单身么？",@"$姓名$喜欢丰满的还是瘦的？",@"$姓名$和女生吃饭会买单么？",@"$姓名$最擅长啥？", nil];
    [questionList addObjectsFromArray:[self parseArray:questions]];
    //questionList = [NSMutableArray arrayWithArray:[self parseArray:questions]];
    alertCount = 0;
    lastX = 0;
    
    [self getQuestionList];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMoved:)];
    [self.view addGestureRecognizer:pan];
    [pan release];
    
    UIButton *tap = [[UIButton alloc] initWithFrame:self.contentView.bounds];
    [self.contentView insertSubview:tap atIndex:0];
    [tap addTarget:self action:@selector(panMoved:) forControlEvents:UIControlEventTouchUpInside];
    [tap release];
    
    
    
    // Do any additional setup after loading the view from its nib.
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    [self addBackButton];
    [self addRightButtonWithTitle:@"发送"];
    [self setShouldAutoRefreshData:NO];
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    
    self.titleLabel.text = @"爆料/提问";
    
    UIImageView *mazhi = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mazhi_back"]] autorelease];
    [self.contentView addSubview:mazhi];
    mazhi.frame = CGRectMake(0, 44, mazhi.frame.size.width, mazhi.frame.size.height);
    
    
    
    UIImageView *textBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wm_input_back"]] autorelease];
    [self.contentView addSubview:textBack];
    textBack.frame = CGRectMake((320-textBack.frame.size.width)/2, 140, textBack.frame.size.width, textBack.frame.size.height);
    
    
    self.textField = [[[NKTextViewWithPlaceholder alloc] initWithFrame:CGRectMake(15, textBack.frame.origin.y, 290, textBack.frame.size.height-1)] autorelease];
    [self.contentView addSubview:_textField];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.delegate = self;
    _textField.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _textField.placeholderLabel.text = [NSString stringWithFormat:@"关于 %@ ...", self.man.name];
    
    self.seg = [NKSegmentControl segmentControlViewWithSegments:[NSArray arrayWithObjects:
                                                                 [NKSegment segmentWithNormalBack:[UIImage imageNamed:@"purview_seg_left_normal"] selectedBack:[UIImage imageNamed:@"purview_seg_left_click"] title:@"匿名" normalTextColor:[UIColor colorWithHexString:@"#A6937C"] andHighlightTextColor:[UIColor colorWithHexString:@"#59493F"]],
                                                                 [NKSegment segmentWithNormalBack:[UIImage imageNamed:@"purview_seg_mid_normal"] selectedBack:[UIImage imageNamed:@"purview_seg_mid_click"] title:@"私密" normalTextColor:[UIColor colorWithHexString:@"#A6937C"] andHighlightTextColor:[UIColor colorWithHexString:@"#59493F"]],
                                                                 [NKSegment segmentWithNormalBack:[UIImage imageNamed:@"purview_seg_right_normal"] selectedBack:[UIImage imageNamed:@"purview_seg_right_click"] title:@"公开" normalTextColor:[UIColor colorWithHexString:@"#A6937C"] andHighlightTextColor:[UIColor colorWithHexString:@"#59493F"]],
                                                                 nil] andDelegate:self];
    
    [self.contentView addSubview:_seg];
    _seg.center = CGPointMake(160, 80);
    
    [self addImagePickView];
    
    [self setUIForData];
    
    
    UIImageView *noticeBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_notice"]] autorelease];
    [self.contentView addSubview:noticeBack];
    noticeBack.frame = CGRectMake(0, 105, noticeBack.frame.size.width, noticeBack.frame.size.height);
    
    self.notice = [[[UILabel alloc] initWithFrame:CGRectMake(15, 2, 290, noticeBack.frame.size.height)] autorelease];
    [noticeBack addSubview:_notice];
    self.notice.backgroundColor = [UIColor clearColor];
    _notice.textAlignment = NSTextAlignmentCenter;
    _notice.textColor = [UIColor colorWithHexString:@"#968677"];
    _notice.font = [UIFont systemFontOfSize:10];
//    if (![[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"privacy"] boolValue]){
//        
//    }else {
//        [_seg selectSegment:1 shouldTellDelegate:YES];
//    }
    [_seg selectSegment:0 shouldTellDelegate:YES];
 
    
}

-(void)addImagePickView{
    
    UIImageView *imageBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baoliao_image_back"]] autorelease];
    [self.contentView addSubview:imageBack];
    imageBack.frame = CGRectMake(15, 146+80, imageBack.frame.size.width, imageBack.frame.size.height);
    imageBack.userInteractionEnabled = YES;
    
    self.pickButton = [[[UIButton alloc] initWithFrame:CGRectMake(12, 10, 81, 81)] autorelease];
    [imageBack addSubview:_pickButton];
    
    [_pickButton setImage:[UIImage imageNamed:@"baoliao_photo"] forState:UIControlStateNormal];
    [_pickButton setImage:[UIImage imageNamed:@"baoliao_photo_click"] forState:UIControlStateHighlighted];
    [_pickButton addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
    
    // Record button {{{
    
    WMRecordPlugin *recordButton = [[[WMRecordPlugin alloc] initWithFrame:CGRectMake(93, 0, 100, 100)] autorelease];
    recordButton.delegate = self;
    
    [imageBack addSubview:recordButton];
    
    self.recordButton = recordButton;
    
    // }}}
    
    self.askButtn = [[[UIButton alloc] initWithFrame:CGRectMake(194, 10, 81, 81)] autorelease];
    [imageBack addSubview:_askButtn];
    
    [_askButtn setImage:[UIImage imageNamed:@"baoliao_ask"] forState:UIControlStateNormal];
    [_askButtn setImage:[UIImage imageNamed:@"baoliao_ask_click"] forState:UIControlStateHighlighted];
    [_askButtn addTarget:self action:@selector(pickQuestion:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.voiceButton = [[[UIButton alloc] initWithFrame:CGRectMake(196, 10, 81, 81)] autorelease];
//    [imageBack addSubview:_voiceButton];
//    
//    [_voiceButton setImage:[UIImage imageNamed:@"baoliao_voice"] forState:UIControlStateNormal];
//    [_voiceButton setImage:[UIImage imageNamed:@"baoliao_voice_click"] forState:UIControlStateHighlighted];
//    [_voiceButton addTarget:self action:@selector(pickVoice:) forControlEvents:UIControlEventTouchUpInside];
    
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

-(void)pickQuestion:(id)sender
{
    if ([self.textField.text length] && alertCount == 0) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:@"提问会自动生成一个关于他的问题，替换你已经输入的内容，是否确认" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil] autorelease];
        alert.tag = ASK_ALERT;
        [alert show];
    }else {
        [self fillTextView];
    }
    alertCount++;
    
}

-(void)fillTextView
{
    NSLog(@"****: %@",questionList);
    int count = [questionList count];
    if (count >0) {
        int x = arc4random() % count;
        while (x==lastX) {
            x = arc4random() % count;
        }
        lastX = x;
        NSString *question = [questionList objectAtIndex:x];
        self.textField.text = question;
        self.content = self.textField.text;
    }
    
}

-(void)pickVoice:(id)sender
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:@"即将推出更多插件，敬请期待~如果有好点子，欢迎通过微博@薇蜜，或点击设置->建议反馈告诉我们" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
    //alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = MORE_ALERT;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ASK_ALERT && buttonIndex==1) {
        [self fillTextView];
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
    [_seg selectSegment:self.selectedIndex shouldTellDelegate:NO];
    
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
    playlist.center = CGPointMake(self.view.bounds.size.width / 2.0f - 2, 364.0f);
    [self.view addSubview:playlist];
}

@end
