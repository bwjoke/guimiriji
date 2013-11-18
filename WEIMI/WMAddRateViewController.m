//
//  WMAddRateViewController.m
//  WEIMI
//
//  Created by King on 11/23/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMAddRateViewController.h"
#import "WMPostViewController.h"

@interface WMAddRateViewController ()

@end

@implementation WMAddRateViewController


-(void)dealloc{
    
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
    [self getScore];
    
    
    
}

-(void)leftButtonClick:(id)sender{
    
    
    [self dismissModalViewControllerAnimated:YES];
}


-(void)setupUI{
    

    self.titleLabel.text = @"打个分";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getScore{
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getScoreOK:) andFailedSelector:@selector(getScoreFailed:)];
    
    [[WMManService sharedWMManService] getManScoreWithMID:self.man.mid andRequestDelegate:rd];
    
}

-(void)getScoreOK:(NKRequest*)request{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.dataSource];
    for (WMMScore *score in request.results) {
        BOOL has = NO;
        for (WMMScore *oldScore in self.dataSource) {
            if ([score.name isEqualToString:oldScore.name]) {
                oldScore.score = score.score;
                has = YES;
            }
        }
        if (!has) {
            [tmpArray insertObject:score atIndex:0];
        }
        
    }

    self.dataSource = tmpArray;
    [super updateHeaderView];
    [self.showTableView reloadData];
    
}
-(void)getScoreFailed:(NKRequest*)request{
    
    
    
}

-(void)rightButtonClick:(id)sender{
    
    NSMutableArray *allScore = [NSMutableArray array];
    
    
    
    for (WMMScore *score in self.dataSource) {
    
        if ([score.score isKindOfClass:[NSString class]] && [(NSString*)score.score isEqualToString:@"?"]) {
            
        }
        else{
            [allScore addObject:score.uploadDic];
        }
        
    }
    
    
    NSString *rateString =  [allScore JSONString];
    if ([rateString isEqualToString:@"[]"]) {
        ProgressFailedWith(@"请至少打一个分");
        return;
    }
    NSLog(@"%@", rateString);
    
//    NSString *rateString =  [self.dataSource JSONString];

    //[[NKRecordService sharedNKRecordService] addRecordWithTitle:nil content:nil description:rateString attTitle:nil attType:NKAttachmentTypeMan picture:nil parentID:self.record.mid type:NKRecordTypeFeed andRequestDelegate:rd];
    
    Progress(@"正在添加打分");
    
     NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(postOK:) andFailedSelector:@selector(postFailed:)];

    if (![[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"purview"] boolValue]) {
        [[WMManService sharedWMManService] scoreManWithMID:self.man.mid scores:rateString purview:2 andRequestDelegate:rd];
    }else {
        [[WMManService sharedWMManService] scoreManWithMID:self.man.mid scores:rateString purview:(self.seg.selectedIndex+1)%3 andRequestDelegate:rd];
    }
    
}

-(void)postOK:(NKRequest*)request{
    
    
    
    ProgressSuccess(@"添加成功");
    
    [self.father refreshData];
    [self goBack:nil];
    

    
}
-(void)postFailed:(NKRequest*)request{
    
    
    
    ProgressErrorDefault;
    
}

@end
