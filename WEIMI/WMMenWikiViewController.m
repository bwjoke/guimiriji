//
//  WMMenWikiViewController.m
//  WEIMI
//
//  Created by King on 10/24/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMMenWikiViewController.h"
#import "WMWikiViewController.h"
#import "WMMenCell.h"
#import "WMManDetailViewController.h"

#import "WMCreateManViewController.h"
#import "WMAppDelegate.h"
#import "WMFavListViewController.h"

#import "WMNotificationCenter.h"
#import "WMAddBaoliaoPseudoViewController.h"

#import "WMAppDelegate.h"

@interface WMMenWikiViewController ()
{
    NKSegmentControl *seg;
    int selectIndex;
    UIView *headerView;
    UIButton *head;
    BOOL isSearch;
    WMMFeed *reportFeed;
    int getNearCount;
}
@end

@implementation WMMenWikiViewController

#define SHARE_TAG 112320
#define SHOW_REPORT_SHEET 13062401
#define REPORT_SHEET 13062402
#define SEARCHBACKTAG 130723001


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"manOK" object:nil];
    
    [_category release];
    [_showDataSource release];
    [_searchResults release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manOK:) name:@"manOK" object:nil];
        
    }
    return self;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [super scrollViewDidScroll:scrollView];
    if ([self.category isEqualToString:@"dianping"] && !scrollView.decelerating && [self.searchFiled isFirstResponder]) {
        [_searchFiled resignFirstResponder];
    }
