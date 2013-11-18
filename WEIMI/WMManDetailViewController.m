//
//  WMManDetailViewController.m
//  WEIMI
//
//  Created by King on 11/22/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMManDetailViewController.h"
#import "WMFeedCell.h"
#import "WMPostViewController.h"
#import "WMFeedDetailViewController.h"
#import "WMAddRateViewController.h"
#import "WMManUserCell.h"
#import "WMGirlToManViewController.h"
#import "WMAddBaoliaoViewController.h"

#import "WMManPhotosViewController.h"
#import "WMAddTagViewController.h"

#import "WMNotificationCenter.h"
#import "WMCustomLabel.h"

#import "WMTagLabel.h"
#import "WMLineLabel.h"
#import "WMAppDelegate.h"

#import "WMWeiboPageViewController.h"
#import "WMManFeedBackViewController.h"

#import "WMMenWikiPageViewController.h"

@interface WMManDetailViewController ()
{
    UIButton *actionButton,*rateButton;
    NSString *tagString,*descString;
    WMMFeed *reportFeed;
    BOOL shouldNotGetContent;
}
@end

@implementation WMManDetailViewController

#define INVITE_TAG 123120
#define SHARE_TAG 112320
#define SHOW_REPORT_SHEET 13062401
#define REPORT_SHEET 13062402

#define SHARETITLE @"姑娘们对 XXX 的点评，八卦 | 薇蜜"
#define WEIXINTEXT @"闺蜜姐妹专属私密分享，人物点评社区。男神渣男匿名点评，八卦爆料，男友前男友男同学男同事男上司男明星大百科，让天下没有难懂的男人"
#define WEIBOTEXT @"让天下没有难懂的男人。女生匿名对男友前男友、男明星、男同学、男同事男上司点评打分、八卦爆料的社交应用，这里有让@留几手都无法直视的气场。"
#define SMSTEXT @"薇蜜是专为闺蜜姐妹们设计的手机客户端，还有点评王子渣男功能，下载一个试试吧：http://www.weimi.com/app?from=sms"
#define QQZONETEXT @"今天开始玩薇蜜啦！/转圈 这是专为闺蜜姐妹们设计的手机客户端，还有点评王子渣男功能 /可爱 苹果手机下载：http://www.weimi.com/app?from=qzone"
#define TENCENTTEXT @"今天开始玩薇蜜啦！这是专为闺蜜姐妹们设计的手机客户端，还有点评王子渣男功能。苹果手机下载：http://www.weimi.com/app?from=tqq"
#define RENRENTEXT @"在薇蜜看到了有人对 XXX 的点评…"

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NKAddFeedOKNotificationKey object:nil];
    
    [_man release];
    [super dealloc];
}

+(id)manDetailWithMan:(WMMMan*)man{
    
    WMManDetailViewController *manDetail = [[self alloc] init];
    manDetail.man = man;
    [NKNC pushViewController:manDetail animated:YES];
    [manDetail release];
    
    return manDetail;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFeedOK:) name:NKAddFeedOKNotificationKey object:nil];
    }
    return self;
}

-(void)addFeedOK:(NSNotification*)noti{
    
//    [self.dataSource addObject:[noti object]];
//    [showTableView reloadData];
    
}

