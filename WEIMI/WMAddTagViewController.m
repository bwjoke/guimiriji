//
//  WMAddTagViewController.m
//  WEIMI
//
//  Created by King on 4/9/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMAddTagViewController.h"

#import "WMManDetailViewController.h"

@interface WMAddTagViewController ()
{
    NSMutableArray *tagList;
}
@end

@implementation WMAddTagViewController

-(void)dealloc{
    
    [_man release];
    [tagList release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)goBack:(id)sender{

    
    self.man.tags = self.dataSource;
    [self.father addTableViewHeader];
    
    [super goBack:sender];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.shouldAutoRefreshData = NO;
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"#F1ECE4"];
    
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    [self addBackButton];
    
    tagList = [[NSMutableArray alloc] init];
    //[self addRightButtonWithTitle:@"完成"];
    showTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    showTableView.separatorColor = [UIColor colorWithHexString:@"#F1ECE4"];
    showTableView.backgroundColor = [UIColor clearColor];
    CGRect frame = showTableView.frame;
    frame.size.height +=20;
    showTableView.frame = frame;
    
    
    self.titleLabel.text = self.man.name;
    
    self.dataSource = self.man.tags?self.man.tags:[NSMutableArray array];
    
    self.inputView = [NKInputView inputViewWithTableView:self.showTableView dataSource:self.dataSource otherView:nil];
    [self.inputView.textView setDefaultPlaceHolder:@"印象中他的特点/优点/缺点..."];
    //self.inputView.textView.internalTextView.keyboardType = UIKeyboardTypeDefault;
    //self.inputView.textView.internalTextView.delegate = self;
    [self.contentView addSubview:_inputView];
    _inputView.target = self;
    _inputView.action = @selector(addTag:);
    [_inputView.sendButton setTitle:@"确定" forState:UIControlStateNormal];
    
    
    self.inputView.nimingButton.hidden = YES;
    _inputView.emojoButton.hidden = YES;
    _inputView.jianpanButton.hidden = YES;
    _inputView.nimingButton.hidden = YES;
    
    CGFloat xOff = 60;
    
    CGRect textFrame = _inputView.textView.frame;
    textFrame.origin.x -= xOff;
    textFrame.size.width += xOff;
    _inputView.textView.frame = textFrame;
    
    CGRect textBackFrame = _inputView.textViewBack.frame;
    textBackFrame.origin.x -= xOff;
    textBackFrame.size.width += xOff;
    _inputView.textViewBack.frame = textBackFrame;
    
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMoved:)];
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
    [pan release];
    
    self.showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getHotTagList];
}

-(void)getHotTagList
{
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getListOK:) andFailedSelector:@selector(getListFailed:)];
    [[WMSystemService sharedWMSystemService] getHotTagList:rd];
}

-(void)getListOK:(NKRequest *)request
{
    ProgressHide;
    NSArray *counts = (NSArray *)[request.originDic objectOrNilForKey:@"data"];
    for (int i=0; i<[counts count]; i++) {
        [tagList addObject:[counts objectAtIndex:i]];
    }
    if ([tagList count]>0) {
        [self addTableFooterView];
    }
    
}

-(void)getListFailed:(NKRequest *)request
{
    ProgressFailed;
}

-(void)addTableFooterView
{
    UIView *tableViewFooter = [[UIView alloc] init];
    tableViewFooter.userInteractionEnabled = YES;
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 120, 15)];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.font = [UIFont systemFontOfSize:14];
    titleLbl.text = @"热门标签";
    titleLbl.textColor = [UIColor colorWithHexString:@"#A6937C"];
    [tableViewFooter addSubview:titleLbl];
    [titleLbl release];
    int numOfLine = 0;
    int tagHeight = 40;
    CGFloat totalWidth = 15;
    for (int i=0; i<[tagList count]; i++) {
        NSString *tag = [tagList objectAtIndex:i];
        if (totalWidth + [WMTagButton widthOfButton:tag] > 290) {
            totalWidth = 15;
            tagHeight += 36;
            numOfLine += 1;
        }
        WMTagButton *button = [[[WMTagButton alloc] initWithFrame:CGRectMake(totalWidth, tagHeight, [WMTagButton widthOfButton:tag], 30) tag:tag index:i] autorelease];
        totalWidth += [WMTagButton widthOfButton:tag] + 5;
        button.delegate  = self;
        [tableViewFooter addSubview:button];
    }
    tableViewFooter.frame = CGRectMake(0, 0, 320, tagHeight+40);
    self.showTableView.tableFooterView = [tableViewFooter autorelease];
}