//    if ( !scrollView.decelerating && [self.searchFiled isFirstResponder]) {
//        [_searchFiled resignFirstResponder];
//    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[WMAppDelegate shareAppDelegate] saveSystemFunction];
    getNearCount = 0;
    // Do any additional setup after loading the view from its nib.
    showTableView.frame = CGRectMake(0, 45, 320, SCREEN_HEIGHT-56-60);
    [self.refreshHeaderView changeStyle:EGORefreshTableHeaderStyleZUO];
    
    CGRect refreshHeaderFrame = self.refreshHeaderView.frame;
    //refreshHeaderFrame.origin.x -=22;
    self.refreshHeaderView.frame = refreshHeaderFrame;
    
    UIImageView *topShadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_top"]] autorelease];
    //[self.view addSubview:topShadow];
    CGRect topShadowFrame = topShadow.frame;
    topShadowFrame.origin.y = showTableView.frame.origin.y-2;
    topShadow.frame = topShadowFrame;

    UIView *tableViewHeader = [[[UIView alloc] initWithFrame:CGRectMake(showTableView.frame.origin.x, 0, showTableView.frame.size.width, 55)] autorelease];
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
        self.headBar.hidden = YES;
        if ([[WMAppDelegate shareAppDelegate] tabIndex]) {
            selectIndex = [[WMAppDelegate shareAppDelegate] tabIndex];
        }else {
            selectIndex = 0;
        }
        
        self.category = @"dianping";
        //self.dataSource = [[NKDataStore sharedDataStore] cachedArrayOf:WMCachePathDianpingMen andClass:[WMMMan class]];
        UIImageView *bShadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_bottom"]] autorelease];
        [self.view addSubview:bShadow];
        CGRect shadowFrame = bShadow.frame;
        shadowFrame.origin.y = showTableView.frame.origin.y+showTableView.frame.size.height - shadowFrame.size.height;
        bShadow.frame = shadowFrame;
        
        
        //showTableView.tableHeaderView = tableViewHeader;
        UIImageView *bgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableViewHeader.frame.size.width, 55)] autorelease];
        bgView.image = [UIImage imageNamed:@"wiki_top_bg"];
        [tableViewHeader addSubview:bgView];
        [self.view addSubview:tableViewHeader];
        NKSegment *remenSeg = [NKSegment segmentWithSize:CGSizeMake(80, 35) normalColor:[UIColor clearColor] highlightColor:[UIColor clearColor] andTitle:@"热门"];
        remenSeg.normalTextColor = [UIColor colorWithHexString:@"#B2A18D"];
        remenSeg.highlightTextColor = [UIColor colorWithHexString:@"#EB6877"];
        
        NKSegment *zuixinSeg = [NKSegment segmentWithSize:CGSizeMake(80, 35) normalColor:[UIColor clearColor] highlightColor:[UIColor clearColor] andTitle:@"最新"];
        zuixinSeg.normalTextColor = [UIColor colorWithHexString:@"#B2A18D"];
        zuixinSeg.highlightTextColor = [UIColor colorWithHexString:@"#EB6877"];
        
        NKSegment *fujinSeg = [NKSegment segmentWithSize:CGSizeMake(80, 35) normalColor:[UIColor clearColor] highlightColor:[UIColor clearColor] andTitle:@"附近"];
        fujinSeg.normalTextColor = [UIColor colorWithHexString:@"#B2A18D"];
        fujinSeg.highlightTextColor = [UIColor colorWithHexString:@"#EB6877"];
        
        NKSegment *dianpingSeg = [NKSegment segmentWithSize:CGSizeMake(80, 35) normalColor:[UIColor clearColor] highlightColor:[UIColor clearColor] andTitle:@"点评"];
        dianpingSeg.normalTextColor = [UIColor colorWithHexString:@"#B2A18D"];
        dianpingSeg.highlightTextColor = [UIColor colorWithHexString:@"#EB6877"];
        seg = [NKSegmentControl segmentControlViewWithSegments:[NSArray arrayWithObjects:dianpingSeg,fujinSeg,zuixinSeg, remenSeg, nil] andDelegate:self];
        
        [tableViewHeader addSubview:seg];
        CGRect segFrame = seg.frame;
        segFrame.origin.y = 8;
        seg.frame = segFrame;
        
        
        for (UIButton *button in seg.segments) {
            button.titleLabel.font = [UIFont systemFontOfSize:12];
        }
        
        self.segLine = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 1)] autorelease];
        self.segLine.backgroundColor = [UIColor colorWithHexString:@"#EB6877"];
        [seg addSubview:_segLine];
        
        UIButton *button = [seg.segments objectAtIndex:selectIndex];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _segLine.center = CGPointMake([button center].x, seg.frame.size.height+2);
        //[seg selectSegment:0 shouldTellDelegate:![self.dataSource count]];
        
        self.tabSeg = seg;
        
        self.topLabel = [[[UILabel alloc] initWithFrame:seg.frame] autorelease];
        [tableViewHeader addSubview:_topLabel];
        _topLabel.backgroundColor = [UIColor clearColor];
        _topLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
        _topLabel.font = [UIFont boldSystemFontOfSize:16];
        _topLabel.text = @"你可能认识的人";
        _topLabel.hidden = YES;
    }else {
        self.headBar.hidden = NO;
        selectIndex = 1;
        self.category = @"nearby";
        //self.dataSource = [[NKDataStore sharedDataStore] cachedArrayOf:WMCachePathNearByMen andClass:[WMMFeed class]];
        [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] autorelease] atIndex:0];
        [self addHeadShadow];
        
        
        self.titleLabel.text = @"附近";
        UIButton *addBtn = [self addRightButtonWithTitle:@"发布"];
        [addBtn removeTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [addBtn addTarget:self action:@selector(addPost:) forControlEvents:UIControlEventTouchUpInside];
        //[tableViewHeader addSubview:addBtn];
    }
    
    
    
    
    self.showDataSource = self.dataSource;
    
    
    self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
    loadingMoreView.target = self;
    loadingMoreView.action = @selector(getMoreData);
    [self showFooter:NO];
    
    CGRect loadingMoreViewFrame = self.loadingMoreView.infoLabel.frame;
    //loadingMoreViewFrame.origin.x -= 25;
    self.loadingMoreView.infoLabel.frame = loadingMoreViewFrame;
    
    
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
        UISwipeGestureRecognizer *leftswipe = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)] autorelease];
        leftswipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.showTableView addGestureRecognizer:leftswipe];
        UISwipeGestureRecognizer *rightSwipe = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)] autorelease];
        leftswipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.showTableView addGestureRecognizer:rightSwipe];
    }
    
    //[self refreshData];
    
}

