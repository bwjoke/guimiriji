//
//  WMCharacterViewController.m
//  WEIMI
//
//  Created by Tang Tianyong on 8/22/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMInterestViewController.h"
#import "WMCustomLabel.h"
#import "WMManInterestCell.h"
#import <objc/runtime.h>

enum tWMInterestViewTag {
    kWMInterestViewTagAddInterest = 1,
    kWMInterestViewTagVote
};

@interface WMInterestViewController ()

@end

@implementation WMInterestViewController {
    NSArray *_interestList;
    WMManInterest *_selectInterest;
    BOOL _hasUpdateInterest;
    NSString *selectType;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _interestList = @[
            @{@"type": @"经常/喜欢去哪里", @"list": [[NSMutableArray alloc] init], @"desc": @"添加他经常/喜欢去哪里"},
            @{@"type": @"喜欢", @"list": [[NSMutableArray alloc] init], @"desc": @"添加他喜欢的事情或东西"},
            @{@"type": @"讨厌", @"list": [[NSMutableArray alloc] init], @"desc": @"添加他讨厌的事情或东西"},
            @{@"type": @"擅长", @"list": [[NSMutableArray alloc] init], @"desc": @"添加他擅长的事情或东西"},
            @{@"type": @"害怕", @"list": [[NSMutableArray alloc] init], @"desc": @"添加他害怕的事情或东西"}
        ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addBackButtonWithTitle:_man.name];
    [self.headBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] atIndex:0];
    [self addHeadShadow];
    
    self.titleLabel.text = [NSString stringWithFormat:@"他的喜好清单(%@)",[_man.interestCount stringValue]];
    
    showTableView.frame = CGRectMake(0, 44, 320, NKMainHeight-44);
    showTableView.backgroundColor = [UIColor whiteColor];
    
    [self refreshData];
}

- (void)refreshData {
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    [[WMManService sharedWMManService] getMenInterest:_man.mid andRequestDelegate:rd];
}

- (void)refreshDataOK:(NKRequest *)request {
    ProgressHide;
    [super refreshDataOK:request];
    
    [self cleanUpInerests];
    
    NSDictionary *result = request.originDic;
    
    if (result && result[@"data"] && result[@"data"][@"values"]) {
        NSDictionary *interests = result[@"data"][@"values"];
        if ([interests isKindOfClass:[NSDictionary class]]) {
            for (NSString *type in interests) {
                NSMutableArray *interestOfType = [self interestOfType:type];
                if (interestOfType != nil) {
                    [interestOfType removeAllObjects];
                    NSArray *interestList = interests[type];
                    for (NSDictionary *interest in interestList) {
                        [interestOfType addObject:[WMManInterest modelFromDic:interest]];
                    }
                }
            }
        }
    }
    
    [self updateTitle];
    
    [self.showTableView reloadData];
}

- (void)updateTitle {
    int numInterests = 0;
    
    for (NSDictionary *interests in _interestList) {
        NSMutableArray *interestList = interests[@"list"];
        numInterests += interestList.count;
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"他的喜好清单(%d)", numInterests];
}

- (void)cleanUpInerests {
    for (NSDictionary *interests in _interestList) {
        NSMutableArray *interestList = interests[@"list"];
        [interestList removeAllObjects];
    }
}

- (NSMutableArray *)interestOfType:(NSString *)type {
    for (NSDictionary *interest in _interestList) {
        if (type && [type isEqualToString:interest[@"type"]]) {
            return interest[@"list"];
        }
    }
    
    return nil;
}

- (void)refreshDataFailed:(NKRequest *)request {
    [super refreshDataFailed:request];
}

