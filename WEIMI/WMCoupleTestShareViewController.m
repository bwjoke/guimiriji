//
//  WMCoupleTestShareViewController.m
//  WEIMI
//
//  Created by Tang Tianyong on 10/11/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMCoupleTestShareViewController.h"
#import "UIImage+Adaptive.h"
#import "KRShare.h"
#import "WXApi.h"
#import <RennSDK/RennSDK.h>
#import "WMAppDelegate.h"

@interface WMCoupleTestShareViewController () <KRShareRequestDelegate, KRShareDelegate, RennLoginDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *manAvatarImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *womanAvatarImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *scoreLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *remarkLabel;

@end

@implementation WMCoupleTestShareViewController {
    UIView *_shareLayer;
    UIImage *_image;
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
    
    self.titleLabel.text = @"测试结果";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    [self.headBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] atIndex:0];
    
    [self addBackButton];
    
    NSString *nibName = @"CoupleTestShare";
    
    if ([UIImage isIPhone5]) {
        nibName = @"CoupleTestShare-568h";
    }
    
    _shareLayer = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil][0];
    
    CGRect frame = _shareLayer.frame;
    frame.origin.y = 44.0f;
    _shareLayer.frame = frame;
    
    [self.contentView addSubview:_shareLayer];
    
    self.manAvatarImageView.image = self.manAvatar;
    self.womanAvatarImageView.image = self.womanAvatar;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f", self.score];
    self.remarkLabel.text = self.remark;
    
    self.womanAvatarImageView.layer.cornerRadius = 5.0;
    self.womanAvatarImageView.clipsToBounds = YES;
    self.manAvatarImageView.layer.cornerRadius = 5.0;
    self.manAvatarImageView.clipsToBounds = YES;
    
    [self roundView:self.womanAvatarImageView.superview];
    [self roundView:self.manAvatarImageView.superview];
    
    // Create the image
    
    [self getShareImage];
    
    [self addShareButtons];
}

- (void)addShareButtons {
    UIView *shareBar = [[NSBundle mainBundle] loadNibNamed:@"CoupleTestShareBar" owner:self options:nil][0];
    CGRect shareBarFrame = (CGRect){0.0f, 394.0f, shareBar.frame.size};
    
    if ([UIImage isIPhone5]) {
        shareBarFrame.origin.y = 482.0f;
    }
    
    shareBar.frame = shareBarFrame;
    
    [self.contentView addSubview:shareBar];
}

//根据要求创建缩略图
-(UIImage *)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent toPath:(NSString *)thumbPath{
    
    CGSize imageSize = image.size;
    
    CGFloat width = imageSize.width;
    
    CGFloat height = imageSize.height;
    
    CGFloat scaleFactor = 0.0;
    
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    
    CGFloat widthFactor = thumbSize.width / width;
    
    CGFloat heightFactor = thumbSize.height / height;
    
    if (widthFactor > heightFactor)  {
        scaleFactor = widthFactor;
    }else {
        scaleFactor = heightFactor;
    }
    CGFloat scaledWidth  = width * scaleFactor;
    
    CGFloat scaledHeight = height * scaleFactor;
    
    if (widthFactor > heightFactor){
        thumbPoint.y = (thumbSize.height - scaledHeight) * 0.5;
    }else if (widthFactor < heightFactor){
        thumbPoint.x = (thumbSize.width - scaledWidth) * 0.5;
    }
    
    UIGraphicsBeginImageContext(thumbSize);
    
    CGRect thumbRect = CGRectZero;
    
    thumbRect.origin = thumbPoint;
    
    thumbRect.size.width  = scaledWidth;
    
    thumbRect.size.height = scaledHeight;
    
    [image drawInRect:thumbRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return thumbImage;
    
}

#pragma mark - Share actions

// Share to weixin

- (IBAction)shareToWeixin:(id)sender {
    [self shareImageToWeixin:WXSceneSession];
}

-(void)shareImageToWeixin:(int)scene
{
    UIImage *shareImage = [self getShareImage];
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[self createThumbImage:shareImage size:CGSizeMake(114, 114) percent:0.5 toPath:nil]];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(shareImage, 0.5f);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;

    BOOL success = [WXApi sendReq:req];
    if (!success) {
        ProgressFailedWith(@"请检查是否安装了微信");
    }
}

- (IBAction)shareToPengyou:(id)sender {
    [self shareImageToWeixin:WXSceneTimeline];
}

- (IBAction)shareToWeibo:(id)sender {
    NSString *accessToken = [[[NKSocial social] sinaWeibo] accessToken];
    
    if (accessToken) {
        [self shareToWeiboCanBegin];
    } else {
        [self loginWeibo];
    }
}

- (void)loginWeibo {
    WMAppDelegate *appDelegate = [WMAppDelegate shareAppDelegate];
    appDelegate.isLogin = YES;
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(loginWithWeiboOK:) andFailedSelector:@selector(loginWithWeiboFailed:)];
    [[NKSocial social] loginWithSinaWeiboWithRequestDelegate:rd];
}

