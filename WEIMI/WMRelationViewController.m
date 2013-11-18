//
//  WMRelationViewController.m
//  WEIMI
//
//  Created by steve on 13-7-31.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMRelationViewController.h"
#import "WMCustomLabel.h"
#import "WMMMan.h"
#import "WMManRelationCell.h"

@interface WMRelationViewController ()
{
    NSMutableArray *nameList;
    NSString *selectYear;
    WMManGrilFriend *selectGril;
    BOOL hasUpdateManGrils;
}
@end

@implementation WMRelationViewController

#define INPUTALERT 130802001
#define NONAMEALERT 130802002
#define VOTEALERT 130802003

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
    [self addBackButtonWithTitle:_man.name];
    [self.headBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] atIndex:0];
    [self addHeadShadow];
    
    self.titleLabel.text = [NSString stringWithFormat:@"他的交往对象(%@)",[_man.gfCount stringValue]];
    
    showTableView.frame = CGRectMake(0, 44, 320, NKMainHeight-44);
    showTableView.backgroundColor = [UIColor whiteColor];
    
    nameList = [NSMutableArray array];
    
    [self refreshData];
}

-(void)refreshData
{
    ProgressLoading;
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getGrilListOK:) andFailedSelector:@selector(getGrilListFailed:)];
    
    [[WMManService sharedWMManService] getMenGrilFriends:_man.mid andRequestDelegate:rd];
}

-(void)getGrilListOK:(NKRequest *)request
{
    ProgressHide;
    [self doneLoadingTableViewData];
    [self.dataSource removeAllObjects];
    [nameList removeAllObjects];
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY"];
    date = [formatter stringFromDate:[NSDate date]];
    int dateInt = [date intValue];
    for (int i=0; i<(dateInt-1999); i++) {
        int year = dateInt-i;
        NSString *yearStr = [NSString stringWithFormat:@"%d",year];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSMutableArray arrayWithObjects:nil] forKey:yearStr];
        [self.dataSource addObject:dic];
    }
     NSDictionary *tmpDic = [NSDictionary dictionaryWithObject:[NSMutableArray arrayWithObjects:nil] forKey:@"now"];
    [self.dataSource insertObject:tmpDic atIndex:0];
    NSDictionary *dic = [[request.originDic valueForKey:@"data"] valueForKey:@"values"];
    if (![dic isKindOfClass:[NSDictionary class]]) {
        [self.showTableView reloadData];
        self.titleLabel.text = [NSString stringWithFormat:@"他的交往对象(%d)",[nameList count]];
        return;
    }
    for (NSString *key in dic.allKeys) {
        for (int i=0; i<[self.dataSource count]; i++) {
            NSDictionary *dataDic = [self.dataSource objectAtIndex:i];
            if ([key isEqualToString:[dataDic.allKeys lastObject]]) {
                NSArray *array = [dic valueForKey:key];
                NSMutableArray *grilArray = [[NSMutableArray alloc] init];
                for (int j=0; j<[array count]; j++) {
                    WMManGrilFriend *gril = [WMManGrilFriend modelFromDic:[array objectAtIndex:j]];
                    [grilArray addObject:gril];
                    NSUInteger index = [nameList indexOfObject:gril.name];
                    if (index == NSNotFound) {
                        [nameList addObject:gril.name];
                    }
                }
                NSDictionary *sourceDic = [NSDictionary dictionaryWithObject:grilArray forKey:key];
                [self.dataSource replaceObjectAtIndex:i withObject:sourceDic];
                
            }
        }
    }
    [self.showTableView reloadData];
    self.titleLabel.text = [NSString stringWithFormat:@"他的交往对象(%d)",[nameList count]];
    
}

-(void)getGrilListFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}