#pragma mark - TableView

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_interestList count];
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *interest = _interestList[section];
    NSArray *interests = interest[@"list"];
    return interests.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = _interestList[indexPath.section][@"list"];
    
    if (indexPath.row < [array count]) {
        WMManInterest *interest = array[indexPath.row];
        
        return [WMManInterestCell cellHeightForObject:interest];
    }
    
    return 55.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#A6937C"];
    WMCustomLabel *stateLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(0, 7, 320, 15) font:[UIFont boldSystemFontOfSize:14] textColor:[UIColor whiteColor]];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *type = _interestList[section][@"type"];
    
    stateLabel.text = [NSString stringWithFormat:@"他%@", type];
    
    [headerView addSubview:stateLabel];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    
    WMManInterestCell *cell = (WMManInterestCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WMManInterestCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSArray *array = _interestList[indexPath.section][@"list"];
    
    if (indexPath.row < [array count]) {
        WMManInterest *interest = array[indexPath.row];
        
        [cell showForObject:interest];
    }else {
        NSString *type = _interestList[indexPath.section][@"desc"];
        
        [cell showForObject:type];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = _interestList[indexPath.section][@"list"];
    
    NSDictionary *interestInfo = _interestList[indexPath.section];
    selectType = interestInfo[@"type"];
    
    if (indexPath.row >= [array count]) {
        NSString *title = interestInfo[@"desc"];
        
        WMPopView *popView = [[WMPopView alloc] initWithTitle:title numOfTextFiled:2];
        popView.tag = kWMInterestViewTagAddInterest;
        popView.delegate = self;
        UITextField* nameLabel = [[UITextField alloc] init];
        nameLabel.tag = 0;
        UITextField* descLabel = [[UITextField alloc] init];
        descLabel.tag = 1;
        
        nameLabel.borderStyle = UITextBorderStyleRoundedRect;
        descLabel.borderStyle = UITextBorderStyleRoundedRect;
        
        nameLabel.frame = CGRectMake( 10, 0,260, 30 );
        descLabel.frame = CGRectMake( 10, 35,280 -20, 30 );
        
        nameLabel.placeholder = @"内容(必填)";
        descLabel.placeholder = @"理由(可选)";
        
        [popView.contentView addSubview:nameLabel];
        [popView.contentView addSubview:descLabel];
        
        [nameLabel becomeFirstResponder];
        [popView showInView:self.view];
        
    }else {
        WMManInterest *interest = [array objectAtIndex:indexPath.row];
        [self voteInterest:interest];
    }
    [self.showTableView reloadData];
}

-(void)doneButtonClickWithPopView:(WMPopView *)popView
{
    if (popView.tag == kWMInterestViewTagAddInterest) {
        NSString *name,*desc;
        for (UIView *view in popView.contentView.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField *filed = (UITextField *)view;
                if (view.tag == 0) {
                    name = [[filed text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
                if (view.tag == 1) {
                    desc = [[filed text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
                
            }
        }
        if ([name length]==0) {
            ProgressFailedWith(@"内容不可以为空哦~");
            return;
        }
        
        NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(createOK:) andFailedSelector:@selector(createFailed:)];
        [[WMManService sharedWMManService] createInterest:_man.mid name:name type:selectType desc:desc andRequestDelegate:rd];
        [popView cancle:nil];
    }else if (popView.tag == kWMInterestViewTagVote) {
        NSString *desc;
        
        for (UIView *view in popView.contentView.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField *filed = (UITextField *)view;
                if (view.tag == 0) {
                    desc = [[filed text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
                
            }
        }
        [popView cancle:nil];
        ProgressLoading;
        NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(voteOK:) andFailedSelector:@selector(voteFailed:)];
        [[WMManService sharedWMManService] voteInterest:_selectInterest.mid desc:desc andRequestDelegate:rd];
    }
}

- (void)voteInterest:(WMManInterest *)interest {
    if ([interest.voted boolValue]) {
        ProgressLoading;
        NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(voteOK:) andFailedSelector:@selector(voteFailed:)];
        [[WMManService sharedWMManService] voteInterest:interest.mid desc:@"" andRequestDelegate:rd];
    }else {
        _selectInterest = interest;
        NSString *title = @"同意！+1";
        
        WMPopView *popView = [[WMPopView alloc] initWithTitle:title numOfTextFiled:1];
        popView.tag = kWMInterestViewTagVote;
        popView.delegate = self;
//        UITextField* nameLabel = [[UITextField alloc] init];
//        nameLabel.tag = 0;
        UITextField* descLabel = [[UITextField alloc] init];
        descLabel.tag = 0;
        
        //nameLabel.borderStyle = UITextBorderStyleRoundedRect;
        descLabel.borderStyle = UITextBorderStyleRoundedRect;
        
        //nameLabel.frame = CGRectMake( 10, 0,260, 30 );
        descLabel.frame = CGRectMake( 10, 0,280 -20, 30 );
        
        //nameLabel.placeholder = @"内容(必填)";
        descLabel.placeholder = @"理由(可选)";
        
        //[popView.contentView addSubview:nameLabel];
        [popView.contentView addSubview:descLabel];
        
        //[nameLabel becomeFirstResponder];
        [descLabel becomeFirstResponder];
        [popView showInView:self.view];
    }
}


-(void)createOK:(NKRequest *)request
{
    ProgressHide;
    _hasUpdateInterest = YES;
    [self refreshData];
}

-(void)createFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}

-(void)goBack:(id)sender
{
    if (_hasUpdateInterest) {
        if ([_delegate respondsToSelector:@selector(shouldGetManInfo)]) {
            [_delegate shouldGetManInfo];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)voteOK:(NKRequest *)request
{
    ProgressHide;
    _hasUpdateInterest = YES;
    [self refreshData];
}

-(void)voteFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
