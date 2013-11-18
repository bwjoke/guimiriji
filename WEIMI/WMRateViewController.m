//
//  WMRateViewController.m
//  WEIMI
//
//  Created by King on 11/21/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMRateViewController.h"
#import "WMRateCell.h"
#import "WMAddZDYDafenViewController.h"


@interface WMRateViewController ()
{
    NSString *scoreStr;
    UIView *scoreHeaderView;
}
@end

@implementation WMRateViewController


-(void)dealloc{
    [_man release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] autorelease] atIndex:0];
    [self addHeadShadow];

    [self addBackButton];
    [self addRightButtonWithTitle:@"完成"];
    [self setShouldAutoRefreshData:NO];
    self.showTableView.frame = CGRectMake(0, 98, 320, NKMainHeight-44-57);
    self.showTableView.backgroundColor = [UIColor colorWithHexString:@"F1ECE4"];
    
    [self setupUI];
    
    
    self.seg = [NKSegmentControl segmentControlViewWithSegments:[NSArray arrayWithObjects:
                                                                 [NKSegment segmentWithNormalBack:[UIImage imageNamed:@"purview_seg_left_normal"] selectedBack:[UIImage imageNamed:@"purview_seg_left_click"] title:@"匿名" normalTextColor:[UIColor colorWithHexString:@"#A6937C"] andHighlightTextColor:[UIColor colorWithHexString:@"#59493F"]],
                                                                 [NKSegment segmentWithNormalBack:[UIImage imageNamed:@"purview_seg_mid_normal"] selectedBack:[UIImage imageNamed:@"purview_seg_mid_click"] title:@"私密" normalTextColor:[UIColor colorWithHexString:@"#A6937C"] andHighlightTextColor:[UIColor colorWithHexString:@"#59493F"]],
                                                                 [NKSegment segmentWithNormalBack:[UIImage imageNamed:@"purview_seg_right_normal"] selectedBack:[UIImage imageNamed:@"purview_seg_right_click"] title:@"公开" normalTextColor:[UIColor colorWithHexString:@"#A6937C"] andHighlightTextColor:[UIColor colorWithHexString:@"#59493F"]],
                                                                 nil] andDelegate:self];
    
    
    UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)] autorelease];
    self.showTableView.tableHeaderView = header;
    
    UIImageView *noticeBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_notice"]] autorelease];
    [header addSubview:noticeBack];
    noticeBack.frame = CGRectMake(0, 55, noticeBack.frame.size.width, noticeBack.frame.size.height);
    
    self.notice = [[[UILabel alloc] initWithFrame:CGRectMake(15, 2, 290, noticeBack.frame.size.height)] autorelease];
    [noticeBack addSubview:_notice];
    self.notice.backgroundColor = [UIColor clearColor];
    _notice.textAlignment = NSTextAlignmentCenter;
    _notice.textColor = [UIColor colorWithHexString:@"#968677"];
    _notice.font = [UIFont systemFontOfSize:10];
    //[_seg selectSegment:0 shouldTellDelegate:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[[userDefaults valueForKey:@"sysFunction"] valueForKey:@"purview"] boolValue]) {
        [header addSubview:_seg];
        _seg.center = CGPointMake(160, 30);
        
        
        
    }else {
        CGRect frame = noticeBack.frame;
        frame.origin.y -= 50;
        noticeBack.frame = frame;
        frame = header.frame;
        frame.origin.y -= 50;
        frame.size.height -= 50;
        header.frame = frame;
        self.showTableView.tableHeaderView = nil;
        self.showTableView.tableHeaderView = header;
        
            
    }
    NSLog(@"%@",[[userDefaults valueForKey:@"sysFunction"] valueForKey:@"privacy"]);