#pragma mark TableView

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [[[self.dataSource objectAtIndex:section] allKeys] lastObject];
    NSArray *array = [[self.dataSource objectAtIndex:section] valueForKey:key];
    return [array count]+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString *key = [[[self.dataSource objectAtIndex:section] allKeys] lastObject];
    NSArray *array = [[self.dataSource objectAtIndex:section] valueForKey:key];
    
    if (row < array.count) {
        return [WMManRelationCell cellHeightForObject:array[row]];
    }
    
    return 55.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#A6937C"];
    WMCustomLabel *stateLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(0, 7, 320, 15) font:[UIFont boldSystemFontOfSize:14] textColor:[UIColor whiteColor]];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    if (section == 0) {
        stateLabel.text = @"现在正在交往...";
    }else {
        stateLabel.text = [NSString stringWithFormat:@"%@年交往过...",[[[self.dataSource objectAtIndex:section] allKeys] lastObject]];
    }
    [headerView addSubview:stateLabel];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"WMManRelationCellIdentifier";
    
    WMManRelationCell *cell = (WMManRelationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WMManRelationCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }
    NSString *key = [[[self.dataSource objectAtIndex:indexPath.section] allKeys] lastObject];
    NSArray *array = [[self.dataSource objectAtIndex:indexPath.section] valueForKey:key];
    if (indexPath.row<[array count]) {
        [cell showForObject:[array objectAtIndex:indexPath.row]];
    }else {
        [cell showForObject:nil];
    }
    
    return cell;
}


