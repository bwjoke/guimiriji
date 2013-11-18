//
//  WMMyTopicViewController.m
//  WEIMI
//
//  Created by Tang Tianyong on 8/21/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMMyTopicViewController.h"
#import "WMDiscussCell.h"
#import "WMDiscussDetailViewController.h"

@interface WMMyTopicViewController ()

@end

@implementation WMMyTopicViewController

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
    
    [self.headBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] atIndex:0];
    [self addHeadShadow];
    self.titleLabel.text = @"我发布的";
    [self addBackButton];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    self.showTableView.frame = CGRectMake(0, 44, 320, NKMainHeight-44);
    
    [self refreshData];
}

- (void)refreshData {
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    
    [[WMTopicService sharedWMTopicService] getMyTopicByOffset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
}

-(void)getMoreData{
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getMoreDataOK:) andFailedSelector:@selector(getMoreDataFailed:)];
    
    [[WMTopicService sharedWMTopicService] getMyTopicByOffset:self.dataSource.count size:DefaultOneRequestSize andRequestDelegate:rd];
}

-(void)getMoreDataOK:(NKRequest*)request{
    [super getMoreDataOK:request];
}

- (void)getMoreDataFailed:(NKRequest *)request {
    [super refreshDataFailed:request];
}

- (void)refreshDataOK:(NKRequest *)request {
    [super refreshDataOK:request];
}

- (void)refreshDataFailed:(NKRequest *)request {
    [super refreshDataFailed:request];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WMDiscussCell cellHeightForObject:[self.dataSource objectAtIndex:indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident = @"Cell";
    
    WMDiscussCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (!cell) {
        cell = [[WMDiscussCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
    }
    
    WMMTopic *topic = self.dataSource[indexPath.row];
    
    [cell showForObject:topic];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WMMTopic *topic = [self.dataSource objectAtIndex:indexPath.row];
    WMDiscussDetailViewController *vc = [[WMDiscussDetailViewController alloc] init];
    vc.topic_id = topic.mid;
    [NKNC pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
