//
//  WMSystemService.m
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMSystemService.h"
#import "WMMirror.h"


#import "NKSlidesView.h"

@implementation WMSystemService


-(void)dealloc{
    [super dealloc];
}

$singleService(WMSystemService, @"system");

static NSString *const ZUOAPISystemBindDevice = @"/bind_device";
-(NKRequest*)bindDeviceWithUDID:(NSString*)udid andRequestDelegate:(NKRequestDelegate*)rd{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], ZUOAPISystemBindDevice];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[NKMActionResult class] resultType:NKResultTypeSingleObject andResultKey:@""];
    [newRequest addPostValue:udid forKey:@"udid"];
    [self addRequest:newRequest];
    
    return newRequest;
    
}

static NSString *const WMAPINoDisturb = @"/no_disturb";
-(NKRequest*)setNoDisturb:(NSString*)switchOption andRequestDelegate:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], WMAPINoDisturb];
    
    NKRequest *newRequest = [NKRequest postRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    [newRequest addPostValue:switchOption forKey:@"switch"];
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const WMAPIGetQuestionList = @"/list";
-(NKRequest*)getQuestionList:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?key=ask",[self serviceBaseURL], WMAPIGetQuestionList];
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    [self addRequest:newRequest];
    
    return newRequest;
}

-(NKRequest*)getHotTagList:(NKRequestDelegate*)rd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?key=hotag",[self serviceBaseURL], WMAPIGetQuestionList];
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const ZUOAPISystemFunction = @"/function";
- (NKRequest *)getFunction:(NKRequestDelegate *)rd {
    NSString *urlString = [NSString stringWithFormat:@"%@%@?ver=1.7.2",[self serviceBaseURL], ZUOAPISystemFunction];
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const ZUOAPISystemSchoolList = @"/university_list";
- (NKRequest *)getSchoolList:(NKRequestDelegate *)rd {
    NSString *urlString = [NSString stringWithFormat:@"%@%@?ver=1.6",[self serviceBaseURL], ZUOAPISystemSchoolList];
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:nil resultType:NKResultTypeOrigin andResultKey:@""];
    
    [self addRequest:newRequest];
    
    return newRequest;
}

static NSString *const ZUOAPISystemMirrorList = @"/witch_mirror";
-(NKRequest*)getMirrorList:(NKRequestDelegate*)rd
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self serviceBaseURL], ZUOAPISystemMirrorList];
    
    NKRequest *newRequest = [NKRequest getRequestWithURL:[NSURL URLWithString:urlString] requestDelegate:rd resultClass:[WMMirror class] resultType:NKResultTypeResultSets andResultKey:@""];
    
    [self addRequest:newRequest];
    
    return newRequest;
}

-(void)showSlide{
    
    NKSlidesView *slidesView = nil;
    if ([UIScreen mainScreen].bounds.size.height>480) {
        slidesView = [NKSlidesView slidesViewWithImages:[NSArray arrayWithObjects:[[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slide_1_tall@2x" ofType:@"png"]] autorelease], [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slide_2_tall@2x" ofType:@"png"]] autorelease], [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slide_3_tall@2x" ofType:@"png"]] autorelease], nil]];
        
        
    }
    else{
        slidesView = [NKSlidesView slidesViewWithImages:[NSArray arrayWithObjects:[[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slide_1@2x" ofType:@"png"]] autorelease], [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slide_2@2x" ofType:@"png"]] autorelease], [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slide_3@2x" ofType:@"png"]] autorelease], nil]];
    }

    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [doneButton setImage:[UIImage imageNamed:@"slide_button_normal"] forState:UIControlStateNormal];
    [doneButton setImage:[UIImage imageNamed:@"slide_button_click"] forState:UIControlStateHighlighted];
    [doneButton addTarget:slidesView action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
    doneButton.center = CGPointMake(slidesView.slideScrollView.contentSize.width-160, slidesView.frame.size.height/2);
    [slidesView.slideScrollView addSubview:doneButton];
    [doneButton release];
    
    
    
}

@end