-(void)addTableViewHeader{
    
    
    CGFloat height = 145;
    UIFont *tagFont = [UIFont systemFontOfSize:14];
    CGFloat tagHeight = 0;
    
    UIView *tableViewHeader = [[UIView alloc] init];


    UIButton *tagBgView = [[[UIButton alloc] initWithFrame:CGRectMake(0, 105, 320, 30)] autorelease];
    [tagBgView setBackgroundImage:[[UIImage imageNamed:@"redfeed"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateHighlighted];
    [tagBgView addTarget:self action:@selector(viewTag:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeader addSubview:tagBgView];
    int numOfLine = 0;
    if ([self.man.tags count]) {
        NSArray *colors = [NSArray arrayWithObjects:[UIImage imageNamed:@"tag_bg_1"],[UIImage imageNamed:@"tag_bg_2"],[UIImage imageNamed:@"tag_bg_3"],[UIImage imageNamed:@"tag_bg_4"], nil];
        
        if ([self.man.tags count]) {
            CGFloat totalWidth = 15;
            
            for (int i=0; i<[self.man.tags count]; i++) {
                NSString *manTag = @"";
                //NSString *lastManTag = @"";
                manTag = [NSString stringWithFormat:@"%@(%@)", [[self.man.tags objectAtIndex:i] name], [[self.man.tags objectAtIndex:i] supportCount]];
                if (i>0) {
                    //lastManTag = [NSString stringWithFormat:@"%@(%@)", [[self.man.tags objectAtIndex:i-1] name], [[self.man.tags objectAtIndex:i-1] supportCount]];
                }
                
                if (totalWidth+[WMTagLabel widthOfLabel:manTag type:1]>275) {
                    totalWidth = 15;
                    tagHeight += 35;
                    numOfLine += 1;
                }
                WMTagLabel *tags = [[[WMTagLabel alloc] initWithFrame:CGRectMake(totalWidth, tagHeight, [WMTagLabel widthOfLabel:manTag type:1], 30) tag:manTag color:[colors objectAtIndex:i>3?3:i] type:1] autorelease];
                totalWidth += [WMTagLabel widthOfLabel:manTag type:1]+5;
                
                [tagBgView insertSubview:tags atIndex:0];
            }
            
        }
        
        tagHeight += 35;
        CGRect tagFrame = tagBgView.frame;
        tagFrame.size.height = tagHeight;
        tagBgView.frame = tagFrame;
        
        height = height+35*numOfLine;
    }else {
        UILabel *tagsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 115, 280, 15)] autorelease];
        tagsLabel.text = @"他的特点/缺点/优点…";
        tagsLabel.backgroundColor = [UIColor clearColor];
        tagsLabel.numberOfLines = 0;
        tagsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        tagsLabel.font = tagFont;
        tagsLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
        [tableViewHeader addSubview:tagsLabel];
    }
    
    UIView *relationView = [[[UIView alloc] initWithFrame:CGRectMake(0, height, 320, 30)] autorelease];
    [tableViewHeader addSubview:relationView];
    
    UIButton *relationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [relationButton setBackgroundImage:[[UIImage imageNamed:@"redfeed"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateHighlighted];
    [relationButton addTarget:self action:@selector(goToRelationPage:) forControlEvents:UIControlEventTouchUpInside];
    [relationView addSubview:relationButton];
    [relationButton release];
    
    WMCustomLabel *relationLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(15, 7, 202, 16) font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"#7E6B5A"]];
    [relationLabel adjustsFontSizeToFitWidth];
    relationLabel.text = [NSString stringWithFormat:@"%@，现在/历史交往对象名单",_man.gfStatus];
    if ([relationLabel respondsToSelector:@selector(setFont:range:)]) {
        [relationLabel setFont:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, 3)];
    }
    [relationView addSubview:relationLabel];
    [relationLabel release];
    
    WMCustomLabel *countLabel = [[[WMCustomLabel alloc] initWithFrame:CGRectMake(224, 5, 44, 20)] autorelease];
    [countLabel setRoundBackgroundWithText:[NSString stringWithFormat:@"%@人",[_man.gfCount stringValue]] bgColor:[UIColor colorWithHexString:@"#EB6877"] fontSize:14 textColor:[UIColor whiteColor]];
    [relationView addSubview:countLabel];
    
    UIImageView *relationArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]] autorelease];
    [tableViewHeader addSubview:relationArrow];
    relationArrow.center = CGPointMake(305, relationView.center.y-1);
    
    height = height +30;
    
    
    
    // 他喜欢/讨厌/擅长/害怕 {{{
    
    UIView *characterView = [[[UIView alloc] initWithFrame:CGRectMake(0, height, 320, 30)] autorelease];
    [tableViewHeader addSubview:characterView];
    
    UIButton *characterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [characterButton setBackgroundImage:[[UIImage imageNamed:@"redfeed"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateHighlighted];
    [characterButton addTarget:self action:@selector(goToInterestPage:) forControlEvents:UIControlEventTouchUpInside];
    [characterView addSubview:characterButton];
    [characterButton release];
    
    WMCustomLabel *characterLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(15, 7, 202, 16) font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"#7E6B5A"]];
    [characterLabel adjustsFontSizeToFitWidth];
    characterLabel.text = [NSString stringWithFormat:@"他喜欢/讨厌/擅长/害怕..."];
