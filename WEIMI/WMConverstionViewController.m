//
//  WMConverstionViewController.m
//  WEIMI
//
//  Created by steve on 13-9-9.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import <objc/runtime.h>

#import "WMAppDelegate.h"
#import "WMConverstionViewController.h"
#import "UIImage+NKImage.h"
#import "UIImage+Resize.h"
#import "WMIMInputView.h"

enum tWMConverstionViewTag {
    kWMConverstionViewTagDeleteMessageActionSheet = 1,
    kWMConverstionViewTagChoosePictureActionSheet,
    kWMConverstionViewTagConfirmDeleteOneAlertView,
    kWMConverstionViewTagConfirmDeleteAllAlertView
};

static void *AssocKeyOfMessage;
static void *AssocKeyOfMessage;
static void *AssocKeyOfNSIndexPath;

@interface WMConverstionViewController () <WMChatCellDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) WMIMInputView *converstionView;

@end

@implementation WMConverstionViewController
@synthesize converstionView;
@synthesize showMoreView;
@synthesize showMoreButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

+(id)conversationViewControllerForUser:(WMMUser *)user
{
    WMConverstionViewController *vc = [[WMConverstionViewController alloc] initWithNibName:nil
                                                                                    bundle:nil];
    vc.user = user;
    [NKNC pushViewController:vc animated:YES];
    return vc;
}

-(void)getFullUser:(WMMUser *)user
{
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getUserOK:) andFailedSelector:@selector(getUserFailed:)];
    
    [[WMUserService sharedWMUserService] getUserInfoByID:user.mid WithRequestDelegate:rd];
}

-(void)getUserOK:(NKRequest*)request{
    
    _user = [request.results lastObject];
    
    [self initMainUI];
    [self getMessages];
    
    //[self getUnreadMessage];
    
}

-(void)getUserFailed:(NKRequest*)request{
    
    
}

-(void)recieveRemoteNotification:(NSNotification*)anoti{
    
    NSDictionary *apn = [anoti object];
    
    NSDictionary *something = [apn objectOrNilForKey:@"acme"];
    if ([[something objectOrNilForKey:@"type"] isEqualToString:@"im"] && [[something objectOrNilForKey:@"id"]  integerValue] == [_user.mid integerValue]) {
        //[[self class] cancelPreviousPerformRequestsWithTarget:self];
        //[self getUnreadMessage];
        if (timer) {
            [timer invalidate];
        }
        [self getUnreadMessage];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.showTableView.tableHeaderView = nil;
    self.refreshHeaderView.hidden = YES;
    NSDictionary *imDic = [[WMNotificationCenter sharedNKNotificationCenter] imDic];
    if ([imDic isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = [imDic valueForKey:_user.mid];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            newMessageCount = [[dic valueForKey:@"all"] intValue];
        }
    }
    
    hasChangeStartOffset = NO;
    startOffset = 0.0f;
    currentOffset = 0.0f;
    
    self.headBar.frame = CGRectMake(0, 0, 320, 70);
    UIImageView *headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_detail_head"]];
    [self.headBar insertSubview:headImage atIndex:0];

    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapp:)];
//    [self.headBar addGestureRecognizer:tap];
    self.showTableView.frame = CGRectMake(0, self.headBar.frame.size.height+6, 320, NKContentHeight-50 );
    self.showTableView.backgroundColor = [UIColor whiteColor];
    
    //显示更多按钮
    showMoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, 40)];
    showMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(14, 3, 292, 34)];
    [showMoreButton setBackgroundImage:[UIImage imageNamed:@"more_button"] forState:UIControlStateNormal];
    [showMoreButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    showMoreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [showMoreButton addTarget:self action:@selector(getMoreData) forControlEvents:UIControlEventTouchUpInside];
    [showMoreView addSubview:showMoreButton];
    
    
    //self.showTableView.tableHeaderView = showMoreView;
    if ([_user.name length]>0) {
        [self initMainUI];
        [self getMessages];
    
    }else {
        [self getFullUser:_user];
    }
    
    
    //[self addRightButtonWithFontTitle:@"夜景模式"];
    
    showTableView.backgroundColor = [UIColor clearColor];
    showTableView.backgroundView  = nil;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"switch_%@",_user.mid]] isEqualToString:@"off"]) {
        self.view.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    }else {
        self.view.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    }
    
    self.shouldAutoRefreshData = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[WMAppDelegate shareAppDelegate] setShouldHideNoti:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveRemoteNotification:) name:NKRemoteNotificationKey object:nil];
}