-(void)leftSwipe:(id)sender
{
    [seg selectSegment:selectIndex+1 shouldTellDelegate:YES];
}

-(void)rightSwipe:(id)sender
{
    [seg selectSegment:selectIndex-1 shouldTellDelegate:YES];
}

-(void)addPost:(id)sender
{
    WMAddBaoliaoPseudoViewController *vc = [[[WMAddBaoliaoPseudoViewController alloc] init] autorelease];
    //addBaoliao.man = self.man;
    vc.father = self;
    [NKNC pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"dianpinghelp"]) {
        [self showHelpView];
        //[self performSelector:@selector(showHelpView) withObject:nil afterDelay:2.0];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"dianpinghelp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [seg selectSegment:selectIndex shouldTellDelegate:YES];
}

-(void)showHelpView
{
    WMHelpView *helpView = [[[WMHelpView alloc] initWithFrame:CGRectMake(0, 0, 320,SCREEN_HEIGHT)] autorelease];
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
    WMAppDelegate *appDelegate = [WMAppDelegate shareAppDelegate];
    [appDelegate.window  addSubview:helpView];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    [self searchWithText:text];
    return YES;
    
}

-(void)searchWithText:(NSString*)searchString{
    
    
    if ([searchString length]) {
        self.topLabel.text = @"搜索结果";
    }
    else{
        self.topLabel.text = @"你可能认识的人";
    }
    
    isSearch = YES;
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(searchOK:) andFailedSelector:@selector(searchFailed:)];
    [[WMManService sharedWMManService] searchManWithString:searchString offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
    
}

-(void)searchOK:(NKRequest*)request{
    
    isSearch = NO;
    [self doneLoadingTableViewData];
    
    currentPage = 1;
    self.totalCount = request.totalCount;
    ProgressHide;
    self.searchResults = (NSMutableArray*)request.results;
    self.showDataSource = self.searchResults;
    
    self.hasMore = [request.hasMore boolValue];
    if (!self.hasMore) {
        self.showTableView.tableFooterView = nil;
    }
    [[NKDataStore sharedDataStore] cacheArray:self.dataSource forCacheKey:WMCachePathDianpingMen];
    //[self.showDataSource removeAllObjects];
    [self.showTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [showTableView reloadData];
    [self setPullBackFrame];
    
    
}


-(void)searchFailed:(NKRequest*)request{
    
    isSearch = NO;
    [super refreshDataFailed:request];
    if ([request.errorCode integerValue] == 12011) {
        ProgressHide;
        [self.showDataSource removeAllObjects];
        [self.showTableView reloadData];
        UIButton *btn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 40, 320, 120)] autorelease];
        [btn setTitleColor:[UIColor colorWithHexString:@"#B2A18D"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:@"更新一下微博或人人账号才能点评好友哦" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        self.showTableView.tableFooterView =btn;
    }else {
        //ProgressErrorDefault;
        ProgressHide;
    }
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.tabSeg.hidden = NO;
    self.topLabel.hidden = YES;
    [_actionButton setBackgroundImage:[UIImage imageNamed:@"man_search_normal"] forState:UIControlStateNormal];
    [_actionButton setBackgroundImage:[UIImage imageNamed:@"man_search_click"] forState:UIControlStateHighlighted];
    [_actionButton removeTarget:self action:@selector(goToFav:) forControlEvents:UIControlEventTouchUpInside];

    [_actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_actionButton setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    _actionButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_actionButton setTitle:@"取消" forState:UIControlStateNormal];
//    if (head) {
//        [head removeFromSuperview];
//    }
    
    head = [[[UIButton alloc] initWithFrame:CGRectMake(0, 40, self.showTableView.frame.size.width, [WMMenCell cellHeightForObject:nil])] autorelease];
    [head addTarget:self action:@selector(goCreateMan:) forControlEvents:UIControlEventTouchUpInside];
    [head setImage:[UIImage imageNamed:@"createMan_normal"] forState:UIControlStateNormal];
    [head setImage:[UIImage imageNamed:@"createMan_click"] forState:UIControlStateHighlighted];
    UIImageView *headSep = [[[UIImageView alloc] initWithFrame:CGRectMake(0, head.frame.size.height-4, 320, 1)] autorelease];
    headSep.backgroundColor = [UIColor colorWithHexString:@"#EAE0D1"];
    [head addSubview:headSep];
    [headerView addSubview:head];
    //self.showTableView.tableHeaderView = head;
    
    CGRect frame = headerView.frame;
    if (frame.size.height<50) {
        frame.size.height += 80;
    }
    headerView.frame = frame;
    self.showTableView.tableHeaderView = headerView;
    ProgressLoading;
    self.showDataSource = nil;
    [showTableView reloadData];
    
    [self searchWithText:textField.text];
    
    return YES;
}

