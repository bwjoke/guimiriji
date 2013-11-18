// WMSearchManViewController.m
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

#import "WMSearchManViewController.h"

@interface WMSearchManViewController ()

@end

@implementation WMSearchManViewController {
    UITextField *_searchFiled;
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.category = @"dianping";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self addSearchBar];
    
    // Add shadow view {{{
    
    UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_tableheader_shadow"]];
    [self.headBar addSubview:shadow];
    CGRect shadowFrame = shadow.frame;
    shadowFrame.origin.y = 44;
    shadow.frame = shadowFrame;
    
    // }}}
    
    self.showTableView.tableFooterView = nil;
    
    [self addCreateButton];
    
    CGRect frame = self.showTableView.frame;
    
    self.showTableView.frame = (CGRect){frame.origin, frame.size.width, self.view.frame.size.height - frame.origin.y};
    
    self.shouldResignFirstResponderWhenTableBeginScroll = YES;
}

- (void)addSearchBar {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    
    UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectMake(242, 8, 63, 30)];
    [topView addSubview:actionButton];
    
    [actionButton setBackgroundImage:[UIImage imageNamed:@"man_search_normal"] forState:UIControlStateNormal];
    [actionButton setBackgroundImage:[UIImage imageNamed:@"man_search_click"] forState:UIControlStateHighlighted];
    [actionButton removeTarget:self action:@selector(goToFav:) forControlEvents:UIControlEventTouchUpInside];
    
    [actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [actionButton setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    actionButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [actionButton setTitle:@"返回" forState:UIControlStateNormal];
    
    [actionButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
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
    searchFiled.returnKeyType = UIReturnKeySearch;
    
    searchFiled.delegate = self;
    
    topView.frame = CGRectMake(0, 0, 320, searchBack.frame.size.height+11);
    topView.userInteractionEnabled = YES;
    [self.view addSubview:topView];
    
    [searchFiled becomeFirstResponder];
    
    _searchFiled = searchFiled;
}

- (void)addCreateButton {
    head = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, self.showTableView.frame.size.width, [WMMenCell cellHeightForObject:nil])];
    [head addTarget:self action:@selector(goCreateMan:) forControlEvents:UIControlEventTouchUpInside];
    [head setImage:[UIImage imageNamed:@"createMan_normal"] forState:UIControlStateNormal];
    [head setImage:[UIImage imageNamed:@"createMan_click"] forState:UIControlStateHighlighted];
    UIImageView *headSep = [[UIImageView alloc] initWithFrame:CGRectMake(0, head.frame.size.height-4, 320, 1)];
    headSep.backgroundColor = [UIColor colorWithHexString:@"#EAE0D1"];
    [head addSubview:headSep];
    
    self.showTableView.tableHeaderView = head;
}

- (UIView *)addToolView {
    return nil;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length > 0 && [string length] < 1) { // Delete
        // DO nothing
    } else { // Append
        NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\p{Han}]" options:0 error:nil];
        NSString *tempStr = [regex stringByReplacingMatchesInString:result options:0 range:NSMakeRange(0, [result length]) withTemplate:@""];
        
		if ([tempStr length] >= 2) {
            [self searchWithText:result];
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchWithText:textField.text];
    [textField resignFirstResponder];
    
    return NO;
}

- (void)refreshData {
    NSString *keyword = _searchFiled.text;
    
    if (keyword && keyword.length > 0) {
        [self searchWithText:keyword];
    } else {
        [super refreshData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
