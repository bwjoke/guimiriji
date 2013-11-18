//
//  WMDiscussListViewController.m
//  WEIMI
//
//  Created by steve on 13-6-28.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMDiscussListViewController.h"
#import "WMAppDelegate.h"

@interface WMDiscussListViewController ()
{
    NSString *sort;
}
@end

@implementation WMDiscussListViewController

#define CELL_SELECT_SHEET 13090501

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
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    sort = @"update";
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f5eee3"];
    
    self.titleLabel.text = _topicboard.name;
    [self addBackButton];
    [self addRightButtonWithTitle:@"发帖"];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    
    self.seg = [NKSegmentControl segmentControlViewWithSegments:[NSArray arrayWithObjects:
                                                                 [NKSegment segmentWithNormalBack:[UIImage imageNamed:@"topic_seg_left_normal"] selectedBack:[UIImage imageNamed:@"topic_seg_left_click"] title:@"最新顶贴" normalTextColor:[UIColor colorWithHexString:@"#A6937C"] andHighlightTextColor:[UIColor colorWithHexString:@"#f4f4f4"]],
                                                                 [NKSegment segmentWithNormalBack:[UIImage imageNamed:@"topic_seg_mid_normal"] selectedBack:[UIImage imageNamed:@"topic_seg_mid_click"] title:@"最新发帖" normalTextColor:[UIColor colorWithHexString:@"#A6937C"] andHighlightTextColor:[UIColor colorWithHexString:@"#f4f4f4"]],[NKSegment segmentWithNormalBack:[UIImage imageNamed:@"topic_seg_right_normal"] selectedBack:[UIImage imageNamed:@"topic_seg_right_click"] title:@"今日热门" normalTextColor:[UIColor colorWithHexString:@"#A6937C"] andHighlightTextColor:[UIColor colorWithHexString:@"#f4f4f4"]],
                                                                nil] andDelegate:self];
    
    
    UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
    header.backgroundColor = [UIColor colorWithHexString:@"#eae0d3"];
    self.showTableView.tableHeaderView = header;
    [header addSubview:_seg];
    _seg.center = CGPointMake(160, 20);
    
    CGRect frame = self.showTableView.frame;
    frame.size.height = SCREEN_HEIGHT - 64;
    self.showTableView.frame = frame;
    
    self.loadingMoreView = [NKLoadingMoreView loadingMoreViewWithStyle:NKLoadingMoreViewStyleZUO];
    loadingMoreView.target = self;
    loadingMoreView.action = @selector(getMoreData);
    [self showFooter:NO];
    
    CGRect loadingMoreViewFrame = self.loadingMoreView.infoLabel.frame;
    //loadingMoreViewFrame.origin.x -= 25;
    self.loadingMoreView.infoLabel.frame = loadingMoreViewFrame;
    [self refreshData];
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)getMoreData
{
    [self showFooter:YES];
    gettingMoreData = YES;
    
    NKRequestDelegate *rd = [NKRequestDelegate getMoreRequestDelegateWithTarget:self];
    ProgressLoading;
    [[WMTopicService sharedWMTopicService] getTopicList:_topicboard.mid sort:sort offset:[self.dataSource count] size:DefaultOneRequestSize andRequestDelegate:rd];
}

-(void)getMoreDataOK:(NKRequest *)request
{
    [super getMoreDataOK:request];
     ProgressHide;
}

-(void)getMoreDataFailed:(NKRequest *)request
{
    [super getMoreDataFailed:request];
    ProgressErrorDefault;
}

- (void)rightButtonClick:(id)sender {
    WMNewTopicViewController *vc = [[WMNewTopicViewController alloc] init];
    vc.delegate = self;
    vc.boardID = _topicboard.mid;
    [NKNC pushViewController:vc animated:YES];
    [vc release];
}

-(void)newTopicDidSuccess
{
    [self.showTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self refreshData];
}

-(void)segmentControl:(NKSegmentControl *)control didChangeIndex:(NSInteger)index
{
    switch (index) {
        case 0: {
            sort = @"update";
            break;
        }
        case 1: {
            sort = @"new";
            break;
        }
        case 2: {
            sort = @"hot";
            break;
        }
        default:
            sort = @"update";
            break;
    }
    [self refreshData];
}

-(void)refreshData
{
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    [[WMTopicService sharedWMTopicService] getTopicList:_topicboard.mid sort:sort offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
}

-(void)refreshDataOK:(NKRequest *)request
{
    [super refreshDataOK:request];
    ProgressHide;
}

-(void)refreshDataFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [WMDiscussCell cellHeightForObject:[self.dataSource objectAtIndex:indexPath.row]];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"WMMTopicListCellIdentifier";
    
    WMDiscussCell *cell = (WMDiscussCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[WMDiscussCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    WMMTopic *topic = [self.dataSource objectAtIndex:indexPath.row];
    [cell showForObject:topic];
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WMMTopic *topic = [self.dataSource objectAtIndex:indexPath.row];
    WMDiscussDetailViewController *vc = [[[WMDiscussDetailViewController alloc] init] autorelease];
    vc.topic_id = topic.mid;
    [NKNC pushViewController:vc animated:YES];
    
}

-(void)replyTopic:(int)index
{
    WMMTopic *topic = [self.dataSource objectAtIndex:index];
    WMDiscussDetailViewController *vc = [[[WMDiscussDetailViewController alloc] init] autorelease];
    vc.topic_id = topic.mid;
    [NKNC pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
