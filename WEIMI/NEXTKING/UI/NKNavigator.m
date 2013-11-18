//
//  NKNavigator.m
//  NEXTKING
//
//  Created by King on 10/24/12.
//  Copyright (c) 2012 NK.COM. All rights reserved.
//

#import "NKNavigator.h"
#import "NKUI.h"



@implementation NKNavigator


@synthesize tabs;
@synthesize tabSource;

-(void)dealloc{
    
    [tabs release];
    [tabSource release];
    [super dealloc];
}

static NKNavigator *_navigator = nil;

+(id)sharedNavigator{
    
    if (!_navigator) {
        _navigator = [[NKNavigator alloc] initWithFrame:CGRectMake(0, NKMainHeight-NKNavigatorHeight, 320, NKNavigatorHeight)];
    }
    return _navigator;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_bg"]];
        
    }
    return self;
}

-(void)addTabs:(NSArray*)tab{
    self.tabSource = tab;
    
    self.tabs = [NKSegmentControl segmentControlViewWithSegments:[tab objectAtIndex:0]
                                                     andDelegate:self];
    [self addSubview:tabs];
    tabs.frame = CGRectMake(0, 0, 320, NKNavigatorHeight);
    tabs.shouldAnimate = [[NKConfig sharedConfig] navigatorChangeAnimate];
    
}


-(void)showLoginOKView{
    
    [NKNC popToRootViewControllerAnimated:NO];
    
    [self.tabs selectSegment:0 shouldTellDelegate:NO];
    
    [[NKUI sharedNKUI] showViewControllerWithClass:[[tabSource objectAtIndex:1] objectAtIndex:0]];
    [[NKUI sharedNKUI] showNaviTab];
}


-(void)segmentControl:(NKSegmentControl*)control didChangeIndex:(NSInteger)index{
    
//    if (index==2) {
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"notiHide"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }else {
//        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"notiHide"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    [[NKUI sharedNKUI] showViewControllerWithClass:[[tabSource objectAtIndex:1] objectAtIndex:index] andIndex:index];
    
    
}

@end