//    if ([characterLabel respondsToSelector:@selector(setFont:range:)]) {
//        [characterLabel setFont:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, 3)];
//    }
    [characterView addSubview:characterLabel];
    [characterLabel release];
    
    WMCustomLabel *characterCountLabel = [[[WMCustomLabel alloc] initWithFrame:CGRectMake(175, 5, 44, 20)] autorelease];
    [characterCountLabel setRoundBackgroundWithText:[NSString stringWithFormat:@"%@",[_man.interestCount stringValue]] bgColor:[UIColor colorWithHexString:@"#EB6877"] fontSize:14 textColor:[UIColor whiteColor]];
    [characterView addSubview:characterCountLabel];
    
    UIImageView *characterArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]] autorelease];
    [tableViewHeader addSubview:characterArrow];
    characterArrow.center = CGPointMake(305, characterView.center.y-1);
    
    // }}}
    
    height = height +30;
    
    height += 5.0f;
    
    tableViewHeader.frame = CGRectMake(0, 0, 320, height);
    tableViewHeader.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
    
    NKKVOImageView *avatar = [[NKKVOImageView alloc] initWithFrame:CGRectMake(18, 12, 75, 75)];
    [tableViewHeader addSubview:avatar];
    [avatar release];
    [avatar bindValueOfModel:self.man forKeyPath:@"avatarBig"];
    avatar.target = self;
    avatar.singleTapped = @selector(avatarTapped:);
    
    UIImageView *avatarBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_album_back"]] autorelease];
    [tableViewHeader insertSubview:avatarBack belowSubview:avatar];
    avatarBack.center = CGPointMake(avatar.center.x, avatar.center.y+0.8);
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 13, 192, 25)];
    [tableViewHeader addSubview:nameLabel];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:24];
    nameLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
    [nameLabel release];
    nameLabel.text = self.man.name;
    
    UIButton *modifyButton = [[[UIButton alloc] initWithFrame:CGRectMake(287, 8, 30, 30)] autorelease];
    [tableViewHeader addSubview:modifyButton];
    modifyButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [modifyButton setTitleColor:[UIColor colorWithHexString:@"#7E6B5A"] forState:UIControlStateNormal];
    [modifyButton setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
    [modifyButton addTarget:self action:@selector(modifyMan:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat weiboEnd = 110;
    if ([self.man.weiboName length]) {
        weiboEnd += [[NSString stringWithFormat:@"@%@",self.man.weiboName] sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(120, 10) lineBreakMode:NSLineBreakByCharWrapping].width;
    }
    
    WMLineLabel *weiboLabel = [[[WMLineLabel alloc] initWithFrame:CGRectMake(110, 40, weiboEnd-110, 16) fontSize:10] autorelease];
    weiboLabel.text = [NSString stringWithFormat:@"@%@",self.man.weiboName];
    [tableViewHeader addSubview:weiboLabel];
    
    UIButton *weiboBtn = [[[UIButton alloc] initWithFrame:CGRectMake(110, 40, weiboEnd-110, 16)] autorelease];
    [weiboBtn setBackgroundImage:[[UIImage imageNamed:@"redfeed"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateHighlighted];
    [weiboBtn addTarget:self action:@selector(viewWeibo:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeader insertSubview:weiboBtn belowSubview:weiboLabel];
    
    
    UILabel *xinzuoLabel = [[UILabel alloc] initWithFrame:CGRectMake(weiboEnd, 44, 120, 10)];
    [tableViewHeader addSubview:xinzuoLabel];
    xinzuoLabel.backgroundColor = [UIColor clearColor];
    xinzuoLabel.font = [UIFont systemFontOfSize:10];
    xinzuoLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
    if ([self.man.weiboName length] && [self.man.constellation length]) {
        xinzuoLabel.text = [NSString stringWithFormat:@" | %@",self.man.constellation];
    }else {
        xinzuoLabel.text = self.man.constellation;
    }
    
    [xinzuoLabel release];
    
    
    //xinzuoLabel.textAlignment = NSTextAlignmentRight;
    

    
    UIImageView *scoreBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_score_bg"]] autorelease];
    [tableViewHeader addSubview:scoreBack];
    CGRect scoreBackFrame = scoreBack.frame;
    scoreBackFrame.origin.x = 113;
    scoreBackFrame.origin.y = 63;
    scoreBack.frame = scoreBackFrame;
    //self.man.score = [NSNumber numberWithFloat:4.5];
    UIImageView *score = nil;
    if ([self.man.score floatValue] <= 2) {
        score = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_score_two"]] autorelease];
        CGRect scoreFrame = score.frame;
        if ([self.man.score floatValue] <=0) {
            scoreFrame.size.width = score.image.size.width/5.0 * 0.44;
        }else {
            scoreFrame.size.width = score.image.size.width/5.0 * 0.44+score.image.size.width/13.0 * ([self.man.score floatValue]/2.0);
        }
        
        score.frame = scoreFrame;
    }else if ([self.man.score floatValue]<=4) {
        score = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_score_one"]] autorelease];
        CGRect scoreFrame = score.frame;
        scoreFrame.size.width =  score.image.size.width * ([self.man.score floatValue])/10.0;
        score.frame = scoreFrame;
    }else if ([self.man.score floatValue]<=6) {
        score = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_score_three"]] autorelease];
        CGRect scoreFrame = score.frame;
        scoreFrame.size.width =  score.image.size.width * ([self.man.score floatValue])/10.0;
        score.frame = scoreFrame;
    }else if ([self.man.score floatValue]<=8) {
        score = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_score_four"]] autorelease];
        CGRect scoreFrame = score.frame;
        scoreFrame.size.width =  score.image.size.width * ([self.man.score floatValue])/10.0;
        score.frame = scoreFrame;
    }else if ([self.man.score floatValue]<=10) {
        score = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_score_five"]] autorelease];
        CGRect scoreFrame = score.frame;
        scoreFrame.size.width =  score.image.size.width * ([self.man.score floatValue])/10.0;
        score.frame = scoreFrame;
    }
    
    [scoreBack addSubview:score];
    score.contentMode = UIViewContentModeLeft;
    score.clipsToBounds = YES;
    
    
    
    
    UILabel *scoreLabel = [[[UILabel alloc] initWithFrame:CGRectMake(238, 52, 80, 39)] autorelease];
    [scoreLabel adjustsFontSizeToFitWidth];
    [tableViewHeader addSubview:scoreLabel];
    scoreLabel.backgroundColor = [UIColor clearColor];
    
    scoreLabel.text = [self.man scoreDescription];
    
    //scoreLabel.textAlignment = NSTextAlignmentRight;
    scoreLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:25];
    scoreLabel.textColor = [UIColor colorWithHexString:@"#EB6877"];
    
    UIImageView *scoreArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]] autorelease];
    [tableViewHeader addSubview:scoreArrow];
    scoreArrow.center = CGPointMake(305, scoreLabel.center.y);
    
    UIButton *scoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(110, 55, 210, 35)];
    [scoreBtn setBackgroundImage:[[UIImage imageNamed:@"redfeed"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateHighlighted];
    [scoreBtn addTarget:self action:@selector(viewScore:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeader insertSubview:scoreBtn belowSubview:scoreBack];
    [scoreBtn release];
    
    UIImageView *shadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_tableviewheader_shadow"]] autorelease];
    [tableViewHeader addSubview:shadow];
    CGRect shadowFrame = shadow.frame;
    shadowFrame.origin.y = height;
    shadow.frame = shadowFrame;

    UIImageView *arrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]] autorelease];
    [tableViewHeader addSubview:arrow];
    arrow.center = CGPointMake(305, tagBgView.center.y);
    
    
    self.showTableView.tableHeaderView = tableViewHeader;
    [tableViewHeader release];

    
}

