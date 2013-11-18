//
//  WMSchoolListViewController.m
//  WEIMI
//
//  Created by Tang Tianyong on 7/29/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMSchoolListViewController.h"
#import "RegexKitLite.h"

@interface WMSchoolListViewController ()

#pragma mark - Lazy loading
- (UITableView *)tableView;
- (UISearchBar *)searchBar;

@end

@implementation WMSchoolListViewController {
    UITableView *_tableView;
    CGFloat _tableOriginHeight;
    UISearchBar *_searchBar;
    NSArray *_tableDataSource;
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
    
    if (self.schools && self.schools.count > 0) {
        _tableDataSource = self.schools;
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.searchBar];
    }
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
    
    NSDictionary *school = _tableDataSource[indexPath.row];
    
    NSAssert(school && school[@"name"] != nil, @"This is a bad school");
    
    cell.textLabel.text = school[@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(schoolDidSelect:)]) {
        NSDictionary *school = _tableDataSource[indexPath.row];
        [self.delegate schoolDidSelect:school];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchSchools];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchSchools];
}

- (void)searchSchools {
    NSString *keyWord = _searchBar.text;
    
    if (!keyWord || [keyWord isEqualToString:@""]) {
        _tableDataSource = self.schools;
    } else {
        // TODO: Do seach
        NSMutableArray *result = [NSMutableArray array];
        
        for (NSDictionary *school in self.schools) {
            NSAssert(school && school[@"name"] != nil, @"This is a bad school");
            
            if ([school[@"name"] isMatchedByRegex:keyWord]) {
                [result addObject:school];
            }
        }
        
        _tableDataSource = result;
    }
    
    [self.tableView reloadData];
}

#pragma mark -


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self searchSchools];
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
