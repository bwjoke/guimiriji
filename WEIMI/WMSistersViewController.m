//
//  WMSistersViewController.m
//  WEIMI
//
//  Created by steve on 13-6-20.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMSistersViewController.h"
#import "WMHelpView.h"
#import "WMAppDelegate.h"

@interface WMSistersViewController ()
{
    WMHoneyView *honeyView;
}
@end

@implementation WMSistersViewController

-(void)dealloc
{
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

-(void)viewWillAppear:(BOOL)animated
{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"miyuhelp"]) {
        [self showHelpView];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"miyuhelp"];
    }
}

-(void)showHelpView
{
    WMHelpView *helpView = [[[WMHelpView alloc] initWithFrame:CGRectMake(0, 0, 320,SCREEN_HEIGHT)] autorelease];
    if (SCREEN_HEIGHT>480) {
        [helpView setImage:[UIImage imageNamed:@"miyu_tip_hi"]];
    }else {
        [helpView setImage:[UIImage imageNamed:@"miyu_tip"]];
    }
    WMAppDelegate *appDelegate = [WMAppDelegate shareAppDelegate];
    [[[appDelegate.window subviews] lastObject] addSubview:helpView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    headBar.hidden = YES;
    
    honeyView = [WMHoneyView shareHoneyView:CGRectMake(0, 0, 320, 54)];
    honeyView.delegate = self;
    self.dataSource = honeyView.dataSource;
    [self.contentView insertSubview:honeyView atIndex:0];
    
    
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    
    self.contentContainer = [[[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.origin.x, 54, self.contentView.frame.size.width, self.contentView.frame.size.height)] autorelease];
    self.contentContainer.backgroundColor = [UIColor colorWithHexString:@"#F5EEE3"];
    [self.contentView insertSubview:self.contentContainer atIndex:10];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