//    if ([[[userDefaults valueForKey:@"sysFunction"] valueForKey:@"privacy"] boolValue]) {
//        [_seg selectSegment:1 shouldTellDelegate:YES];
//    }else {
//        [_seg selectSegment:0 shouldTellDelegate:YES];
//    }
    [_seg selectSegment:0 shouldTellDelegate:YES];
    if ([[[userDefaults valueForKey:@"sysFunction"] valueForKey:@"scorebtn"] boolValue]) {
        UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 100)] autorelease];
        UIButton *addScoreButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 20, 320, 32)] autorelease];
        [footerView addSubview:addScoreButton];
        showTableView.tableFooterView = footerView;
        [addScoreButton addTarget:self action:@selector(addNewScore:) forControlEvents:UIControlEventTouchUpInside];
        [addScoreButton setImage:[UIImage imageNamed:@"man_score_add_normal"] forState:UIControlStateNormal];
        [addScoreButton setImage:[UIImage imageNamed:@"man_score_add_click"] forState:UIControlStateHighlighted];
        [addScoreButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    
    
    
    
    

    
    //self.dataSource = [[NKDataStore sharedDataStore] cachedArrayOf:WMCachePathScores andClass:[WMMScore class]];
    if (self.dataSource.count) {
//        self.dataSource = [NSMutableArray arrayWithObjects:
//                           
//                           [WMMScore modelFromDic:@{@"name":@"外貌", @"score":@"?"}],
//                           [WMMScore modelFromDic:@{@"name":@"幽默", @"score":@"?"}],
//                           [WMMScore modelFromDic:@{@"name":@"潜力", @"score":@"?"}],
//                           [WMMScore modelFromDic:@{@"name":@"风度", @"score":@"?"}],
//                           [WMMScore modelFromDic:@{@"name":@"专一", @"score":@"?"}],
//                           [WMMScore modelFromDic:@{@"name":@"吻技", @"score":@"?"}],
//                           [WMMScore modelFromDic:@{@"name":@"XXOO", @"score":@"?"}],
//                           nil];
       
        
        
        
        //[[NKDataStore sharedDataStore] cacheArray:self.dataSource forCacheKey:WMCachePathScores];
        
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"scoretag"]) {
        NSArray *array = [[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"scoretag"];
        for (int i=0; i<[array count]; i++) {
            [self.dataSource addObject:[WMMScore modelFromDic:@{@"name":[array objectAtIndex:i], @"score":@"?"}]];
        }
    }else {
        self.dataSource = [NSMutableArray arrayWithObjects:
                           [WMMScore modelFromDic:@{@"name":@"脸", @"score":@"?"}],
                           [WMMScore modelFromDic:@{@"name":@"身材", @"score":@"?"}],
                           [WMMScore modelFromDic:@{@"name":@"风度", @"score":@"?"}],
                           [WMMScore modelFromDic:@{@"name":@"幽默", @"score":@"?"}],
                           [WMMScore modelFromDic:@{@"name":@"卫生", @"score":@"?"}],
                           [WMMScore modelFromDic:@{@"name":@"专一度", @"score":@"?"}],
                           [WMMScore modelFromDic:@{@"name":@"潜力", @"score":@"?"}],
                           [WMMScore modelFromDic:@{@"name":@"床风", @"score":@"?"}],
                           [WMMScore modelFromDic:@{@"name":@"厨艺", @"score":@"?"}],
                           [WMMScore modelFromDic:@{@"name":@"唱功", @"score":@"?"}],
                           nil];
    }
    
    
    
    
    scoreStr = @"0";
    [self updateHeaderView];
}