-(void)goToFav:(id)sender
{
    WMFavListViewController *favList = [[[WMFavListViewController alloc] init] autorelease];
    [NKNC pushViewController:favList animated:YES];
}

-(void)segmentControl:(NKSegmentControl*)control didChangeIndex:(NSInteger)index{
    
    UIButton *button = [control.segments objectAtIndex:index];
    selectIndex = index;
    [[WMAppDelegate shareAppDelegate] setTabIndex:selectIndex];
    switch (index) {
        case 0:{
            self.category = @"dianping";
            self.tabSeg.hidden = NO;
            self.topLabel.hidden = YES;
            //ProgressLoading;
            headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)] autorelease];
            
            self.actionButton = [[[UIButton alloc] initWithFrame:CGRectMake(242, 8, 63, 30)] autorelease];
            [headerView addSubview:_actionButton];
            [_actionButton setBackgroundImage:[UIImage imageNamed:@"guanzhu_normal"] forState:UIControlStateNormal];
            [_actionButton setBackgroundImage:[UIImage imageNamed:@"guanzhu_click"] forState:UIControlStateHighlighted];
            [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if (!_feedBadge) {
                self.feedBadge = [[[NKBadgeView alloc] initWithFrame:CGRectMake(48, 0, 14, 14)] autorelease];
                _feedBadge.placeHolderImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                _feedBadge.highlightedImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                _feedBadge.numberLabel.hidden = YES;
                [self.feedBadge bindValueOfModel:[WMNotificationCenter sharedNKNotificationCenter] forKeyPath:@"hasNewMan"];
                [_actionButton addSubview:self.feedBadge];
            }
            
            [_actionButton removeTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_actionButton addTarget:self action:@selector(goToFav:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *searchBack = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"man_search_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 40, 5, 40)]] autorelease];
            searchBack.userInteractionEnabled = YES;
            searchBack.tag = SEARCHBACKTAG;
            [headerView addSubview:searchBack];
            CGRect searchBackFrame = searchBack.frame;
            searchBackFrame.origin.y = 8;
            searchBackFrame.origin.x = 14;
            searchBackFrame.size.width = 221;
            searchBack.frame = searchBackFrame;
            
            
            self.searchFiled = [[[UITextField alloc] initWithFrame:CGRectMake(33, 0, 221, searchBack.frame.size.height)] autorelease];
            [searchBack addSubview:_searchFiled];
            _searchFiled.textColor = [UIColor colorWithHexString:@"#A07D46"];
            _searchFiled.placeholder = @"输入姓名搜索";
            _searchFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _searchFiled.font = [UIFont systemFontOfSize:12];
            _searchFiled.delegate = self;
            
            headerView.frame = CGRectMake(0, 0, 320, searchBack.frame.size.height+11);
            headerView.userInteractionEnabled = YES;
            self.showTableView.tableHeaderView = headerView;
            if ([control.segments count]>3) {
                UIButton *button1 = [control.segments objectAtIndex:1];
                UIButton *button2 = [control.segments objectAtIndex:2];
                UIButton *button3 = [control.segments objectAtIndex:3];
                button1.titleLabel.font = [UIFont systemFontOfSize:12];
                button2.titleLabel.font = [UIFont systemFontOfSize:12];
                button3.titleLabel.font = [UIFont systemFontOfSize:12];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            }
            
            [self searchWithText:@""];
            ProgressLoading;
            
            break;
        }
        case 2:{
            self.category = @"new";
            self.showTableView.tableHeaderView = nil;
            UIButton *button1 = [control.segments objectAtIndex:0];
            UIButton *button2 = [control.segments objectAtIndex:2];
            UIButton *button3 = [control.segments objectAtIndex:3];
            button1.titleLabel.font = [UIFont systemFontOfSize:12];
            button2.titleLabel.font = [UIFont systemFontOfSize:12];
            button3.titleLabel.font = [UIFont systemFontOfSize:12];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [self refreshData];
            ProgressLoading;
            break;
        }
        case 1:{
            self.category = @"nearby";
            self.showTableView.tableHeaderView = nil;
            UIButton *button1 = [control.segments objectAtIndex:1];
            UIButton *button2 = [control.segments objectAtIndex:0];
            UIButton *button3 = [control.segments objectAtIndex:3];
            button1.titleLabel.font = [UIFont systemFontOfSize:12];
            button2.titleLabel.font = [UIFont systemFontOfSize:12];
            button3.titleLabel.font = [UIFont systemFontOfSize:12];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [self refreshData];
            ProgressLoading;
            break;
        }
        case 3:{
            self.category = @"hot";
            self.showTableView.tableHeaderView = nil;
//            self.tabSeg.hidden = NO;
//            self.topLabel.hidden = YES;
//            self.tabSeg.hidden = NO;
//            self.topLabel.hidden = YES;
            //self.showTableView.tableHeaderView = nil;
//            self.showDataSource = self.dataSource;
//            [showTableView reloadData];
            UIButton *button1 = [control.segments objectAtIndex:1];
            UIButton *button2 = [control.segments objectAtIndex:2];
            UIButton *button3 = [control.segments objectAtIndex:0];
            button1.titleLabel.font = [UIFont systemFontOfSize:12];
            button2.titleLabel.font = [UIFont systemFontOfSize:12];
            button3.titleLabel.font = [UIFont systemFontOfSize:12];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [self refreshData];
            ProgressLoading;
            break;
        }
        default:
            self.category = @"hot";
            self.showTableView.tableHeaderView = nil;
            
            self.tabSeg.hidden = NO;
            self.topLabel.hidden = YES;
            
            self.showDataSource = self.dataSource;
            [showTableView reloadData];
            [self refreshData];
            ProgressLoading;
            break;
    }
    
    [UIView animateWithDuration:0.6 animations:^{
        _segLine.center = CGPointMake([button center].x, control.frame.size.height+2);
    }];
    
    
    
    
}



