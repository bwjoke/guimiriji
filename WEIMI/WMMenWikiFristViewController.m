//
//  WMMenWikiFristViewController.m
//  WEIMI
//
//  Created by steve on 13-7-22.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMMenWikiFristViewController.h"
#import "WMMenWikiPageViewController.h"
#import "WMMenWikiViewController.h"
#import "WMAppDelegate.h"
#import "WMAddBaoliaoPseudoViewController.h"
#import "WMNotificationCenter.h"
#import "WMSearchManViewController.h"

@interface WMMenWikiFristViewController () <UITextFieldDelegate>
{
    WMMenWikiListViewController *listViewController;
    NKSegmentControl *seg;
    int selectIndex;
    UIView *headerView;
}
@end

@implementation WMMenWikiFristViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)showNearView
{
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
        [seg selectSegment:4 shouldTellDelegate:![self.dataSource count]];
    }
}

-(void)showHelpView
{
    WMHelpView *helpView = [[WMHelpView alloc] initWithFrame:CGRectMake(0, 0, 320,SCREEN_HEIGHT)];
    if (SCREEN_HEIGHT>480) {
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
            [helpView setImage:[UIImage imageNamed:@"dianping_tip_hi"]];
        }else {
            [helpView setImage:[UIImage imageNamed:@"dianping_tip_tab_hi"]];
        }
        
    }else {
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
            [helpView setImage:[UIImage imageNamed:@"dianping_tip"]];
        }else {
            [helpView setImage:[UIImage imageNamed:@"dianping_tip_tab"]];
        }
        
    }
    //WMAppDelegate *appDelegate = [WMAppDelegate shareAppDelegate];
    //[appDelegate.window  addSubview:helpView];
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:headerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[WMAppDelegate shareAppDelegate] saveSystemFunction];
    
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"dianpinghelp"]) {
            [self showHelpView];
            //[self performSelector:@selector(showHelpView) withObject:nil afterDelay:2.0];
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"dianpinghelp"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        listViewController = [[WMMenWikiListViewController alloc] init];
        listViewController.delegate = self;
        listViewController.kNumberOfPages = 5;
        listViewController.dataSource = [NSArray arrayWithObjects:@"dianping",@"nearby",@"new",@"bangdan",@"xiaoyuan", nil];
        listViewController.view.frame = CGRectMake(0, 33, 320, SCREEN_HEIGHT-56-33);
        
        [self.view addSubview:listViewController.view];
        
        UIView *tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(showTableView.frame.origin.x, 0, showTableView.frame.size.width, 44)] ;
        showTableView.tableHeaderView = tableViewHeader;
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 33, tableViewHeader.frame.size.width, 55)];
        bgView.image = [UIImage imageNamed:@"wiki_top_bg"];
        [tableViewHeader addSubview:bgView];
        [self.view addSubview:tableViewHeader];
        
        [self addSearchBar];
        
        NKSegment *xiaoyuanSeg = [NKSegment segmentWithSize:CGSizeMake(64, 35) normalColor:[UIColor clearColor] highlightColor:[UIColor clearColor] andTitle:@"校园"];
        xiaoyuanSeg.normalTextColor = [UIColor colorWithHexString:@"#B2A18D"];
        xiaoyuanSeg.highlightTextColor = [UIColor colorWithHexString:@"#EB6877"];
        
        NKSegment *remenSeg = [NKSegment segmentWithSize:CGSizeMake(64, 35) normalColor:[UIColor clearColor] highlightColor:[UIColor clearColor] andTitle:@"榜单"];
        remenSeg.normalTextColor = [UIColor colorWithHexString:@"#B2A18D"];
        remenSeg.highlightTextColor = [UIColor colorWithHexString:@"#EB6877"];
        
        NKSegment *zuixinSeg = [NKSegment segmentWithSize:CGSizeMake(64, 35) normalColor:[UIColor clearColor] highlightColor:[UIColor clearColor] andTitle:@"新料"];
        zuixinSeg.normalTextColor = [UIColor colorWithHexString:@"#B2A18D"];
        zuixinSeg.highlightTextColor = [UIColor colorWithHexString:@"#EB6877"];
        
        NKSegment *fujinSeg = [NKSegment segmentWithSize:CGSizeMake(64, 35) normalColor:[UIColor clearColor] highlightColor:[UIColor clearColor] andTitle:@"八卦"];
        fujinSeg.normalTextColor = [UIColor colorWithHexString:@"#B2A18D"];
        fujinSeg.highlightTextColor = [UIColor colorWithHexString:@"#EB6877"];
        
        NKSegment *dianpingSeg = [NKSegment segmentWithSize:CGSizeMake(64, 35) normalColor:[UIColor clearColor] highlightColor:[UIColor clearColor] andTitle:@"点评"];
        dianpingSeg.normalTextColor = [UIColor colorWithHexString:@"#B2A18D"];
        dianpingSeg.highlightTextColor = [UIColor colorWithHexString:@"#EB6877"];
        seg = [NKSegmentControl segmentControlViewWithSegments:[NSArray arrayWithObjects:dianpingSeg,fujinSeg,zuixinSeg, remenSeg,xiaoyuanSeg, nil] andDelegate:self];
        
        [self.view insertSubview:seg aboveSubview:tableViewHeader];
        CGRect segFrame = seg.frame;
        segFrame.origin.y = 40;
        seg.frame = segFrame;
        
        
        for (UIButton *button in seg.segments) {
            button.titleLabel.font = [UIFont systemFontOfSize:12];
        }
        
        self.segLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 1)];
        self.segLine.backgroundColor = [UIColor colorWithHexString:@"#EB6877"];
        [seg addSubview:_segLine];
        
        UIButton *button = [seg.segments objectAtIndex:selectIndex];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _segLine.center = CGPointMake([button center].x, seg.frame.size.height+2);
        shouldChangeDataPage = YES;
        [seg selectSegment:1 shouldTellDelegate:YES];
        [self segmentControl:seg didChangeIndex:1];
        self.tabSeg = seg;
    }else {
        self.headBar.hidden = NO;
        //selectIndex = 1;
        //self.category = @"nearby";
        //self.dataSource = [[NKDataStore sharedDataStore] cachedArrayOf:WMCachePathNearByMen andClass:[WMMFeed class]];
        [self.view insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] atIndex:0];
        [self addHeadShadow];
        
        self.titleLabel.text = @"八卦";
        UIButton *addBtn = [self addRightButtonWithTitle:@"发布"];
        [addBtn removeTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [addBtn addTarget:self action:@selector(addPost:) forControlEvents:UIControlEventTouchUpInside];
        
        listViewController = [[WMMenWikiListViewController alloc] init];
        listViewController.delegate = self;
        listViewController.kNumberOfPages = 1;
        listViewController.dataSource = [NSArray arrayWithObjects:@"nearby", nil];
        listViewController.view.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-56);
        [self.view insertSubview:listViewController.view belowSubview:self.headBar];
    }
    
    
     
}

