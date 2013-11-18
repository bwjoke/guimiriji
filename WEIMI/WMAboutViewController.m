//
//  WMAboutViewController.m
//  WEIMI
//
//  Created by steve on 13-4-9.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMAboutViewController.h"
#import "WMCustomLabel.h"
#import "WMLineLabel.h"
#import "WMAboutCell.h"
#import "WMPlainViewController.h"

#import "WMAppDelegate.h"

@interface WMAboutViewController ()

@end

@implementation WMAboutViewController

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
    
    self.titleLabel.text = @"关于薇蜜";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    
    [self addBackButton];
    [self addRightButton];
    
    //UIImageView *mazhi = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]] autorelease];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    //[self.contentView addSubview:mazhi];
    //mazhi.userInteractionEnabled = NO;
    //mazhi.frame = CGRectMake(0, 44, mazhi.frame.size.width, mazhi.frame.size.height);
    
    [self initAboutView];
}

- (void)addRightButton {
    [self addRightButtonWithTitle:@"用户协议"];
}

- (void)rightButtonClick:(id)sender {
    [self plainTerm];
}

-(void)initAboutView
{
    UIImageView *logoView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_logo"]] autorelease];
    logoView.frame = CGRectMake(124, 75, 81, 81);
    [self.view addSubview:logoView];

//    UIImageView *logo = [[[UIImageView alloc] initWithFrame:CGRectMake(125, 160, 10, 12)] autorelease];
//    logo.image = [UIImage imageNamed:@"logo"];
//    [self.view addSubview:logo];
    
//    UILabel *logoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(140, SCREEN_HEIGHT-110, 100, 12)] autorelease];
//    logoLabel.backgroundColor = [UIColor clearColor];
//    logoLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
//    logoLabel.font = [UIFont systemFontOfSize:10];
//    logoLabel.text = [NSString stringWithFormat:@"薇蜜 v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
//    //[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//    [self.view addSubview:logoLabel];
    
    NSArray *titleArray = [[[NSArray alloc] initWithObjects:@"薇蜜网页版：www.weimi.com",@"薇蜜QQ群：231628932",@"新浪微博：@薇蜜",@"腾讯微博：@weimicom", nil] autorelease];
    
    NSArray *labelX = [[[NSArray alloc] initWithObjects:@"77",@"82",@"90",@"90",nil] autorelease];
    
    for (int i=0; i<4; i++) {
        WMCustomLabel *label = [[[WMCustomLabel alloc] init] autorelease];
        label.frame = CGRectMake([[labelX objectAtIndex:i] integerValue], 170+i*20, 320, 14);
        label.text = [titleArray objectAtIndex:i];
        [self.view addSubview:label];
    }
    [self.showTableView removeFromSuperview];
    self.showTableView = [[[UITableView alloc] initWithFrame:CGRectMake(10, 268, 300, 123) style:UITableViewStyleGrouped] autorelease];
    self.showTableView.delegate = self;
    self.showTableView.dataSource = self;
    self.showTableView.backgroundColor = [UIColor clearColor];
    self.showTableView.backgroundView = nil;
    self.showTableView.scrollEnabled = NO;
    [self.view addSubview:self.showTableView];
    
    WMLineLabel *lineLebel = [[[WMLineLabel alloc] initWithFrame:CGRectMake(145, 407, 320, 16) fontSize:10] autorelease];
    lineLebel.text = @"用户协议";
    lineLebel.userInteractionEnabled = YES;
    [self.view addSubview:lineLebel];
    
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(plainTerm)] autorelease];
    [lineLebel addGestureRecognizer:tap];
    
    WMCustomLabel *copyRights = [[[WMCustomLabel alloc] initWithFrame:CGRectMake(0, 427, 320, 12)] autorelease];
    copyRights.textAlignment = UITextAlignmentCenter;
    copyRights.font = [UIFont systemFontOfSize:10.0];
    copyRights.text = @"@2013 weimi.com";
    [self.view addSubview:copyRights];
}

-(void)plainTerm
{
    WMPlainViewController *plainViewController = [[WMPlainViewController alloc] init];
    [NKNC pushViewController:plainViewController animated:YES];
    [plainViewController release];
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"WMAboutCellIdentifier";
    WMAboutCell *cell = (WMAboutCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[WMAboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier indexPath:indexPath] autorelease];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            //欢迎页
            [[WMSystemService sharedWMSystemService] showSlide];
            break;
        }
        case 1:{
            //检查新版本
            [self upgrage:nil];
            break;
        }
        case 2:{
            //给薇蜜打分
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_URL]];
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)upgrage:(id)sender{
    dispatch_queue_t concurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        
        NSString *versionString = [NKSystemInfo versionString];
        NSString *server = ZUOVersionProduct;
        
        if ([versionString rangeOfString:@"rc"].length) {
            server = ZUOVersionRC;
        }
        
        __block NSDictionary *versionDic = nil;
        dispatch_sync(concurrentQueue, ^{
            versionDic = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:server]];
            
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [[NKConfig sharedConfig] setStoreURL:[versionDic objectOrNilForKey:@"appURL"]];
            
            if ([versionString versionStringCompare:[versionDic objectOrNilForKey:@"version"]] == NSOrderedAscending) {
                
                [[NKConfig sharedConfig] setShowVersion:[NSString stringWithFormat:@"%@/%@", versionString, [versionDic objectOrNilForKey:@"version"]]];
                
                if ([[versionDic objectOrNilForKey:@"needAlert"] boolValue]) {
                    UIAlertView *updateView = [[UIAlertView alloc] initWithTitle:[versionDic objectOrNilForKey:@"title"]
                                                                         message:[versionDic objectOrNilForKey:@"description"]
                                                                        delegate:self
                                                               cancelButtonTitle:@"稍后提醒"
                                                               otherButtonTitles:@"现在更新", nil];
                    updateView.tag = 20130530;
                    [updateView show];
                    [updateView release];
                }
                
            }
            else{
                UIAlertView *updateView = [[UIAlertView alloc] initWithTitle:@"不需要更新"
                                                                     message:@"已经是最新版本了"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil, nil];
                [updateView show];
                [updateView release];
                [[NKConfig sharedConfig] setShowVersion:versionString];
            }
            
        });
    });
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 20130530 && buttonIndex!=alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NKConfig sharedConfig] storeURL]]];
    }
}

@end