-(void)rightButtonClick:(id)sender{
    
    [WMWikiViewController wikiViewControllerForViewController:NKNC animated:YES];
    
}

-(void)actionButtonClick:(id)sender{
    
    if ([[self.actionButton titleForState:UIControlStateNormal] length]) {
        
        [_searchFiled resignFirstResponder];
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"guanzhu_normal"] forState:UIControlStateNormal];
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"guanzhu_click"] forState:UIControlStateHighlighted];
        //_actionButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
        _actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        //[_actionButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actionButton setTitle:@"" forState:UIControlStateNormal];
        [_actionButton removeTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_actionButton addTarget:self action:@selector(goToFav:) forControlEvents:UIControlEventTouchUpInside];
        [head removeFromSuperview];
        head = nil;
        CGRect frame = headerView.frame;
        if (frame.size.height>50) {
            frame.size.height -= 80;
        }
        headerView.frame = frame;
        //self.showTableView.tableHeaderView = nil;
        self.showTableView.tableHeaderView = headerView;
        //self.showDataSource = nil;
        [showTableView reloadData];
    }
    else{
        
        [_searchFiled becomeFirstResponder];
        
    }
    

    
}

-(void)goCreateMan:(WMMMan*)man{
    
    WMCreateManViewController *create = [[WMCreateManViewController alloc] init];
    if ([man isKindOfClass:[WMMMan class]]) {
        create.man = man;
        create.man.tags = [NSMutableArray array];
    }
    [NKNC pushViewController:create animated:YES];
    [create release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Data

-(void)manOK:(NSNotification*)anoti{
    
    NKMRecord *record = [anoti object];
    [self.dataSource insertObject:record atIndex:0];
    [showTableView reloadData];
    
}

-(void)refreshData{
    
//    if ([[self.actionButton titleForState:UIControlStateNormal] length]) {
//        
//        [self searchWithText:self.searchFiled.text];
//        
//    }else
    if ([self.category isEqualToString:@"dianping"]){
        [[WMNotificationCenter sharedNKNotificationCenter] getNotificationsCount];
        [self searchWithText:@""];
        //self.feedBadge.hidden = ![[WMNotificationCenter sharedNKNotificationCenter] hasNewMan];

    }else if ([self.category isEqualToString:@"nearby"]){
        ProgressHide;
        ProgressLoading;
        NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
        
        [[WMFeedService sharedWMFeedService] getFeedsNear:0 size:DefaultOneRequestSize andRequestDelegate:rd];
    }else{
        
        NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
        
        [[WMManService sharedWMManService] getMenWithCategory:self.category offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
    
    }
    
}


-(void)getMoreData{
    if (self.dataSource.count<DefaultOneRequestSize) {
        [loadingMoreView showNoMoreContent];
        return;
    }
    
    [self showFooter:YES];
    gettingMoreData = YES;
    
    NKRequestDelegate *rd = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
    if (![self.category isEqualToString:@"dianping"] && ![self.category isEqualToString:@"nearby"]) {
        [[WMManService sharedWMManService] getMenWithCategory:self.category offset:self.dataSource.count size:DefaultOneRequestSize andRequestDelegate:rd];
    }else if ([self.category isEqualToString:@"nearby"]) {
        [[WMFeedService sharedWMFeedService] getFeedsNear:[self.showDataSource count] size:DefaultOneRequestSize andRequestDelegate:rd];
    }else if ([self.category isEqualToString:@"dianping"]) {
        isSearch = YES;
        NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(searchMoreOK:) andFailedSelector:@selector(searchMoreFailed:)];
        [[WMManService sharedWMManService] searchManWithString:self.searchFiled.text offset:[self.showDataSource count] size:DefaultOneRequestSize andRequestDelegate:rd];
    }
    
}

-(void)searchMoreOK:(NKRequest *)request
{
    isSearch = NO;
    [self doneLoadingTableViewData];
    [self showFooter:NO];
    //currentPage = 1;
    //self.totalCount = [NSNumber numberWithInteger:request.totalCount+[self.showDataSource count]];
    ProgressHide;
    self.searchResults = (NSMutableArray*)request.results;
    [self.showDataSource addObjectsFromArray:self.searchResults];
    
    self.hasMore = [request.hasMore boolValue];
    if (!self.hasMore) {
        self.showTableView.tableFooterView = nil;
    }
    
    [showTableView reloadData];
    [self setPullBackFrame];
}

-(void)searchMoreFailed:(NKRequest *)request
{
    
}

-(void)getMoreDataOK:(NKRequest *)request{
    
    [self showFooter:NO];
    gettingMoreData = NO;
    
    currentPage ++;
    
    if ([request.results count] && ![self.category isEqualToString:@"nearby"]) {
        
        if (isSearch) {
            
            [self.searchResults addObjectsFromArray:request.results];
        }
        else{
            
            [self.dataSource addObjectsFromArray:request.results];
            
        }
        // 提升体验
        //[self.showTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        
        [self.showTableView reloadData];
        [self setPullBackFrame];
    }else if ([request.results count] && [self.category isEqualToString:@"nearby"]) {
        [self.dataSource addObjectsFromArray:request.results];
        [self.showTableView reloadData];
    }
    else{
        
        
        [loadingMoreView showNoMoreContent];
        
    }

    
    
    
    
}


-(void)refreshDataOK:(NKRequest *)request{
    [super refreshDataOK:request];
    [self.showTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    self.showDataSource = self.dataSource;
    //if ([self.category isEqualToString:@"nearby"]) {
    self.showTableView.tableHeaderView = nil;
    //}
    //[self.dataSource removeAllObjects];
    [self.showTableView reloadData];
    
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
        if (selectIndex == 0) {
            [[NKDataStore sharedDataStore] cacheArray:self.dataSource forCacheKey:WMCachePathDianpingMen];
        }
    }else {
        if (selectIndex == 1) {
            //[[NKDataStore sharedDataStore] cacheArray:self.dataSource forCacheKey:WMCachePathNearByMen];
        }
    }
    


    
}

-(void)refreshDataFailed:(NKRequest *)request
{
    
    //[super refreshDataFailed:request];
    if ([request.errorCode integerValue] == 99999 && getNearCount==0) {
        [self.showDataSource removeAllObjects];
        [self.showTableView reloadData];
        [self refreshData];
        [self doneLoadingTableViewData];
        //ProgressHide;
        getNearCount = 1;
    }else {
        getNearCount = 0;
        //ProgressErrorDefault;
    }
    ProgressHide;
    

}

-(void)setPullBackFrame{
   
}

#pragma mark TableView


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.category isEqualToString:@"nearby"] && [self.showDataSource count]>0) {
        return [WMManFeedCell cellHeightForObject:[self.showDataSource objectAtIndex:indexPath.row]];
    }else if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
        //return [WMManFeedCell cellHeightForObject:[self.showDataSource objectAtIndex:indexPath.row]];
    }
    return [WMMenCell cellHeightForObject:[self.showDataSource objectAtIndex:indexPath.row]];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.category isEqualToString:@"nearby"]) {
        
    }
    return [self.showDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = nil;
    Class klass = nil;
    id man = [self.showDataSource objectAtIndex:indexPath.row];
    if ([self.category isEqualToString:@"nearby"]) {
        CellIdentifier = @"WMNearByCellIdentifier";
        klass = [WMManFeedCell class];
    } else {
        CellIdentifier = @"WMFeedCellIdentifier";
        klass = [WMMenCell class];
        
    }
    
    id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[klass alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    if ([self.category isEqualToString:@"nearby"]) {
        [cell setDelegate:self];
    } else {
        [cell setShouldShowBadge:YES];
        
    }
    
    
    
    [cell showForObject:man];
    
    return cell;
}
-(void)setRate:(int)index feed:(WMMFeed *)feed
{
    [self.dataSource replaceObjectAtIndex:index withObject:feed];
}

-(void)showMoreView:(WMMFeed *)feed
{
    reportFeed = feed;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:@"分享到微信/QQ", nil];
    sheet.tag = SHOW_REPORT_SHEET;
    [sheet showInView:self.view];
    [sheet release];
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

- (void)share {
    NSString *titleString = [NSString stringWithFormat:@"关于 %@…", reportFeed.man.name];
    NSString *descString = nil;
    
    if ([reportFeed.type isEqualToString:WMFeedTypeDafen]) {
        NSMutableArray *scoreArr = [NSMutableArray array];
        
        for (id obj in reportFeed.score[@"scores"]) {
            [scoreArr addObject:[NSString stringWithFormat:@"%@%@分", obj[@"name"], obj[@"score"]]];
        }
        
        NSString *scoreString = [scoreArr componentsJoinedByString:@"，"];
        
        descString = [NSString stringWithFormat:@"%@ 给 %@ %@...", reportFeed.sender.name, reportFeed.man.name, scoreString];
    } else {
        descString = [NSString stringWithFormat:@"%@说：%@", reportFeed.sender.name, reportFeed.content];
    }
    
    descString = [descString stringByAppendingString:@" | 点击可匿名评论"];
    
    NSData *imageData = nil;
    NSString *imageURL = reportFeed.man.avatarBigPath;
    
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
    
    id<ISSContent> publishContent = [ShareSDK content:descString
                                       defaultContent:@""
                                                image:[ShareSDK imageWithData:imageData fileName:@"avatar.jpg" mimeType:@"image/jpeg"]
                                                title:@"薇蜜"
                                                  url:@"http://www.weimi.com/app?from=weibo"
                                          description:@"薇蜜"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:descString
                                           title:titleString
                                             url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@/review/%@?from=weixinmsg",reportFeed.man.mid, reportFeed.mid]
                                           image:[ShareSDK imageWithData:imageData fileName:@"avatar.jpg" mimeType:@"image/jpeg"]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:descString
                                            title:titleString
                                              url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@/review/%@?from=moment",reportFeed.man.mid, reportFeed.mid]
                                            image:[ShareSDK imageWithData:imageData fileName:@"avatar.jpg" mimeType:@"image/jpeg"]
                                     musicFileUrl:@""
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制QQ信息
    [publishContent addQQUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                              content:descString
                                title:titleString
                                  url:[NSString stringWithFormat:@"http://www.weimi.com/man/%@/review/%@?from=qq",reportFeed.man.mid, reportFeed.mid]
                                image:[ShareSDK imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:reportFeed.man.avatarBigPath]] fileName:@"avatar.jpg" mimeType:@"image/jpeg"]];
    
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"姑娘们对 %@ 的点评打分，八卦>>>http://http://www.weimi.com/man/%@?from=sms 【薇蜜】",reportFeed.man.name,reportFeed.man.mid]];
    
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