-(void)viewWeibo:(id)sender
{
    WMWeiboPageViewController *vc = [[[WMWeiboPageViewController alloc] init] autorelease];
    vc.man = self.man;
    [NKNC pushViewController:vc animated:YES];
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.man.weiboUrl]];
}

-(void)avatarTapped:(UIGestureRecognizer*)gesture{
    
    WMManPhotosViewController *manPhoto = [[WMManPhotosViewController alloc] init];
    manPhoto.man = self.man;
    [NKNC pushViewController:manPhoto animated:YES];
    [manPhoto release];
    
}

-(void)goBack:(id)sender{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    if (_isFromUniversity) {
        [NKNC popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-4] animated:YES];
    }else if (_shouldGetNotification || _shouldNotBackToRoot) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"createManSuccess" object:self];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}

-(void)goToRelationPage:(id)sender
{
    WMRelationViewController *vc = [[[WMRelationViewController alloc] init] autorelease];
    vc.man = self.man;
    vc.delegate = self;
    [NKNC pushViewController:vc animated:YES];
}

-(void)goToInterestPage:(id)sender
{
    WMInterestViewController *vc = [[[WMInterestViewController alloc] init] autorelease];
    vc.man = self.man;
    vc.delegate = self;
    [NKNC pushViewController:vc animated:YES];
}

-(void)shouldGetManInfo
{
    shouldNotGetContent = YES;
    [self refreshData];
}