-(void)loginWithWeiboOK:(NKRequest*)request {
    [self shareToWeiboCanBegin];
}

-(void)loginWithWeiboFailed:(NKRequest*)request{
    ProgressFailedWith(@"授权失败");
}

- (void)shareToWeiboCanBegin {
    KRShare *share = [KRShare sharedInstanceWithTarget:KRShareTargetSinablog];
    share.delegate = self;
    
    share.accessToken = [[[NKSocial social] sinaWeibo] accessToken];
    
    UIImage *shareImage = [self getShareImage];
    
    Progress(@"正在分享");
    
    [share requestWithURL:@"statuses/upload.json"
                   params:[NSMutableDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"#夫妻相大测试# %.1f分~下载薇蜜APP，测测两个人的夫妻相指数！下载地址：http://www.weimi.com/app?from=fqxweiboshare", self.score], @"status", shareImage, @"pic", nil]
               httpMethod:@"POST"
                 delegate:self];
}

- (IBAction)shareToRenren:(id)sender {
    NSString *accessToken = [RennClient accessToken].accessToken;
    
    if (accessToken) {
        [self shareToRenrenCanBegin];
    } else {
        [RennClient loginWithDelegate:self];
    }
}

#pragma mark - RennLoginDelegate

- (void)rennLoginSuccess {
    [self shareToRenrenCanBegin];
}

- (void)rennLoginDidFailWithError:(NSError *)error {
    ProgressFailedWith(@"授权失败");
}

- (void)rennLoginCancelded {
    // TODO
}

- (void)rennLoginAccessTokenInvalidOrExpired:(NSError *)error {
    // TODO
}

- (void)shareToRenrenCanBegin {
    KRShare *share = [KRShare sharedInstanceWithTarget:KRShareTargetRenrenblog];
    share.delegate = self;
    
    // Now, accessToken is aviable
    share.accessToken = [RennClient accessToken].accessToken;
    
    UIImage *shareImage = [self getShareImage];
    
    Progress(@"正在分享");
    
    [share requestWithURL:@"restserver.do"
                   params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                           @"1.0",@"v",
                           [NSString stringWithFormat:@"#夫妻相大测试# %.1f分~下载薇蜜APP，测测两个人的夫妻相指数！下载地址：http://www.weimi.com/app?from=fqxrenrenshare", self.score], @"caption",
                           @"json",@"format",
                           @"photos.upload",@"method",
                           shareImage,@"upload",
                           kRenrenBroadAppKey,@"api_key",
                           nil]
               httpMethod:@"POST"
                 delegate:self];
}

-(void)request:(KRShareRequest *)request didFailWithError:(NSError *)error {
    ProgressFailedWith(@"分享失败");
}


- (void)request:(KRShareRequest *)request didFinishLoadingWithResult:(id)result {
    ProgressSuccess(@"分享成功");
}

#pragma mark - Get image

- (UIImage *)getShareImage {
    if (_image != nil) {
        return _image;
    }
    
    NSString *nibName = @"CoupleTestRealShare";
    
    if ([UIImage isIPhone5]) {
        nibName = @"CoupleTestRealShare-568h";
    }
    
    UIView *realShareLayer = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil][0];
    
    UIImageView *womanAvatarView = (UIImageView *)[realShareLayer viewWithTag:1];
    UIImageView *manAvatarView = (UIImageView *)[realShareLayer viewWithTag:2];
    UILabel *scoreLabel = (UILabel *)[realShareLayer viewWithTag:3];
    UILabel *remarkLabel = (UILabel *)[realShareLayer viewWithTag:4];
    
    womanAvatarView.layer.cornerRadius = 5.0;
    womanAvatarView.clipsToBounds = YES;
    manAvatarView.layer.cornerRadius = 5.0;
    manAvatarView.clipsToBounds = YES;
    
    [self roundView:womanAvatarView];
    [self roundView:manAvatarView];
    
    [self roundView:womanAvatarView.superview];
    [self roundView:manAvatarView.superview];
    
    womanAvatarView.image = self.womanAvatar;
    manAvatarView.image = self.manAvatar;
    scoreLabel.text = [NSString stringWithFormat:@"%.1f", self.score];
    remarkLabel.text = self.remark;
    
    UIGraphicsBeginImageContextWithOptions(realShareLayer.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [[realShareLayer layer] renderInContext:UIGraphicsGetCurrentContext()];
    _image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // Save to album
    if ([[[WMMUser me] mid] isEqualToString:@"1643433"]) {
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }else {
        UIImageWriteToSavedPhotosAlbum(_image, nil, nil, nil);
    }
    
    
    return _image;
}

- (void)roundView:(UIView *)view {
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowRadius = 1;
    view.layer.shadowOpacity = 0.3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setManAvatarImageView:nil];
    [self setWomanAvatarImageView:nil];
    [self setScoreLabel:nil];
    [self setRemarkLabel:nil];
    [super viewDidUnload];
}

- (void)goBack:(id)sender {
    [super goBack:sender];
    
    if (self.goBackAction) {
        self.goBackAction();
    }
}

@end
