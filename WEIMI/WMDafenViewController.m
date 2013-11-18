//
//  WMDafenViewController.m
//  WEIMI
//
//  Created by King on 3/25/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMDafenViewController.h"
#import "WMManDetailViewController.h"

@interface WMDafenViewController ()

@end

@implementation WMDafenViewController

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
}

-(void)setupUI{
    
    
    self.titleLabel.text = @"给他打初始分";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if (![allScore count]) {
        ProgressFailedWith(@"请打个初始分");
        return;
    }

    NSString *rateString =  [allScore JSONString];
    NSString *tagString = nil;
    
    if (self.man.tags.count) {
        NSMutableArray *tags = [NSMutableArray arrayWithCapacity:self.man.tags.count];
        for (WMMTag *tag in self.man.tags) {
            [tags addObject:tag.name];
        }
        tagString = [tags JSONString];
    }

    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(postOK:) andFailedSelector:@selector(postFailed:)];
    
    // Birthday
    NSString *birthday = nil;
    
    if (self.man.birth) {
        NSDictionary *birth = self.man.birth;
        birthday = [NSString stringWithFormat:@"%d-%d", [birth[@"month"] integerValue], [birth[@"day"] integerValue]];
    }
    
    // University and universityID
    NSNumber *universityID = nil;
    NSString *universityName = nil;
    
    if (self.man.university) {
        NSDictionary *university = self.man.university;
        if (university[@"id"] != nil) {
            universityID = @([university[@"id"] integerValue]);
        }
        if (university[@"name"] != nil) {
            universityName = university[@"name"];
        }
    }
    
    ProgressLoading;
    
    self.nkRightButton.enabled = NO;
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"purview"]) {
        [[WMManService sharedWMManService]
         createManWithName:self.man.name
         avatar:UIImageJPEGRepresentation(self.man.avatar, 0.5)
         birthday:birthday
         tags:tagString
         weiboName:self.man.weiboName
         weiboId:self.man.flatformId
         flatform:self.man.flatform
         scores:rateString
         purview:1
         andRequestDelegate:rd
         universityID:universityID
         universityName:universityName];
    }else {
        [[WMManService sharedWMManService]
         createManWithName:self.man.name
         avatar:UIImageJPEGRepresentation(self.man.avatar, 0.5)
         birthday:birthday
         tags:tagString
         weiboName:self.man.weiboName
         weiboId:self.man.flatformId
         flatform:self.man.flatform
         scores:rateString
         purview:(self.seg.selectedIndex+1)%3
         andRequestDelegate:rd
         universityID:universityID
         universityName:universityName];
    }
    
}

-(void)postOK:(NKRequest*)request{
    
    
    WMMMan *man = [request.results lastObject];
    if (man.mid) {
        WMManDetailViewController *manDetail = [[WMManDetailViewController alloc] init];
        manDetail.man = man;
        if (_isFromUniversity) {
            manDetail.isFromUniversity = _isFromUniversity;
        }
        [NKNC pushViewController:manDetail animated:YES];
        //[WMManDetailViewController manDetailWithMan:man];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}
-(void)postFailed:(NKRequest*)request{
    
    
    
    ProgressErrorDefault;
    
    self.nkRightButton.enabled = YES;
    
}
@end