-(void)doneButtonClickWithPopView:(WMPopView *)popView
{
    if (popView.tag == INPUTALERT) {
        NSString *name,*weibo,*desc;
        for (UIView *view in popView.contentView.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField *filed = (UITextField *)view;
                if (view.tag == 0) {
                    name = [[filed text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
                if (view.tag == 1) {
                    weibo = [[filed text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
                if (view.tag == 2) {
                    desc = [[filed text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
                
            }
        }
        if ([name length]==0) {
            ProgressFailedWith(@"姓名不可以为空哦~");
            return;
        }
        NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(createOK:) andFailedSelector:@selector(createFailed:)];
        [[WMManService sharedWMManService] createGrilFriend:_man.mid name:name year:selectYear weibo:weibo desc:desc andRequestDelegate:rd];
        [popView cancle:nil];
    }else if (popView.tag == VOTEALERT) {
        NSString *weibo,*desc;
        
        for (UIView *view in popView.contentView.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField *filed = (UITextField *)view;
                if (view.tag == 1) {
                    weibo = [[filed text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
                if (view.tag == 2) {
                    desc = [[filed text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
                
            }
        }
        [popView cancle:nil];
        ProgressLoading;
        NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(voteOK:) andFailedSelector:@selector(voteFailed:)];
        [[WMManService sharedWMManService] voteGrilFriend:selectGril.mid weibo:weibo desc:desc  andRequestDelegate:rd];
        
    }
    
    
}



#pragma mark function
-(void)goBack:(id)sender
{
    if (hasUpdateManGrils) {
        [_delegate shouldGetManInfo];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createOK:(NKRequest *)request
{
    ProgressHide;
    hasUpdateManGrils = YES;
    [self refreshData];
}

-(void)createFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = [[[self.dataSource objectAtIndex:indexPath.section] allKeys] lastObject];
    selectYear = key;
    NSArray *array = [[self.dataSource objectAtIndex:indexPath.section] valueForKey:key];
    if (indexPath.row>=[array count]) {
        WMPopView *popView = [[WMPopView alloc] initWithTitle:@"添加他的交往对象姓名" numOfTextFiled:3];
        popView.tag = INPUTALERT;
        popView.delegate = self;
        UITextField* nameLabel = [[UITextField alloc] init];
        nameLabel.tag = 0;
        UITextField* weiboLabel = [[UITextField alloc] init];
        weiboLabel.tag = 1;
        UITextField* descLabel = [[UITextField alloc] init];
        descLabel.tag = 2;
        
        nameLabel.borderStyle = UITextBorderStyleRoundedRect;
        weiboLabel.borderStyle = UITextBorderStyleRoundedRect;
        descLabel.borderStyle = UITextBorderStyleRoundedRect;
        
        nameLabel.frame = CGRectMake( 10, 0,260, 30 );
        weiboLabel.frame = CGRectMake( 10, 35,280 -20, 30 );
        descLabel.frame = CGRectMake( 10, 70,280 -20, 30 );
        
        nameLabel.placeholder = @"她的姓名(必填)";
        weiboLabel.placeholder = @"她的微博昵称(可选)";
        descLabel.placeholder = @"理由(可选)";
        
        [popView.contentView addSubview:weiboLabel];
        [popView.contentView addSubview:nameLabel];
        [popView.contentView addSubview:descLabel];
        
        [nameLabel becomeFirstResponder];
        [popView showInView:self.view];
    }else {
        WMManGrilFriend *gril = [array objectAtIndex:indexPath.row];
        [self voteGrilFriend:gril];
//        if ([gril.iSupport boolValue]) {
//            gril.iSupport = [NSNumber numberWithBool:NO];
//            gril.count = [NSNumber numberWithInt:[gril.count intValue]-1];
//            
//            if ([gril.count intValue] == 0) {
//                [[[self.dataSource objectAtIndex:indexPath.section] valueForKey:key] removeObjectAtIndex:indexPath.row];
//            }
//        }else {
//            gril.iSupport = [NSNumber numberWithBool:YES];
//            gril.count = [NSNumber numberWithInt:[gril.count intValue]+1];
//            [self updateDataSource:indexPath gril:gril];
//            [self voteGrilFriend:gril.mid];
//        }
        
    }
    [self.showTableView reloadData];
}

-(void)voteGrilFriend:(WMManGrilFriend *)gril
{
    if ([gril.isSupport boolValue]) {
        ProgressLoading;
        NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(voteOK:) andFailedSelector:@selector(voteFailed:)];
        [[WMManService sharedWMManService] voteGrilFriend:gril.mid weibo:@"" desc:@""  andRequestDelegate:rd];
    }else {
        selectGril = gril;
        
        WMPopView *popView = [[WMPopView alloc] initWithTitle:@"他们有交往!+1" numOfTextFiled:3];
        popView.tag = VOTEALERT;
        popView.delegate = self;
        UITextField* nameLabel = [[UITextField alloc] init];
        nameLabel.text = selectGril.name;
        nameLabel.enabled = NO;
        nameLabel.tag = 0;
        UITextField* weiboLabel = [[UITextField alloc] init];
        weiboLabel.tag = 1;
        UITextField* descLabel = [[UITextField alloc] init];
        descLabel.tag = 2;
        
        //nameLabel.borderStyle = UITextBorderStyleRoundedRect;
        weiboLabel.borderStyle = UITextBorderStyleRoundedRect;
        descLabel.borderStyle = UITextBorderStyleRoundedRect;
        
        nameLabel.frame = CGRectMake( 10, 0,260, 30 );
        weiboLabel.frame = CGRectMake( 10, 35,280 -20, 30 );
        descLabel.frame = CGRectMake( 10, 70,280 -20, 30 );
        
        nameLabel.placeholder = @"她的姓名(必填)";
        weiboLabel.placeholder = @"她的微博昵称(可选)";
        descLabel.placeholder = @"理由(可选)";
        
        [popView.contentView addSubview:weiboLabel];
        [popView.contentView addSubview:nameLabel];
        [popView.contentView addSubview:descLabel];
        
        [weiboLabel becomeFirstResponder];
        [popView showInView:self.view];
    }
}

-(void)voteOK:(NKRequest *)request
{
    ProgressHide;
    hasUpdateManGrils = YES;
    [self refreshData];
}

-(void)voteFailed:(NKRequest *)request
{
    ProgressErrorDefault;
}


-(void)updateDataSource:(NSIndexPath *)indexPath gril:(WMManGrilFriend *)gril
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