-(void)addFooterView
{
    UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(7, 0, 305, 108)] autorelease];
    UIButton *btn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 8, 305, 100)] autorelease];
    [btn setBackgroundImage:[UIImage imageNamed:@"man_no_content"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"man_no_content"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(addBaoliao:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    self.showTableView.tableFooterView = footerView;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addBackButton];
    
    //[self addShareButton];
    
    if ([self.man.weiboName length]) {
        [self addInviteButton];
    }
    
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@人点评",[self.man.opCount stringValue]];
    
    [self addTableViewHeader];
    
    showTableView.frame = CGRectMake(0, 44, 320, NKMainHeight-44-41);
    showTableView.backgroundColor = [UIColor whiteColor];
    
    [self refreshData];
    ProgressLoading;
    
    [self addActionBar];
    
    self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
    loadingMoreView.target = self;
    loadingMoreView.action = @selector(getMoreData);
    [self showFooter:YES];
    
    self.showTableView.backgroundColor = [UIColor colorWithHexString:@"#e1d7c8"];
    
    NSDictionary *sysFunction = [[NSUserDefaults standardUserDefaults] objectForKey:@"sysFunction"];
    if ([sysFunction[@"baoliao"] boolValue]) {
        [self addRightButtonWithTitle:@"微信"];
    }
}

-(void)rightButtonClick:(id)sender
{
    [self shareAllButtonClickHandler:sender];
}

- (void)addInviteButton {
    UIButton *button = [self addRightButtonWithTitle:@"邀请"];
    [button removeTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat x = button.frame.origin.x;
    
    NSDictionary *sysFunction = [[NSUserDefaults standardUserDefaults] objectForKey:@"sysFunction"];
    if ([sysFunction[@"baoliao"] boolValue]) {
        x = 220.0f;
    }
    
    CGSize size = button.frame.size;
    button.frame = CGRectMake(x, 0.0f, size.width, size.height);
}

- (void)invite:(id)sender {
    WMInviteFriendsViewController *vc = [[[WMInviteFriendsViewController alloc] init] autorelease];
    vc.man = self.man;
    [NKNC pushViewController:vc animated:YES];
}

- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)shareAllButtonClickHandler:(UIButton *)sender
{
    WMAppDelegate *appDelegate = [WMAppDelegate shareAppDelegate];
    appDelegate.isLogin = NO;
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"shareIcon" ofType:@"png"];
    //NSString *bigImagePath = [[NSBundle mainBundle] pathForResource:@"weibo_share" ofType:@"jpg"];
    //构造分享内容
    if ([self.man.tags count] == 0) {
        tagString = @"";
    }else {
        for (int i=0; i<[self.man.tags count]; i++) {
            if (i==0) {
                tagString = [[self.man.tags objectAtIndex:i] name];
            }else if(i<6) {
                tagString = [NSString stringWithFormat:@"%@,%@",tagString,[[self.man.tags objectAtIndex:i] name]];
                
            }else {
                break;
            }
        }
    }
    
    if ([tagString length] == 0) {
        descString = [NSString stringWithFormat:@"%@:平均分%@。| 更多八卦爆料…",self.man.name,self.man.score ? [NSString stringWithFormat:[self.man.score floatValue]<=-10?@"%.0f":@"%.1f", [self.man.score floatValue]]:nil];
    }else {
        descString = [NSString stringWithFormat:@"%@:平均分%@。标签:%@… | 更多八卦爆料…",self.man.name,self.man.score ? [NSString stringWithFormat:[self.man.score floatValue]<=-10?@"%.0f":@"%.1f", [self.man.score floatValue]]:nil,tagString];
    }
    NSString *name = [self.man.weiboName length]>0?[NSString stringWithFormat:@"@%@",self.man.weiboName]:self.man.name;
    descString = [NSString stringWithFormat:@"#男纸点评# 姑娘们给 %@ 打了平均%@分，%@个爆料 围观地址>>>%@（分享自@薇蜜）",name,self.man.score,self.man.baoliaoCount,[NSString stringWithFormat:@"http://www.weimi.com/man/%@?from=weibo",self.man.mid]];
    id<ISSContent> publishContent = [ShareSDK content:descString
                                       defaultContent:@""
                                                image:[ShareSDK jpegImageWithImage:[self capture] quality:0.5]
                                                title:@"薇蜜"
                                                  url:@"http://www.weimi.com/app?from=weibo"
                                          description:@"薇蜜"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    ///////////////////////
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
    [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"#男纸点评# 姑娘们给 %@ 打了平均%@分，%@个爆料 围观地址>>>%@（分享自@薇蜜）",name,self.man.score,self.man.baoliaoCount,[NSString stringWithFormat:@"http://www.weimi.com/man/%@?from=renren",self.man.mid]] image:[ShareSDK jpegImageWithImage:[self capture] quality:0.5]];
    
    
    //定制人人网信息
    [publishContent addRenRenUnitWithName:[NSString stringWithFormat:@"姑娘们对 %@ 的点评八卦",self.man.name]
                              description:descString
                                      url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@?from=renren",self.man.mid]
                                  message:[NSString stringWithFormat:@"在薇蜜看到了有人对 %@ 的点评…",self.man.name]
                                    image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.man.avatarBigPath]] fileName:@"avatar.jpg" mimeType:@"image/jpeg"]
                                  caption:@""];
    //定制QQ空间信息
    [publishContent addQQSpaceUnitWithTitle:[NSString stringWithFormat:@"姑娘们对 %@ 的点评八卦",self.man.name]
                                        url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@?from=qzone",self.man.mid]
                                       site:@"薇蜜-男友点评"
                                    fromUrl:@"http://www.weimi.com"
                                    comment:[NSString stringWithFormat:@"在薇蜜看到了有人对 %@ 的点评…",self.man.name]
                                    summary:descString
                                      image:INHERIT_VALUE
                                       type:[NSNumber numberWithInt:4]
                                    playUrl:nil
                                       nswb:[NSNumber numberWithInt:0]];
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:descString
                                           title:[NSString stringWithFormat:@"姑娘们对 %@ 的点评八卦",self.man.name]
                                             url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@?from=weixin",self.man.mid]
                                           image:[ShareSDK imageWithUrl:self.man.avatarPath]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:descString
                                            title:[NSString stringWithFormat:@"姑娘们对 %@ 的点评八卦",self.man.name]
                                              url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@?from=moment",self.man.mid]
                                            image:[ShareSDK imageWithUrl:self.man.avatarPath]
                                     musicFileUrl:@""
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    
    [publishContent addQQUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                              content:descString
                                title:[NSString stringWithFormat:@"%@ 的点评",self.man.name]
                                  url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@?from=qq",self.man.mid]
                                image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.man.avatarBigPath]] fileName:@"avatar.jpg" mimeType:@"image/jpeg"]];
    
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"姑娘们对 %@ 的点评打分，八卦>>>http://http://www.weimi.com/man/%@?from=sms 【薇蜜】",self.man.name,self.man.mid]];
    
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"薇蜜分享"
                                                              oneKeyShareList:[ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ,ShareTypeQQSpace,ShareTypeRenren,ShareTypeTencentWeibo,ShareTypeSMS, nil]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:[ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ,ShareTypeQQSpace,ShareTypeRenren,ShareTypeTencentWeibo,ShareTypeSMS, nil]
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:shareOptions
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