-(void)getUnreadMessage
{
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getUnreadMessageOK) object:nil];
    
    NKRequestDelegate *rd  = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getUnreadMessageOK:) andFailedSelector:@selector(getUnreadMessageFailed:)];
    
    if ([self.dataSource count]>0) {
        WMMessage *newMessage = [self.dataSource objectAtIndex:0];
        [[WMIMService sharedWMIMService] checkForNewMessage:_user.mid last_id:newMessage.messageId andRequestDelegate:rd];
    }else {
        [[WMIMService sharedWMIMService] checkForNewMessage:_user.mid last_id:@"" andRequestDelegate:rd];
    }
    //[self performSelector:@selector(getUnreadMessage) withObject:nil afterDelay:15];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NKRemoteNotificationKey object:nil];
    [[WMAppDelegate shareAppDelegate] setShouldHideNoti:NO];
    [_delegate updateMessageCount:newMessageCount];
    [[WMNotificationCenter sharedNKNotificationCenter] getNotificationsCountDelay];
    _delegate = nil;
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getUnreadMessageOK) object:nil];
    if (timer) {
        [timer invalidate];
    }

}

-(void)getUnreadMessageOK:(NKRequest *)request
{
    if ([request.results count]>0) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        for (int i=[request.results count]-1; i>=0; i--) {
            [self.dataSource insertObject:[request.results objectAtIndex:i] atIndex:0];
            newMessageCount++;
            WMMessage *newMessage = [request.results objectAtIndex:i];
            if ([newMessage.type isEqualToString:@"4"]) {
                if ([newMessage.switchState isEqualToString:@"on"]) {
                    self.view.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
                    [[NSUserDefaults standardUserDefaults] setValue:@"on" forKey:[NSString stringWithFormat:@"switch_%@",_user.mid]];
                }else {
                    self.view.backgroundColor = [UIColor colorWithHexString:@"#333333"];
                    [[NSUserDefaults standardUserDefaults] setValue:@"off" forKey:[NSString stringWithFormat:@"switch_%@",_user.mid]];
                }
            }

        }
        [self.showTableView reloadData];
    }
    if (fabs(startOffset-currentOffset)<240 && [request.results count]>0) {
        [showTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataSource count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        hasChangeStartOffset = NO;
    }
}

-(void)getUnreadMessageFailed:(NKRequest *)request
{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!hasChangeStartOffset) {
        startOffset = scrollView.contentOffset.y;
        hasChangeStartOffset = YES;
    }else if (scrollView.contentOffset.y > startOffset) {
        startOffset = scrollView.contentOffset.y;
        hasChangeStartOffset = YES;
    }
    
    currentOffset = scrollView.contentOffset.y;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)headTapp:(id)sender{
    
    [self goBack:nil];
    
}

