//
//  WMTableViewController.m
//  WEIMI
//
//  Created by King on 2/25/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "MobClick.h"

@interface WMTableViewController ()

@end

@implementation WMTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(UIButton*)addBackButton{
    
    UIButton *button = [self styleButton];
    
    button.frame = CGRectMake(0, 0, 54, 43);
    [button setBackgroundImage:[[UIImage imageNamed:@"backbutton_normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0, 15)] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"backbutton_click.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0, 15)] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [button addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(nkLongPressed:)];
    [button addGestureRecognizer:longPress];
    [longPress release];
    
    
    return button;
    
}

-(UIButton*)addBackButtonWithTitle:(id)title
{
    UIButton *button = [self addBackButton];
    
    if ([title isKindOfClass:[NSString class]]) {
        //button = [self addBackButton];
        CGRect frame = button.frame;
        if ([(NSString *)title length]>4) {
            title = @"返回";
        }
        CGFloat width = [title sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(100, 16) lineBreakMode:NSLineBreakByCharWrapping].width+6;
        frame.size.width = frame.size.width>width?frame.size.width:width;
        button.frame = frame;
        [button setTitle:title forState:UIControlStateNormal];
    }else if ([title isKindOfClass:[NSArray class]]){
        //button = [self addBackButton];
        [button setImage:[title objectAtIndex:0] forState:UIControlStateNormal];
        [button setImage:[title objectAtIndex:1] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(320-55, 0, 55, 43);
    }
    
    return button;
}

-(UIButton*)styleButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normal = [[UIImage imageNamed:@"topButton_normal.png"] resizeImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    UIImage *highlight = [[UIImage imageNamed:@"topButton_click.png"] resizeImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    button.frame = CGRectMake(0, 0, normal.size.width, normal.size.height);
    [button setBackgroundImage:normal forState:UIControlStateNormal];
    [button setBackgroundImage:highlight forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [button setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.headBar addSubview:button];
    [button setImageEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
    return button;
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#428FB4"];
    self.titleLabel.shadowOffset = CGSizeMake(0, 0.5);
    
   [self.refreshHeaderView changeStyle:EGORefreshTableHeaderStyleZUO];
    
    
}

-(void)refreshDataOK:(NKRequest *)request{
    
    [super refreshDataOK:request];
    if (![request.hasMore boolValue]) {
        self.showTableView.tableFooterView = nil;
    }
}

-(void)addHeadShadow{
    
    UIImageView *shadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_tableheader_shadow"]] autorelease];
    [self.headBar addSubview:shadow];
    CGRect shadowFrame = shadow.frame;
    shadowFrame.origin.y = 44;
    shadow.frame = shadowFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    
}



@end