-(void)commentFinished
{
    [self.dataSource removeAllObjects];
    [self refreshData];
    [_delegate shouldReload];
}

-(UIButton*)actionButtonWithTitle:(NSString*)title action:(SEL)action andX:(CGFloat)x{
    
    //UIButton *actionButton = nil;
    
    
    actionButton = [[[UIButton alloc] initWithFrame:CGRectMake(x, 8, 94, 26)] autorelease];
    [actionButton setBackgroundImage:[[UIImage imageNamed:@"man_bottom_button_normal"] resizeImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 15)] forState:UIControlStateNormal];
    [actionButton setBackgroundImage:[[UIImage imageNamed:@"man_bottom_button_click"] resizeImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 15)] forState:UIControlStateHighlighted];
    [actionButton setTitle:title forState:UIControlStateNormal];
    [actionButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [actionButton setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [actionButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    actionButton.titleLabel.shadowOffset = CGSizeMake(0, 0.5);
    
    return actionButton;
    
}

-(void)addActionBar{
    
    UIImageView *actionBar = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] autorelease];
    [self.contentView addSubview:actionBar];
    actionBar.userInteractionEnabled = YES;
    CGRect actionBarFrame = actionBar.frame;
    actionBarFrame.origin.y = NKMainHeight - actionBarFrame.size.height;
    actionBar.frame = actionBarFrame;
    
    
    if ([_man.hasRate boolValue]) {
        actionButton = [self actionButtonWithTitle:@"更新评分" action:@selector(addRate:) andX:10];
    }else {
        actionButton = [self actionButtonWithTitle:@"添加评分" action:@selector(addRate:) andX:10];
    }
    rateButton = actionButton;
    [actionBar addSubview:actionButton];
    

    actionButton = [self actionButtonWithTitle:@"爆料/提问" action:@selector(addBaoliao:) andX:114];
    [actionBar addSubview:actionButton];
    
    NSDictionary *sysFunction = [[NSUserDefaults standardUserDefaults] objectForKey:@"sysFunction"];
    if (![sysFunction[@"baoliao"] boolValue]) {
        [actionButton setTitle:@"分享" forState:UIControlStateNormal];
        [actionButton removeTarget:self action:@selector(addBaoliao:) forControlEvents:UIControlEventTouchUpInside];
        [actionButton addTarget:self action:@selector(shareAllButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    actionButton = [self actionButtonWithTitle:@"+关注" action:@selector(relation:) andX:218];
    [actionBar addSubview:actionButton];
    
    self.followButton = actionButton;

}

-(void)addBaoliao:(id)sender{
    WMAddBaoliaoViewController *addBaoliao = [[WMAddBaoliaoViewController alloc] init];
    addBaoliao.man = self.man;
    addBaoliao.father = self;
    [NKNC pushViewController:addBaoliao animated:YES];
    [addBaoliao release];
}

-(void)viewScore:(id)sender
{
    WMManDadenDetalViewController *dafenVc = [[WMManDadenDetalViewController alloc] init];
    dafenVc.man = self.man;
    dafenVc.delegate = self;
    [NKNC pushViewController:dafenVc animated:YES];
    [dafenVc release];
}

-(void)shouldRefreshData
{
    [self refreshData];
}

-(void)viewTag:(id)sender{
    
    WMAddTagViewController *addTag = [[WMAddTagViewController alloc] init];
    addTag.man = self.man;
    addTag.father = self;
    [NKNC pushViewController:addTag animated:YES];
    [addTag release];

}

-(void)viewTags:(UIGestureRecognizer*)gesture{
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        [self viewTag:nil];
    }
    
}

-(void)relationOK:(NKRequest*)request{
    
    if ([self.man.followed boolValue]) {
        
        ProgressSuccess(@"取消关注成功");
        self.man.followed = [NSNumber numberWithBool:NO];
    
    }
    else {
        ProgressSuccess(@"关注成功");
        self.man.followed = [NSNumber numberWithBool:YES];
    
    }
    
    [self checkFollowButtonTitle];
}

-(void)relationFailed:(NKRequest*)request{
    
    ProgressErrorDefault;
}


-(void)relation:(id)sender{
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(relationOK:) andFailedSelector:@selector(relationFailed:)];
    
    if ([self.man.followed boolValue]) {
        
        ProgressWith(@"正在取消关注");
        [[WMManService sharedWMManService] unfollowManWithMID:self.man.mid andRequestDelegate:rd];
    }
    
    else{
        
        ProgressWith(@"正在关注");
        [[WMManService sharedWMManService] followManWithMID:self.man.mid andRequestDelegate:rd];
    }
    
    
}


-(void)addRate:(id)sender{
    
    WMAddRateViewController *addRate = [[WMAddRateViewController alloc] init];
    addRate.man = self.man;
    addRate.father = self;
    [NKNC pushViewController:addRate animated:YES];
    [addRate release];
}

-(void)deleteFeed
{
    [self.dataSource removeAllObjects];
    [self refreshData];
    [_delegate shouldReload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)refreshData{
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getManDetailOK:) andFailedSelector:@selector(getManDetailFailed:)];
    [[WMManService sharedWMManService] getManDetailWithMID:self.man.mid andRequestDelegate:rd];
    
    
}