-(void)buttonTapAtIndex:(int)index
{
    [self addTag:[tagList objectAtIndex:index]];
    //[tagList removeObjectAtIndex:index];
    //[self.showTableView reloadData];
}

-(void)addTag:(NSString*)content{
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(addTagOK:) andFailedSelector:@selector(addTagFailed:)];
    [[WMManService sharedWMManService] addManTagWithMID:self.man.mid tag:content andRequestDelegate:rd];
    
    Progress(@"正在添加标签");
}

-(void)addTagOK:(NKRequest*)request{
    //[self.dataSource addObject:[request.results lastObject]];
    
    [self.dataSource removeAllObjects];
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    
    for (int i=0; i<[request.results count]; i++) {
        [self.dataSource addObject:[request.results objectAtIndex:i]];
    }
    [self.showTableView reloadData];
    [self setPullBackFrame];
    [_inputView sendOK];
    self.showTableView.tableFooterView = nil;
    [self addTableFooterView];
    ProgressSuccess(@"添加成功");
    [self.inputView.textView setDefaultPlaceHolder:@"印象中他的特点/优点/缺点..."];
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:0 inSection:0];;
    
    [showTableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

-(void)addTagFailed:(NKRequest*)request{
    
    ProgressErrorDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Gesture
-(void)tapped:(id)gesture{
    [_inputView hide];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if ([[otherGestureRecognizer view] isKindOfClass:[UITableView class]]) {
        [_inputView hide];
        [self.inputView.textView setDefaultPlaceHolder:@"印象中他的特点/优点/缺点..."];
        return YES;
    }
    
    return NO;
}

-(void)panMoved:(UIPanGestureRecognizer*)gest{
    
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.dataSource count] == 0) {
        return 1;
    }
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"WMFeedCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
//        UIView *line = [[[UIView alloc] initWithFrame:CGRectMake(0, 54, 320, 1)] autorelease];
//        [cell addSubview:line];
//        line.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
        cell.textLabel.highlightedTextColor = cell.textLabel.textColor;
        
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)] autorelease];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#FFF4F4"];
        
        UIImageView *sepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 54, 320, 1)];
        sepLine.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
        [cell addSubview:sepLine];
        [sepLine release];
        
    }
    
    if ([self.dataSource count]>0) {
        WMMTag *tag  = [self.dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = [tag.name stringByAppendingFormat:@"(%@)", tag.supportCount];
        //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", tag.supportCount];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[tag.iSupport boolValue]?@"man_tag_supported":@"man_tag_support"]] autorelease];
    }else {
        cell.textLabel.text = @"还未添加任何标签";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryView = nil;
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.dataSource count] == 0) {
        return;
    }
    WMMTag *tag  = [self.dataSource objectAtIndex:indexPath.row];
    
    if ([tag.iSupport boolValue]) {
        tag.iSupport = [NSNumber numberWithBool:NO];
        tag.supportCount = [NSNumber numberWithInt:[tag.supportCount intValue]-1];
        [[WMManService sharedWMManService] supportTagWithTID:tag.mid andRequestDelegate:nil];
        
        if ([tag.supportCount intValue]==0) {
            //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.dataSource removeObjectAtIndex:indexPath.row];
            [self.showTableView reloadData];
        }
    }
    else{
        
        NSArray *countArray = [self.dataSource filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"iSupport = 1"]];
        if ([countArray count]>=5) {
            ProgressFailedWith(@"最多只能赞同5个标签");
            return;
        }
        
        tag.iSupport = [NSNumber numberWithBool:YES];
        tag.supportCount = [NSNumber numberWithInt:[tag.supportCount intValue]+1];
        [[WMManService sharedWMManService] supportTagWithTID:tag.mid andRequestDelegate:nil];
        
    }
    [tableView reloadData];

}


@end