-(void)initMainUI
{
    NKKVOImageView *avatar = [[NKKVOImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
    [self.headBar insertSubview:avatar atIndex:0];
    [avatar bindValueOfModel:_user forKeyPath:@"avatar"];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 23, 180, 26)];
    [self.headBar addSubview:nameLabel];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
    nameLabel.font = [UIFont systemFontOfSize:24];
    nameLabel.text = _user.name;
    
    
    //[self addTimeLabel];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:nil];
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
    
    //[self addTableHeader];
    
    self.converstionView = [WMIMInputView inputViewWithTableView:self.showTableView dataSource:self.dataSource otherView:[NSArray arrayWithObjects:bottomBack, bottomShadow, whiteBg, nil]];
    self.converstionView.delegate = self;
    self.converstionView.enableSendButton = YES;
    [self.contentView addSubview:converstionView];
    
    
    converstionView.target = self;
    converstionView.action = @selector(sendTextMessage:);
    converstionView.recordSendAction = @selector(sendRecord:during:);
    
    //[self refreshData];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(255, 0, 54, 45)];
    [btn setImage:[UIImage imageNamed:@"chatSwitch"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    [btn addTarget:self action:@selector(changeViewBg) forControlEvents:UIControlEventTouchUpInside];
    [self.headBar addSubview:btn];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 70)];
    [button addTarget:self action:@selector(headTapp:) forControlEvents:UIControlEventTouchUpInside];
    [self.headBar addSubview:button];
    
}

-(void)showImageSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    
    sheet.tag = kWMConverstionViewTagChoosePictureActionSheet;
    [sheet showInView:NKNC.view];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
    
    case kWMConverstionViewTagDeleteMessageActionSheet: {
        switch (buttonIndex) {
        
        case 0: { // Delete one message
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:@"确定删除这条聊天记录吗？"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:@"确定", nil];
            
            NSIndexPath *indexPath = objc_getAssociatedObject(actionSheet, AssocKeyOfNSIndexPath);
            
            WMMessage *message = self.dataSource[[self.dataSource count] - indexPath.row - 1];
            
            objc_setAssociatedObject(alert, AssocKeyOfMessage, message, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            alert.tag = kWMConverstionViewTagConfirmDeleteOneAlertView;
            
            [alert show];
            
        }
            
            break;
            
        case 1: { // Delete all message
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:@"确定删除所有聊天记录吗？"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:@"确定", nil];
            
            NSIndexPath *indexPath = objc_getAssociatedObject(actionSheet, AssocKeyOfNSIndexPath);
            
            WMMessage *message = self.dataSource[[self.dataSource count] - indexPath.row - 1];
            
            objc_setAssociatedObject(alert, AssocKeyOfMessage, message, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            alert.tag = kWMConverstionViewTagConfirmDeleteAllAlertView;
            
            [alert show];
            
        }
            
            break;
            
        default:
            
            break;
        }
    }
        
        break;
        
    case kWMConverstionViewTagChoosePictureActionSheet: {
        
        switch (buttonIndex) {
        
        case 0:{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController * pickerController = [[UIImagePickerController alloc] init];
                pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerController.delegate = self;
                [self presentModalViewController:pickerController animated:YES];
            }
            else{
                
                UIImagePickerController * pickerController = [[UIImagePickerController alloc] init];
                pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                pickerController.delegate = self;
                [self presentModalViewController:pickerController animated:YES];
            }
            
            break;
            
        }
            
        case 1:{
            UIImagePickerController * pickerController = [[UIImagePickerController alloc] init];
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.delegate = self;
            [self presentModalViewController:pickerController animated:YES];
            
            break;
        }
            
        default:
                
            break;
        }
        
    }
        
        break;
        
    default:
            
        break;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
    
    case kWMConverstionViewTagConfirmDeleteOneAlertView: {
        
        if (buttonIndex == 1) {
            
            NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(deleteOneMessageOK:) andFailedSelector:@selector(deleteOneMessageFailed:)];
            
            // Get the message that associated with action sheet
            
            WMMessage *message = objc_getAssociatedObject(alertView, AssocKeyOfMessage);
            
            ProgressLoading;
            
            NKRequest *request = [[WMIMService sharedWMIMService] deleteOneMessage:message andRequestDelegate:rd];
            
            objc_setAssociatedObject(request, AssocKeyOfMessage, message, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
        }
        
    }
        
        break;
        
    case kWMConverstionViewTagConfirmDeleteAllAlertView: {
        
        if (buttonIndex == 1) {
            
            NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(deleteAllMessageOK:) andFailedSelector:@selector(deleteAllMessageFailed:)];
            
            ProgressLoading;
            
            [[WMIMService sharedWMIMService] deleteAllMessage:self.user andRequestDelegate:rd];
            
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
    [self addMessage:selectedImage userInfo:nil];
    [picker dismissNKViewControllerAnimated:YES completion:nil];
    
}

