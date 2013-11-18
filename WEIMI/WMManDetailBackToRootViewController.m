//
//  WMManDetailBackToRootViewController.m
//  WEIMI
//
//  Created by ZUO on 6/14/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMManDetailBackToRootViewController.h"

@interface WMManDetailBackToRootViewController ()

@end

@implementation WMManDetailBackToRootViewController

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
}

-(void)goBack:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
