//
//  WMUniversityManListViewController.m
//  WEIMI
//
//  Created by steve on 13-8-14.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMUniversityManListViewController.h"
#import "WMUniversityService.h"
#import "WMSearchUniversityManViewController.h"

@interface WMUniversityManListViewController ()

- (BOOL)isAllManOfSchoolList;

@end

@implementation WMUniversityManListViewController {
    UILabel *_subTitleLabel;
    UILabel *_subDescriptionLabel;
    UIView *_tableHeaderView;
    
    // Only for "本校所有男生"
    UITextField *_searchFiled;
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
	// Do any additional setup after loading the view.
    [self.headBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] atIndex:0];
    [self addHeadShadow];
    [self addBackButton];
    self.showTableView.frame = CGRectMake(0, 44, 320, SCREEN_HEIGHT-66);
    self.shouldResignFirstResponderWhenTableBeginScroll = YES;
    
    //[self addTableHeaderView];
    
    if (_universityManList) {
        UIButton *addButton = [self addRightButtonWithTitle:@"添加"];
        [addButton removeTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [addButton addTarget:self action:@selector(createMan:) forControlEvents:UIControlEventTouchUpInside];
        self.titleLabel.text = [[WMMUser me] universityName];
        
        if ([self isAllManOfSchoolList]) {
            CGRect frame = addButton.frame;
            frame.origin.x -= 45.0f;
            addButton.frame = frame;
            
            UIButton *searchButton = [self addRightButtonWithTitle:@"搜索"];
            [searchButton removeTarget:searchButton action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [searchButton addTarget:self action:@selector(searchMan:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }else if(_manList) {
        self.titleLabel.text = _manList.name;
    }
    
    self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
    loadingMoreView.target = self;
    loadingMoreView.action = @selector(getMoreData);
    //[self.showTableView.tableFooterView addSubview:self.loadingMoreView];
    self.showTableView.tableFooterView = self.loadingMoreView;
    [self refreshData];
    ProgressLoading;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)createMan:(id)sender
{
    WMMMan *man = [[WMMMan alloc] init];
    man.university = @{@"name":[[WMMUser me] universityName]};
    [self goCreateMan:man];
}

- (void)searchMan:(id)sender {
    WMSearchUniversityManViewController *vc = [[WMSearchUniversityManViewController alloc] init];
    vc.delegate = self;
    vc.universityManList = self.universityManList;
    [NKNC pushViewController:vc animated:YES];
}

-(void)refreshData
{
    if (_universityManList) {
        NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
        
        NSString *mid = _universityManList.mid;
        
        [[WMUniversityService sharedWMUniversityService] getMyUniversityManList:[[WMMUser me] universityId] bid:mid offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
    }else if(_manList) {
        NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
        [[WMManService sharedWMManService] getManListWithId:_manList.mid offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
    }
    
}

-(void)getMoreData{
    if (self.dataSource.count < DefaultOneRequestSize) {
        [loadingMoreView showNoMoreContent];
        return;
    }
    
    [self showFooter:YES];
    gettingMoreData = YES;
    
    if (_universityManList) {
        NKRequestDelegate *rd = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
        
        NSInteger offset = [self.dataSource count];
        
        [[WMUniversityService sharedWMUniversityService] getMyUniversityManList:[[WMMUser me] universityId] bid:_universityManList.mid offset:offset size:DefaultOneRequestSize andRequestDelegate:rd];
    }else if (_manList) {
        NKRequestDelegate *rd = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
        [[WMManService sharedWMManService] getManListWithId:_manList.mid offset:[self.dataSource count] size:DefaultOneRequestSize andRequestDelegate:rd];
    }
    
}

-(void)getMoreDataOK:(NKRequest *)request{
    
    [self showFooter:NO];
    gettingMoreData = NO;
    
    currentPage ++;
    
    if ([request.results count]) {
        
        [self.dataSource addObjectsFromArray:request.results];
        // 提升体验
        //[self.showTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        
        [self.showTableView reloadData];
        [self setPullBackFrame];
    }else{
        [loadingMoreView showNoMoreContent];
        
    }
    
    if (![request.hasMore boolValue]) {
        self.showTableView.tableFooterView = nil;
    }

    
}

-(void)getMoreDataFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}

-(void)refreshDataOK:(NKRequest *)request{
    [super refreshDataOK:request];
    [self.showTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.showTableView reloadData];
    
    if (_universityManList) {
        if (self.dataSource.count > 0) {
            [self updateTableHeaderView];
        }else {
            
        }
    }
    if (![request.hasMore boolValue]) {
        self.showTableView.tableFooterView = nil;
    }
}

- (void)updateTableHeaderView {
    _tableHeaderView.hidden = NO;
}

-(void)shouldReload
{
    [self refreshData];
}


#pragma mark TableView
-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, self.showTableView.frame.size.width, 40.0f)];
    tableHeaderView.backgroundColor = [UIColor colorWithHexString:@"#f2e9dc"];
    
    _tableHeaderView = tableHeaderView;
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 305, tableHeaderView.frame.size.height)];
    leftLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    leftLabel.textColor = [UIColor colorWithHexString:@"#7e6b5a"];
    leftLabel.textAlignment = UITextAlignmentLeft;
    leftLabel.backgroundColor = [UIColor clearColor];
    [tableHeaderView addSubview:leftLabel];
    
    _subTitleLabel = leftLabel;
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, tableHeaderView.frame.size.height - 1, tableHeaderView.frame.size.width, 1)];
    bottomLine.image = [UIImage imageNamed:@"men_cell_sep"];
    [tableHeaderView addSubview:bottomLine];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 305, tableHeaderView.frame.size.height)];
    rightLabel.font = [UIFont systemFontOfSize:14.0f];
    rightLabel.textColor = [UIColor colorWithHexString:@"#7e6b5a"];
    rightLabel.textAlignment = UITextAlignmentRight;
    rightLabel.backgroundColor = [UIColor clearColor];
    [rightLabel adjustsFontSizeToFitWidth];
    [tableHeaderView addSubview:rightLabel];
    
    _subDescriptionLabel = rightLabel;
    if (_universityManList) {
        _subTitleLabel.text = _universityManList.name;
        _subDescriptionLabel.text = _universityManList.desc;
    }else if (_manList) {
        _subTitleLabel.text = _manList.name;
        _subDescriptionLabel.text = _manList.desc;
    }
    
    return tableHeaderView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [WMMenCell cellHeightForObject:[self.dataSource objectAtIndex:indexPath.row]];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"WMFeedCellIdentifier";
    id cell = nil;
    
    id data = [self.dataSource objectAtIndex:indexPath.row];
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[WMMenCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell showForObject:data];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id man = [self.dataSource objectAtIndex:indexPath.row];
    
    [self manDidSelect:man];
}

-(void)manDidSelect:(WMMMan *)man {
    WMMMan *wman = man;
    if (wman.mid) {
        WMManDetailViewController *vc = [[WMManDetailViewController alloc] init];
        vc.delegate = self;
        vc.man = wman;
        vc.shouldNotBackToRoot = YES;
        [NKNC pushViewController:vc animated:YES];
        //[WMManDetailViewController manDetailWithMan:wman];
    }else {
        [self goCreateMan:wman];
    }
}

-(void)goCreateMan:(WMMMan*)man{
    
    WMCreateManViewController *create = [[WMCreateManViewController alloc] init];
    if ([man isKindOfClass:[WMMMan class]]) {
        man.university = @{@"name": [[WMMUser me] universityName]};
        create.man = man;
        create.isFromUniversity = YES;
        create.man.tags = [NSMutableArray array];
    }else {
        create.viewFinishLoad = ^(WMCreateManViewController *create ){
            [create.school setTitle:[[WMMUser me] universityName] forState:UIControlStateNormal];
        };
    }
    [NKNC pushViewController:create animated:YES];
    
}

-(void)refreshDataFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isAllManOfSchoolList {
    return [self.universityManList.type isEqualToString:@"alluniv"];
}

@end