-(void)changeViewBg
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"switch_%@",_user.mid]] isEqualToString:@"off"]) {
        [self addSwitchMessage:@"*把灯开了*" type:@"on"];
    }else {
        [self addSwitchMessage:@"*把灯关了*" type:@"off"];
    }
    
}


-(void)addSwitchMessage:(NSString *)content type:(NSString *)type
{
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(postOK:) andFailedSelector:@selector(postFailed:)];
    NKRequest *request = [[WMIMService sharedWMIMService] postIM:@"4" user_id:_user.mid content:[content dataUsingEncoding:NSUTF8StringEncoding] audio_seconds:nil switchState:type  andRequestDelegate:rd];
    WMMessage *message = [[WMMessage alloc] init];
    message.sender = [WMMUser me];
    message.type = @"4";
    message.content = [content dataUsingEncoding:NSUTF8StringEncoding];
    message.contentText = content;
    message.createAt = [NSDate date];
    message.sendState = ZUOMMessageSendStateSending;
    [self.dataSource insertObject:message atIndex:0];
    
    request.userInfo = [NSDictionary dictionaryWithObject:message forKey:@"message"];
    
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:[self.dataSource count]-1 inSection:0];
    
    [showTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:lastIndex] withRowAnimation:UITableViewRowAnimationFade];
    [showTableView reloadData];
    [showTableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self setPullBackFrame];

}

#pragma mark Data

-(void)getMessages{
    
    NKRequestDelegate *rd  = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    
    [[WMIMService sharedWMIMService] getIMList:_user.mid last_id:nil size:MESSAGECOUNT andRequestDelegate:rd];
    
}