-(void)commentFinished
{
    self.category = @"nearby";
    //[self.dataSource removeAllObjects];
    [self refreshData];
}

-(void)deleteFeed
{
    self.category = @"nearby";
    //[self.dataSource removeAllObjects];
    [self refreshData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id man = [self.showDataSource objectAtIndex:indexPath.row];
    if ([self.category isEqualToString:@"nearby"]) {
        WMMFeed *feed = man;
        if ([feed.purview isEqualToString:@"open"] || [feed.sender.relation isEqualToString:@"自己"]) {
            WMBaoliaoXiangqingViewController *baoliaoXiangqing = [[[WMBaoliaoXiangqingViewController alloc] init] autorelease];
            baoliaoXiangqing.man = feed.man;
            baoliaoXiangqing.feed = feed;
            baoliaoXiangqing.delegate = self;
            [NKNC pushViewController:baoliaoXiangqing animated:YES];
        }else {
            ProgressFailedWith(@"只有她的姐妹闺蜜才能看哦~");
        }
    }else {
        WMMMan *wman = man;
        if (wman.mid) {
            [WMManDetailViewController manDetailWithMan:wman];
        }
        else{
            
            [self goCreateMan:man];
        }
    }

    
}

-(IBAction)logout:(id)sender{
    
    [[[[NKConfig sharedConfig] accountManagerClass] sharedAccountsManager] logOut];
    
}



@end