-(void)updateHeaderView
{
    if (scoreHeaderView) {
        [scoreHeaderView removeFromSuperview];
        scoreHeaderView = nil;
    }
    scoreHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 42, 320, 57)] autorelease];
    UIImageView *scoreBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_score_bg"]] autorelease];
    [scoreHeaderView addSubview:scoreBack];
    CGRect scoreBackFrame = scoreBack.frame;
    scoreBackFrame.origin.x = 77;
    scoreBackFrame.origin.y = 18;
    scoreBack.frame = scoreBackFrame;
    //scoreStr = [self.man.score stringValue];
    //self.man.score = [NSNumber numberWithFloat:4.5];
    float scoreTotal = 0.0;
    int scoreNumCount = 0;
    for (int i=0; i<[self.dataSource count]; i++) {
        WMMScore *score = [self.dataSource objectAtIndex:i];
        if ([score.score intValue]!=0) {
            scoreTotal += [score.score intValue];
            scoreNumCount++;
        }
        
    }
    scoreStr = [NSString stringWithFormat:@"%0.2f",scoreTotal/scoreNumCount];
    
    UILabel *scoreLabel = [[[UILabel alloc] initWithFrame:CGRectMake(207, 6, 80, 39)] autorelease];
    [scoreLabel adjustsFontSizeToFitWidth];
    [scoreHeaderView addSubview:scoreLabel];
    scoreLabel.backgroundColor = [UIColor clearColor];
    if ([scoreStr floatValue]<0) {
        scoreLabel.text = @"负分";
    }else {
        scoreLabel.text = scoreStr ? [NSString stringWithFormat:[scoreStr floatValue]<=-10?@"%.0f":@"%.1f", [scoreStr floatValue]]:nil;
    }
    
    //scoreLabel.textAlignment = NSTextAlignmentRight;
    scoreLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:25];
    scoreLabel.textColor = [UIColor colorWithHexString:@"#EB6877"];
    
    UIImageView *score = nil;
    
    if ([scoreStr floatValue] <= 2) {
        score = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_score_one"]] autorelease];
        CGRect scoreFrame = score.frame;
        if ([scoreStr floatValue] <=0) {
            scoreFrame.size.width = score.image.size.width/5.0 * 0.44;
        }else {
            scoreFrame.size.width = score.image.size.width/5.0 * 0.44+score.image.size.width/13.0 * ([scoreStr floatValue]/2.0);
        }
        
        score.frame = scoreFrame;
    }else if ([scoreStr floatValue]<=4) {
        score = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_score_two"]] autorelease];
        CGRect scoreFrame = score.frame;
        scoreFrame.size.width =  score.image.size.width * ([scoreStr floatValue])/10.0;
        score.frame = scoreFrame;
    }else if ([scoreStr floatValue]<=6) {
        score = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_score_three"]] autorelease];
        CGRect scoreFrame = score.frame;
        scoreFrame.size.width =  score.image.size.width * ([scoreStr floatValue])/10.0;
        score.frame = scoreFrame;
    }else if ([scoreStr floatValue]<=8) {
        score = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_score_four"]] autorelease];
        CGRect scoreFrame = score.frame;
        scoreFrame.size.width =  score.image.size.width * ([scoreStr floatValue])/10.0;
        score.frame = scoreFrame;
    }else if ([scoreStr floatValue]<=10) {
        score = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_score_five"]] autorelease];
        CGRect scoreFrame = score.frame;
        scoreFrame.size.width =  score.image.size.width * ([scoreStr floatValue])/10.0;
        score.frame = scoreFrame;
    }
    
    [scoreBack addSubview:score];
    score.contentMode = UIViewContentModeLeft;
    score.clipsToBounds = YES;
    [self.contentView addSubview:scoreHeaderView];
    
    UIImageView *shadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_tableviewheader_shadow"]] autorelease];
    [scoreHeaderView addSubview:shadow];
    CGRect shadowFrame = shadow.frame;
    shadowFrame.origin.y = 55;
    shadow.frame = shadowFrame;
}

-(void)addNewScore:(id)sender{
    
    WMAddZDYDafenViewController *zdydf = [[WMAddZDYDafenViewController alloc] init];
    zdydf.target = self;
    zdydf.finishAction = @selector(addNewScoreOK:);
    [self.navigationController pushViewController:zdydf animated:YES];
    [zdydf release];
    
}

-(void)addNewScoreOK:(NSString*)scoreName{
    
    NSArray *alreadyHave = [self.dataSource filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", scoreName]];
    
    if (![alreadyHave count]) {
        
        [self.dataSource addObject:[WMMScore modelFromDic:@{@"name":scoreName, @"score":@"?"}]];
        
        [showTableView reloadData];
        
        
        [[NKDataStore sharedDataStore] cacheArray:self.dataSource forCacheKey:WMCachePathScores];
        
    }
    
    
}

-(void)setupUI{
    
    self.titleLabel.text = @"给他初始打分";
}

-(void)rightButtonClick:(id)sender{
    

    
    
}




-(void)addWikiOK:(NKRequest*)request{
    
    
    [self goBack:nil];
    
}

-(void)addWikiFailed:(NKRequest*)request{
    
    
    ProgressErrorDefault;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;//[WMRateCell cellHeightForObject:[self.dataSource objectAtIndex:indexPath.row]];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"WMFeedCellIdentifier";
    
    WMRateCell *cell = (WMRateCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[WMRateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.delegate = self;
    }

    [cell showForObject:[self.dataSource objectAtIndex:indexPath.row]];
    [cell setIndex:indexPath.row];
    return cell;
}

-(void)deleteDataSourceItem:(int)index
{
    [self.dataSource removeObjectAtIndex:index];
    [self.showTableView reloadData];
}

-(void)reloadTotalScore
{
    [self updateHeaderView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



-(void)segmentControl:(NKSegmentControl*)control didChangeIndex:(NSInteger)index{
    
    switch (index) {
        case 0:{
            _notice.text = @"匿名发布，别人看不到妳是谁，但能看到这条内容";
        }
            break;
        case 1:{
            _notice.text = @"私密发布，只有妳的闺蜜才能查看这条内容";
        }
            break;
        case 2:{
            _notice.text = @"公开发布，所有人都能看到妳发布的内容和妳是谁";
        }
            break;
            
        default:
            break;
    }
    
    
    
}

@end