-(void)refreshDataOK:(NKRequest *)request{
    
    [super refreshDataOK:request];
    //[self headerLogic];
    BOOL showCheckOn = YES;
    for (int i=0; i<[request.results count]; i++) {
        WMMessage *newMessage = [request.results objectAtIndex:i];
        
        if ([newMessage.type isEqualToString:@"4"] && showCheckOn) {
            showCheckOn = NO;
            if ([newMessage.switchState isEqualToString:@"on"]) {
                self.view.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
                [[NSUserDefaults standardUserDefaults] setValue:@"on" forKey:[NSString stringWithFormat:@"switch_%@",_user.mid]];
                
            }else {
                self.view.backgroundColor = [UIColor colorWithHexString:@"#333333"];
                [[NSUserDefaults standardUserDefaults] setValue:@"off" forKey:[NSString stringWithFormat:@"switch_%@",_user.mid]];
            }
        }
    }
    [showMoreButton setTitle:@"显示更多" forState:UIControlStateNormal];
    if ([request.hasMore boolValue]) {
        self.showTableView.tableHeaderView = showMoreView;
    }else {
        self.showTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    }
    if ([self.dataSource count]) {
        [showTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataSource count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(getUnreadMessage) userInfo:nil repeats:YES];
    
}

#pragma mark Get Feeds
-(void)getMoreData
{
    gettingMoreData = YES;
    NKRequestDelegate *rd  = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
    WMMessage *lastMessage = [self.dataSource lastObject];
    [[WMIMService sharedWMIMService] getIMList:_user.mid last_id:lastMessage.messageId size:MESSAGECOUNT andRequestDelegate:rd];
}
-(void)getMoreDataFailed:(NKRequest*)ticket{
    [super getMoreDataFailed:ticket];
    [showMoreButton setTitle:@"显示更多" forState:UIControlStateNormal];
}

-(void)getMoreDataOK:(NKRequest*)request{
    [super getMoreDataOK:request];
    
    if ([self.dataSource count]) {
        [self.showTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[request.results count] inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
    [showMoreButton setTitle:@"显示更多" forState:UIControlStateNormal];
    
    //hasMore = [ticket.hasMore boolValue];
    
    if ([request.hasMore boolValue]) {
        self.showTableView.tableHeaderView = showMoreView;
    }else {
        self.showTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMMessage *message = [self.dataSource objectAtIndex:[self.dataSource count] - 1 - indexPath.row];
    if ([message.sender.mid isEqualToString:[[WMMUser me] mid]]) {
        message.sender = [WMMUser me];
    }else {
        message.sender = _user;
    }
    return [WMChatCell cellHeightForObject:message allMessages:self.dataSource];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"WMChatCell";
    
    WMChatCell *cell = (WMChatCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WMChatCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    WMMessage *message = [self.dataSource objectAtIndex:[self.dataSource count] - 1 - indexPath.row];
    if ([message.sender.mid isEqualToString:[[WMMUser me] mid]]) {
        message.sender = [WMMUser me];
    }else {
        message.sender = _user;
    }
    [cell showForObject:message allMessages:self.dataSource];
    
    return cell;
    
}

#pragma mark - WMChatCellDelegate

- (void)messageDidLongPress:(WMChatCell *)cell {
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:@"取消"
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"删除这条记录", @"删除和她的所有聊天记录", nil];
    
    NSIndexPath *indexPath = [self.showTableView indexPathForCell:cell];
    
    objc_setAssociatedObject(sheet, AssocKeyOfNSIndexPath, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    sheet.tag = kWMConverstionViewTagDeleteMessageActionSheet;
    
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - Delete message callbacks

- (void)deleteOneMessageOK:(NKRequest *)request {
    ProgressHide;
    
    WMMessage *message = objc_getAssociatedObject(request, AssocKeyOfMessage);
    
    [self.dataSource removeObject:message];
    
    [self.showTableView reloadData];
}

- (void)deleteOneMessageFailed:(NKRequest *)request {
    ProgressErrorDefault;
}

- (void)deleteAllMessageOK:(NKRequest *)request {
    
    [self.dataSource removeAllObjects];
    
    [self.showTableView reloadData];
    
    ProgressHide;
}

- (void)deleteAllMessageFailed:(NKRequest *)request {
    ProgressErrorDefault;
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)sendTextMessage:(NSString *)text {
    [self addMessage:text userInfo:nil];
}

-(void)sendRecord:(NSData *)record during:(NSNumber *)during {
    [self addMessage:record userInfo:during];
}

-(void)addMessage:(id)content userInfo:(id)userInfo;
{
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(postOK:) andFailedSelector:@selector(postFailed:)];
    if ([content isKindOfClass:[NSString class]]) {
        if ([[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            return;
        }
        
        NKRequest *request = [[WMIMService sharedWMIMService] postIM:@"1" user_id:_user.mid content:[content dataUsingEncoding:NSUTF8StringEncoding] audio_seconds:nil switchState:nil andRequestDelegate:rd];
        WMMessage *message = [[WMMessage alloc] init];
        message.sender = [WMMUser me];
        message.content = [content dataUsingEncoding:NSUTF8StringEncoding];
        message.contentText = content;
        message.type = @"1";
        message.createAt = [NSDate date];
        message.sendState = ZUOMMessageSendStateSending;
        [self.dataSource insertObject:message atIndex:0];
        
        request.userInfo = [NSDictionary dictionaryWithObject:message forKey:@"message"];
        
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:[self.dataSource count]-1 inSection:0];
        
        [showTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:lastIndex] withRowAnimation:UITableViewRowAnimationFade];
        [showTableView reloadData];
        [showTableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self setPullBackFrame];
        [converstionView sendOK];
    } else if ([content isKindOfClass:[NSData class]]) {
        NKRequest *request = [[WMIMService sharedWMIMService] postIM:@"3" user_id:_user.mid content:content audio_seconds:[userInfo stringValue] switchState:nil andRequestDelegate:rd];
        WMMessage *message = [[WMMessage alloc] init];
        message.sender = [WMMUser me];
        message.type = @"3";
        message.content = content;
        message.audioLength = userInfo;
        //message.image = content;
        //message.contentText = content;
        message.createAt = [NSDate date];
        message.sendState = ZUOMMessageSendStateSending;
        [self.dataSource insertObject:message atIndex:0];
        
        request.userInfo = [NSDictionary dictionaryWithObject:message forKey:@"message"];
        
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:[self.dataSource count]-1 inSection:0];
        
        [showTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:lastIndex] withRowAnimation:UITableViewRowAnimationFade];
        [showTableView reloadData];
        [showTableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self setPullBackFrame];
        [converstionView sendOK];
        
    }else if ([content isKindOfClass:[UIImage class]]) {
        NKRequest *request = [[WMIMService sharedWMIMService] postIM:@"2" user_id:_user.mid content:UIImageJPEGRepresentation(content, 0.5) audio_seconds:nil switchState:nil andRequestDelegate:rd];
        WMMessage *message = [[WMMessage alloc] init];
        message.sender = [WMMUser me];
        message.type = @"2";
        message.content = UIImageJPEGRepresentation(content, 0.5);
        message.image = content;
        //message.contentText = content;
        message.createAt = [NSDate date];
        message.sendState = ZUOMMessageSendStateSending;
        [self.dataSource insertObject:message atIndex:0];
        
        request.userInfo = [NSDictionary dictionaryWithObject:message forKey:@"message"];
        
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:[self.dataSource count]-1 inSection:0];
        
        [showTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:lastIndex] withRowAnimation:UITableViewRowAnimationFade];
        [showTableView reloadData];
        [showTableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self setPullBackFrame];
        [converstionView sendOK];
    }
}

-(void)setPullBackFrame{
    
    self.converstionView.dataSource = self.dataSource;
    
}
-(void)postOK:(NKRequest *)request
{
    WMMessage *newMessage = [request.results lastObject];
    
    newMessage.sendState =  ZUOMMessageSendStateSuccess;
    [self.dataSource replaceObjectAtIndex:0 withObject:newMessage];
    [self.showTableView reloadData];
    
    WMMessage *message = [request.userInfo objectOrNilForKey:@"message"];
    message.sendState = ZUOMMessageSendStateSuccess;
    [self.converstionView sendOK];
    [self setPullBackFrame];
    newMessageCount ++;
    [_delegate updateMessageCount:newMessageCount];
    
    if ([newMessage.type isEqualToString:@"4"]) {
        if ([newMessage.switchState isEqualToString:@"on"]) {
            self.view.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
            [[NSUserDefaults standardUserDefaults] setValue:@"on" forKey:[NSString stringWithFormat:@"switch_%@",_user.mid]];
        }else {
            self.view.backgroundColor = [UIColor colorWithHexString:@"#333333"];
            [[NSUserDefaults standardUserDefaults] setValue:@"off" forKey:[NSString stringWithFormat:@"switch_%@",_user.mid]];
        }
    }
}

-(void)postFailed:(NKRequest *)request
{
    ProgressErrorDefault;
    WMMessage *message = [request.userInfo objectOrNilForKey:@"message"];
    message.sendState = ZUOMMessageSendStateFailed;
}

#pragma mark Gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if ([[otherGestureRecognizer view] isKindOfClass:[UITableView class]]) {
        [self.converstionView.textView setDefaultPlaceHolder:nil];
        [converstionView hide];
        return YES;
    }
    
    return NO;
}


@end
