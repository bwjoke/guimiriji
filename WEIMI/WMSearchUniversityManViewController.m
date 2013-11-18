// WMSearchUniversityManViewController.m
//
// Copyright (c) 2013 Tang Tianyong
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
// KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
// AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

#import "WMSearchUniversityManViewController.h"
#import "WMUniversityService.h"
#import "WMManDetailViewController.h"

@interface WMSearchUniversityManViewController ()

@end

@implementation WMSearchUniversityManViewController {
    UITextField *_searchFiled;
    UIButton *_actionButton;
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
    [self createSearchField];
    
    self.titleLabel.text = @"搜索本校男生";
    
    [self refreshData];
}

-(void)refreshData
{
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    NSString *mid = _universityManList.mid;
    
    ProgressLoading;
    [[WMUniversityService sharedWMUniversityService] getMyUniversityManList:[[WMMUser me] universityId] bid:mid offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
}

-(void)getMoreData{
    if (self.dataSource.count < DefaultOneRequestSize) {
        [loadingMoreView showNoMoreContent];
        return;
    }
    
    [self showFooter:YES];
    gettingMoreData = YES;
    
    NKRequestDelegate *rd = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
    
    NSInteger offset = [self.dataSource count];
    
    [[WMUniversityService sharedWMUniversityService] getMyUniversityManList:[[WMMUser me] universityId] bid:_universityManList.mid offset:offset size:DefaultOneRequestSize andRequestDelegate:rd];
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
}

-(void)getMoreDataFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}

-(void)refreshDataOK:(NKRequest *)request{
    [super refreshDataOK:request];
    [self.showTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.showTableView reloadData];
    
    // Clear the search text field
    _searchFiled.text = @"";
}

- (void)createSearchField {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0)];
    
    
    UIImageView *searchBack = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"man_search_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 40, 5, 40)]] ;
    searchBack.userInteractionEnabled = YES;
    [headerView addSubview:searchBack];
    CGRect searchBackFrame = searchBack.frame;
    searchBackFrame.origin.y = 8;
    searchBackFrame.origin.x = 14;
    searchBackFrame.size.width = 295;
    searchBack.frame = searchBackFrame;
    
    UITextField *searchFiled = [[UITextField alloc] initWithFrame:CGRectMake(33, 0, 221, searchBack.frame.size.height)];
    [searchBack addSubview:searchFiled];
    searchFiled.textColor = [UIColor colorWithHexString:@"#A07D46"];
    searchFiled.placeholder = @"输入姓名搜索";
    searchFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchFiled.font = [UIFont systemFontOfSize:12];
    searchFiled.delegate = self;
    
    searchFiled.returnKeyType = UIReturnKeySearch;
    
    _searchFiled = searchFiled;
    
    headerView.frame = CGRectMake(0, 44, 320, searchBack.frame.size.height+11);
    headerView.userInteractionEnabled = YES;
    
    self.showTableView.tableHeaderView = headerView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self searchSchoolMan:textField.text];
    
    return NO;
}

#pragma mark - Search school man

- (void)searchSchoolMan:(NSString *)keyword {
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(searchOK:) andFailedSelector:@selector(searchFailed:)];
    
    ProgressLoading;
    
    [[WMUniversityService sharedWMUniversityService] searchSchoolMan:[[WMMUser me] universityId] keyword:keyword andRequestDelegate:rd];
}

- (void)searchOK:(NKRequest *)request {
    ProgressHide;
    
    self.dataSource = [NSMutableArray arrayWithArray:request.results];
    
    [self.showTableView reloadData];
}

- (void)searchFailed:(NKRequest *)request {
    ProgressErrorDefault;
}

#pragma mark - Cancel search

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WMMenCell cellHeightForObject:[self.dataSource objectAtIndex:indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"WMFeedCellIdentifier";
    id cell = nil;
    id data = nil;
    
    data = [self.dataSource objectAtIndex:indexPath.row];
    
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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(manDidSelect:)]) {
        [self.delegate performSelector:@selector(manDidSelect:) withObject:man];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