-(void)getMoreData{
    
    
    [self showFooter:YES];
    gettingMoreData = YES;
    
    NKRequestDelegate *rd = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
    [[WMManService sharedWMManService] getManFeedWithMID:self.man.mid type:@"all" offset:[self.dataSource count] size:DefaultOneRequestSize andRequestDelegate:rd];
    
}

-(void)checkFollowButtonTitle{
    
    [self.followButton setTitle:[self.man.followed boolValue]?@"取消关注":@"+关注" forState:UIControlStateNormal];
}

-(void)getManDetailOK:(NKRequest*)request{
    self.man = [request.results lastObject];
    
    if ([self.man.hasRate boolValue]) {
        [rateButton setTitle:@"更新打分" forState:UIControlStateNormal];
    }
    
    [self checkFollowButtonTitle];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@人点评",[self.man.opCount stringValue]];
    
    [self addTableViewHeader];
    
    if (!shouldNotGetContent) {
        NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
        
        [[WMManService sharedWMManService] getManFeedWithMID:self.man.mid type:@"all" offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
    }else {
        [self doneLoadingTableViewData];
    }

    
}


-(void)getManDetailFailed:(NKRequest*)request{
    
    ProgressErrorDefault;
}

-(void)refreshDataOK:(NKRequest *)request
{
    [super refreshDataOK:request];
    if (_shouldGetNotification) {
        [[WMNotificationCenter sharedNKNotificationCenter] getNotificationsCount];
        //[_delegate shouldReload];
    }
    if ([self.dataSource count] == 0) {
        [self addFooterView];
    }

}

-(void)setPullBackFrame{
    
}


#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [WMManFeedCell cellHeightForObject:[self.dataSource objectAtIndex:indexPath.row]];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"WMManFeedCellIdentifier";
    
    WMManFeedCell *cell = (WMManFeedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[WMManFeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.delegate = self;
    }
    
    WMMFeed *feed = [self.dataSource objectAtIndex:indexPath.row];
    cell.index = indexPath.row;
    [cell showForObject:feed];
    
    
    
    return cell;
}

-(void)setRate:(int)index feed:(WMMFeed *)feed
{
    [self.dataSource replaceObjectAtIndex:index withObject:feed];
}

- (void)share {
    NSString *titleString = [NSString stringWithFormat:@"关于 %@…", self.man.name];
    NSString *descStrings = nil;
    
    if ([reportFeed.type isEqualToString:WMFeedTypeDafen]) {
        NSMutableArray *scoreArr = [NSMutableArray array];
        
        for (id obj in reportFeed.score[@"scores"]) {
            [scoreArr addObject:[NSString stringWithFormat:@"%@%@分", obj[@"name"], obj[@"score"]]];
        }
        
        NSString *scoreString = [scoreArr componentsJoinedByString:@"，"];
        
        descStrings = [NSString stringWithFormat:@"%@ 给 %@ %@...", reportFeed.sender.name, self.man.name, scoreString];
    } else {
        descStrings = [NSString stringWithFormat:@"%@说：%@", reportFeed.sender.name, reportFeed.content];
    }
    
    descStrings = [descStrings stringByAppendingString:@" | 点击可匿名评论"];
    
    NSData *imageData = nil;
    NSString *imageURL = self.man.avatarBigPath;
    
    WMMAttachment *attach = [reportFeed.attachments lastObject];
    
    if (attach != nil) {
        if (attach.picture != nil) {
            imageData = UIImageJPEGRepresentation(attach.picture, 1.0f);
        } else {
            imageURL = attach.pictureURL;
        }
    }
    
    if (imageData == nil) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    }
    
    id<ISSContent> publishContent = [ShareSDK content:descStrings
                                       defaultContent:@""
                                                image:[ShareSDK imageWithData:imageData fileName:@"avatar.jpg" mimeType:@"image/jpeg"]
                                                title:@"薇蜜"
                                                  url:@"http://www.weimi.com/app?from=weibo"
                                          description:@"薇蜜"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:descStrings
                                           title:titleString
                                             url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@/review/%@?from=weixinmsg",self.man.mid, reportFeed.mid]
                                           image:[ShareSDK imageWithData:imageData fileName:@"avatar.jpg" mimeType:@"image/jpeg"]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:descStrings
                                            title:titleString
                                              url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@/review/%@?from=moment",self.man.mid, reportFeed.mid]
                                            image:[ShareSDK imageWithData:imageData fileName:@"avatar.jpg" mimeType:@"image/jpeg"]
                                     musicFileUrl:@""
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制QQ信息
    [publishContent addQQUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                              content:descStrings
                                title:titleString
                                  url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@/review/%@?from=qq",self.man.mid, reportFeed.mid]
                                image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.man.avatarBigPath]] fileName:@"avatar.jpg" mimeType:@"image/jpeg"]];
    
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"姑娘们对 %@ 的点评打分，八卦>>>http://http://www.weimi.com/man/%@?from=sms 【薇蜜】",self.man.name,self.man.mid]];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"薇蜜分享"
                                                              oneKeyShareList:[ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ, nil]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:[ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ, nil]
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:shareOptions
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

