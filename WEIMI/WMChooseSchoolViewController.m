//
//  WMChooseSchoolViewController.m
//  WEIMI
//
//  Created by Tang Tianyong on 7/29/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMChooseSchoolViewController.h"
#import "RegexKitLite.h"

@interface WMChooseSchoolViewController ()

// Lazy loading
- (UITableView *)tableView;
- (UISearchBar *)searchBar;

// Fetch schools
- (void)fetchSchools;

// Seach schools
- (void)seachSchools:(NSString *)keyWord;

// Lazy loading
// Provinces
- (NSArray *)provinces;

@end

@implementation WMChooseSchoolViewController {
    UITableView *_tableView;
    CGFloat _tableOriginHeight;
    UISearchBar *_searchBar;
    NSArray *_tableDataSource;
    NSDictionary *_originData;
    NSArray *_provinces;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self doInitialize];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self doInitialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInitialize];
    }
    return self;
}

- (void)doInitialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.headBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] atIndex:0];
    [self addHeadShadow];
    [self addBackButton];
    
    UIButton *topRightButton = [self addRightButtonWithTitle:@"取消"];
    topRightButton.hidden = YES;
    
    self.titleLabel.text = @"选择学校";
    
    // Remove default showTableView
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    
    // Add new tableView
    [self fetchSchools];
}

#pragma mark - Fetch schools
- (void)fetchSchools {
    ProgressLoading;
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self
                                                          finishSelector:@selector(fetchSchoolsOK:)
                                                       andFailedSelector:@selector(fetchSchoolsFailed:)];
    [[WMSystemService sharedWMSystemService] getSchoolList:rd];
}

- (void)fetchSchoolsOK:(NKRequest *)request {
    ProgressHide;
    
    NSAssert(request.originDic != nil, @"fetchSchoolsOK: originDic is nil");
    NSDictionary *originDic = request.originDic;
    
    NSAssert(originDic[@"data"] != nil, @"fetchSchoolsOK: There is no school");
    _originData = originDic[@"data"];
    _tableDataSource = self.provinces;
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    
    // If initial province provided, goto that province's school list
    if (self.initialProvince != nil) {
        NSString *province = [self.initialProvince description];
        self.initialProvince = nil;
        
        NSInteger index = [self.provinces indexOfObject:province];
        
        if (index != NSNotFound) {
            [self gotoSchoolList:province animate:NO];
        }
    }
}

- (void)fetchSchoolsFailed:(NKRequest *)request {
    ProgressErrorDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)provinces {
    if (_provinces != nil) {
        return _provinces;
    }
    
    NSString *provinceString = _originData[@"province_list"];
    provinceString = [provinceString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    provinceString = [provinceString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _provinces = [provinceString componentsSeparatedByString:@","];
    return _provinces;
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ident = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    NSString *title = nil;
    id item = _tableDataSource[indexPath.row];
    
    if ([item isKindOfClass:[NSDictionary class]]) {
        title = item[@"name"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else { // Province name
        title = [item description];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = title;
    
    return cell;
}

- (BOOL)isSearching {
    NSString *keyWord = _searchBar.text;
    BOOL isSearching = keyWord && ![keyWord isEqualToString:@""];
    return isSearching;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isSearching]) {
        if ([self.delegate respondsToSelector:@selector(schoolDidSelect:)]) {
            NSDictionary *school = _tableDataSource[indexPath.row];
            [self.delegate schoolDidSelect:school];
        }
    } else {
        NSString *province = _tableDataSource[indexPath.row];
        
        NSAssert([self.provinces indexOfObject:province] != NSNotFound, @"There is no such a province");
        
        [self gotoSchoolList:province animate:YES];
    }
}

- (void)gotoSchoolList:(NSString *)province animate:(BOOL)isAnimate {
    WMSchoolListViewController *vc = [[WMSchoolListViewController alloc] init];
    vc.delegate = self;
    vc.schools = _originData[@"university_list"][province];
    [NKNC pushViewController:vc animated:isAnimate];
}

- (void)schoolDidSelect:(NSDictionary *)university {
    if ([self.delegate respondsToSelector:@selector(schoolDidSelect:)]) {
        [self.delegate schoolDidSelect:university];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self seachSchools:searchText];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *keyWord = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [self seachSchools:keyWord];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *keyWord = searchBar.text;
    [self seachSchools:keyWord];
}

- (void)seachSchools:(NSString *)keyWord {
    if (!keyWord || [keyWord isEqualToString:@""]) {
        _tableDataSource = self.provinces;
    } else {
        // TODO: Do seach
        
        // Filter the space and newline, include which is intermidate
        keyWord = [keyWord stringByReplacingOccurrencesOfRegex:@"\\s" withString:@""];
        
        NSMutableArray *result = [NSMutableArray array];
        NSArray *schools = nil;
        
        for (NSString *province in _originData[@"university_list"]) {
            schools = _originData[@"university_list"][province];
            for (NSDictionary *school in schools) {
                
                NSAssert(school && school[@"name"] != nil, @"This is a bad school");
                
                if ([school[@"name"] isMatchedByRegex:keyWord]) {
                    [result addObject:school];
                }
            }
        }
        
        _tableDataSource = result;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Lazy loading
- (UITableView *)tableView {
    if (_tableView != nil) {
        return _tableView;
    }
    
    CGFloat startY = 80.0f;

    CGRect frame = self.view.bounds;
    _tableOriginHeight = (frame.size.height -= startY);
    frame.origin.y = startY;

    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    return _tableView;
}

- (UISearchBar *)searchBar {
    if (_searchBar != nil) {
        return _searchBar;
    }
    
    CGRect frame = self.view.bounds;
    frame.size.height = 40.0f;
    frame.origin.y = 40.0f;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:frame];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"输入学校名搜索";
    
    return _searchBar;
}

- (void)rightButtonClick:(id)sender {
    [self.searchBar setText:@""];
    [self seachSchools:@""];
    [self.searchBar resignFirstResponder];
}

#pragma mark - NSNotificationCenter
- (void)keyboardWillShow:(NSNotification *)noti {
    CGFloat during = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGFloat keyboardHeight = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size.height;
    
    CGRect frame = self.tableView.frame;
    frame.size.height = _tableOriginHeight - keyboardHeight;
    
    self.nkRightButton.hidden = NO;
    
    [UIView
     animateWithDuration:during
     delay:0
     options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
     animations:^{
         self.tableView.frame = frame;
     }
     completion:NULL];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    CGFloat during = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    
    CGRect frame = self.tableView.frame;
    frame.size.height = _tableOriginHeight;
    
    self.nkRightButton.hidden = YES;
    
    [UIView
     animateWithDuration:during
     delay:0
     options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
     animations:^{
         self.tableView.frame = frame;
     }
     completion:NULL];
}

@end