#pragma mark - Add search bar

- (void)addSearchBar {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    
    UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectMake(242, 8, 63, 30)];
    [topView addSubview:actionButton];
    [actionButton setBackgroundImage:[UIImage imageNamed:@"guanzhu_normal"] forState:UIControlStateNormal];
    [actionButton setBackgroundImage:[UIImage imageNamed:@"guanzhu_click"] forState:UIControlStateHighlighted];
    [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (!_feedBadge) {
        self.feedBadge = [[NKBadgeView alloc] initWithFrame:CGRectMake(48, 0, 14, 14)];
        _feedBadge.placeHolderImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        _feedBadge.highlightedImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        _feedBadge.numberLabel.hidden = YES;
        [_feedBadge bindValueOfModel:[WMNotificationCenter sharedNKNotificationCenter] forKeyPath:@"hasNewMan"];
        [actionButton addSubview:self.feedBadge];
    }
    
    [actionButton addTarget:self action:@selector(goToFav:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *searchBack = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"man_search_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 40, 5, 40)]] ;
    searchBack.userInteractionEnabled = YES;
    [topView addSubview:searchBack];
    CGRect searchBackFrame = searchBack.frame;
    searchBackFrame.origin.y = 8;
    searchBackFrame.origin.x = 14;
    searchBackFrame.size.width = 221;
    searchBack.frame = searchBackFrame;
    
    UITextField *searchFiled = [[UITextField alloc] initWithFrame:CGRectMake(33, 0, 221, searchBack.frame.size.height)];
    [searchBack addSubview:searchFiled];
    searchFiled.textColor = [UIColor colorWithHexString:@"#A07D46"];
    searchFiled.placeholder = @"输入姓名搜索";
    searchFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchFiled.font = [UIFont systemFontOfSize:12];
    searchFiled.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSearch:)];
    [searchFiled addGestureRecognizer:tapGesture];
    
    topView.frame = CGRectMake(0, 0, 320, searchBack.frame.size.height+11);
    topView.userInteractionEnabled = YES;
    [self.view addSubview:topView];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)gotoSearch:(id)sender {
    WMSearchManViewController *vc = [[WMSearchManViewController alloc] init];
    [NKNC pushViewController:vc animated:YES];
}

- (void)goToFav:(id)sender {
    // All new man did read, reset the hasNewMan
    [[WMNotificationCenter sharedNKNotificationCenter] setHasNewMan:@(NO)];
//    int manDicCount = 0;
//    NSDictionary *manDic = [[WMNotificationCenter sharedNKNotificationCenter] manDic];
//    if ([manDic isKindOfClass:[NSDictionary class]] && ![manDic isKindOfClass:[NSNull class]]) {
//        for (NSDictionary *dic in [manDic allValues]) {
//            if (![dic isKindOfClass:[NSNull class]]) {
//                for (NSNumber *number in [dic allValues]) {
//                    if ([number boolValue]) {
//                        manDicCount +=1;
//                    }
//                }
//            }
//            
//        }
//    }
//    int badgeNum = [[UIApplication sharedApplication] applicationIconBadgeNumber];
//    if (badgeNum>=manDicCount) {
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:(badgeNum-manDicCount)];
//    }else {
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    }
    WMFavListViewController *favList = [[WMFavListViewController alloc] init];
    [NKNC pushViewController:favList animated:YES];
}