-(void)showMoreView:(WMMFeed *)feed
{
    reportFeed = feed;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:@"分享到微信/QQ", nil];
    sheet.tag = SHOW_REPORT_SHEET;
    [sheet showInView:[[[UIApplication sharedApplication] windows] lastObject]];
    [sheet release];
}

- (void)modifyMan:(id)sender {
    WMManFeedBackViewController *vc = [[WMManFeedBackViewController alloc] init];
    vc.man = self.man;
    
    vc.feedbackSuccessHandler = ^{
        //Progress(@"");
        //ProgressSuccess(@"等审核后才会修改生效哦");
        UIAlertView *faildAlert = [[UIAlertView alloc] initWithTitle:nil message:@"等审核后才会修改生效哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [faildAlert show];
    };
    
    [NKNC pushViewController:vc animated:YES];
    [vc release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == SHOW_REPORT_SHEET) {
        if (buttonIndex == 0) {
            [self showReportActionSheet];
        } else if (buttonIndex == 1) {
            [self share];
        }
    }else if (actionSheet.tag == REPORT_SHEET) {
        NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(reportOK:) andFailedSelector:@selector(reportFailed:)];
        
        NSString *reportType = nil;
        
        switch (buttonIndex) {
            case 0: {
                reportType = @"广告";
            }
                break;
                
            case 1: {
                reportType = @"色情";
            }
                break;
                
            case 2: {
                reportType = @"政治";
            }
                break;
                
            case 3: {
                reportType = @"反感";
            }
                break;
                
            default:
                return;
        }
        
        ProgressWith(@"举报中");
        
        [[WMFeedService sharedWMFeedService] reportFeedWithFID:reportFeed.mid andContent:reportType andRequestDelegate:rd];
    }
}

- (void)reportOK:(NKRequest *)request {
    ProgressSuccess(@"举报成功");
}

- (void)reportFailed:(NKRequest *)request {
    
}

-(void)showReportActionSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:@"取消"
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"广告", @"色情", @"政治", @"反感", nil];
    sheet.tag = REPORT_SHEET;
    [sheet showInView:self.view];
    [sheet release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WMMFeed *feed = [self.dataSource objectAtIndex:indexPath.row];
    if ([feed.purview isEqualToString:@"open"] || [feed.sender.relation isEqualToString:@"自己"]) {
        WMBaoliaoXiangqingViewController *baoliaoXiangqing = [[[WMBaoliaoXiangqingViewController alloc] init] autorelease];
        baoliaoXiangqing.man = self.man;
        if ([feed.type isEqualToString:@"score"]) {
            baoliaoXiangqing.titleString = @"评分详情";
        }
        baoliaoXiangqing.feed = feed;
        baoliaoXiangqing.delegate = self;
        [NKNC pushViewController:baoliaoXiangqing animated:YES];
    }else {
        ProgressFailedWith(@"只有她的姐妹闺蜜才能看哦~");
    }
    

}

@end