-(void)addPost:(id)sender
{
    WMAddBaoliaoPseudoViewController *vc = [[WMAddBaoliaoPseudoViewController alloc] init];
    vc.father = self;
    [NKNC pushViewController:vc animated:YES];
}

-(void)didScrollViewStartScrollTo:(int)scrollToPage
{
    shouldChangeDataPage = NO;
    [seg selectSegment:scrollToPage shouldTellDelegate:YES];
    shouldChangeDataPage = YES;
}

-(void)segmentControl:(NKSegmentControl*)control didChangeIndex:(NSInteger)index
{
    UIButton *button = [control.segments objectAtIndex:index];
    if (shouldChangeDataPage) {
        [listViewController scrolTo:index];
    }
    
    switch (index) {
        case 0:{
            if ([control.segments count]>3) {
                UIButton *button1 = [control.segments objectAtIndex:1];
                UIButton *button2 = [control.segments objectAtIndex:2];
                UIButton *button3 = [control.segments objectAtIndex:3];
                button1.titleLabel.font = [UIFont systemFontOfSize:12];
                button2.titleLabel.font = [UIFont systemFontOfSize:12];
                button3.titleLabel.font = [UIFont systemFontOfSize:12];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            }
            break;
        }
        case 1:{
            if ([control.segments count]>3) {
                UIButton *button1 = [control.segments objectAtIndex:0];
                UIButton *button2 = [control.segments objectAtIndex:2];
                UIButton *button3 = [control.segments objectAtIndex:3];
                button1.titleLabel.font = [UIFont systemFontOfSize:12];
                button2.titleLabel.font = [UIFont systemFontOfSize:12];
                button3.titleLabel.font = [UIFont systemFontOfSize:12];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            }
            break;
        }
        case 2:{
            if ([control.segments count]>3) {
                UIButton *button1 = [control.segments objectAtIndex:1];
                UIButton *button2 = [control.segments objectAtIndex:0];
                UIButton *button3 = [control.segments objectAtIndex:3];
                button1.titleLabel.font = [UIFont systemFontOfSize:12];
                button2.titleLabel.font = [UIFont systemFontOfSize:12];
                button3.titleLabel.font = [UIFont systemFontOfSize:12];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            }
            break;
        }
        case 3:{
            if ([control.segments count]>3) {
                UIButton *button1 = [control.segments objectAtIndex:1];
                UIButton *button2 = [control.segments objectAtIndex:2];
                UIButton *button3 = [control.segments objectAtIndex:0];
                button1.titleLabel.font = [UIFont systemFontOfSize:12];
                button2.titleLabel.font = [UIFont systemFontOfSize:12];
                button3.titleLabel.font = [UIFont systemFontOfSize:12];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            }
            break;
        }
        default:
            break;
    }
    [UIView animateWithDuration:0.6 animations:^{
        _segLine.center = CGPointMake([button center].x, control.frame.size.height+2);
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - NKSegmentControlDelegate

- (void)segmentControl:(NKSegmentControl *)control buttonDidLoad:(UIButton *)button forSegment:(NKSegment *)segment {
    NSString *title = segment.title;
    NSString *iconNameNormal = nil;
     NSString *iconNameHighlight = nil;
    
    if ([title isEqualToString:@"点评"]) {
        iconNameNormal = @"icon_normal_dianping";
        iconNameHighlight = @"icon_highlight_dianping";
    } else if ([title isEqualToString:@"八卦"]) {
        iconNameNormal = @"icon_normal_nearby";
        iconNameHighlight = @"icon_highlight_nearby";
    } else if ([title isEqualToString:@"热门"]|| [title isEqualToString:@"榜单"]) {
        iconNameNormal = @"icon_normal_remen";
        iconNameHighlight = @"icon_highlight_remen";
    } else if ([title isEqualToString:@"新料"]) {
        iconNameNormal = @"icon_normal_nencao";
        iconNameHighlight = @"icon_highlight_nencao";
    } else if ([title isEqualToString:@"校园"]) {
        iconNameNormal = @"icon_normal_xiaoyuan";
        iconNameHighlight = @"icon_highlight_xiaoyuan";
    }
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconNameNormal] highlightedImage:[UIImage imageNamed:iconNameHighlight]];
    
    CGPoint center = CGPointMake(18.0f, button.frame.size.height / 2.0f);
    iconView.center = center;
    
    [button addSubview:iconView];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f)];
    
    // Adjust the font size
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
}

@end
