//
//  WMMiyuViewController.m
//  WEIMI
//
//  Created by King on 4/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMMiyuViewController.h"
#import "WMHelpView.h"
#import "WMAppDelegate.h"


@interface WMMiyuViewController ()
{
    WMHoneyView *honeyView;
}
@end

@implementation WMMiyuViewController

-(void)dealloc
{
    honeyView.delegate = nil;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    honeyView.isMiyuPage = YES;
    [honeyView relaodData:[WMMUser me]];
//    if (!honeyView.isAddView) {
//        [honeyView relaodData:[honeyView.dataSource objectAtIndex:honeyView.currentIndex]];
//    }
    
//    honeyView.delegate = self;
//    self.dataSource = honeyView.dataSource;
//    [self.contentView insertSubview:honeyView atIndex:0];
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"miyuhelp"]) {
        [self showHelpView1];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"miyuhelp"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    headBar.hidden = YES;
    
    honeyView = [WMHoneyView shareHoneyView:CGRectMake(0, 0, 320, 54)];
    honeyView.delegate = self;
    self.dataSource = honeyView.dataSource;
    [self.contentView insertSubview:honeyView atIndex:0];

    
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    
    UIImageView *sep = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 70, 320, 1)] autorelease];
    sep.backgroundColor = [UIColor colorWithHexString:@"#E9DDCA"];
    [self.contentView addSubview:sep];
    
    self.contentContainer = [[[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.origin.x, 71, self.contentView.frame.size.width, self.contentView.frame.size.height)] autorelease];
    self.contentContainer.backgroundColor = [UIColor colorWithHexString:@"#F5EEE3"];
    [self.contentView insertSubview:self.contentContainer atIndex:10];
    if (honeyView.isAddView) {
        [self addFriend];
    }else {
        WMMUser *user;
        if (honeyView.currentIndex > [honeyView.dataSource count]-1) {
            honeyView.currentIndex = 0;
        }
        if ([honeyView.dataSource count]) {
            user = [honeyView.dataSource objectAtIndex:honeyView.currentIndex];
        }else {
            user = [WMMUser me];
        }
        [self loadUserData:user];
        
        
    }
    
    
}

-(void)showHelpView2
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

-(void)showHelpView1
{
    WMHelpView *helpView = [[[WMHelpView alloc] initWithFrame:CGRectMake(0, 0, 320,SCREEN_HEIGHT)] autorelease];
    if (SCREEN_HEIGHT>480) {
        [helpView setImage:[UIImage imageNamed:@"shoucang_tip_hi"]];
    }else {
        [helpView setImage:[UIImage imageNamed:@"shoucang_tip"]];
    }
    
    helpView.helpDidRemoved = ^{
        [self showHelpView2];
    };
    
    WMAppDelegate *appDelegate = [WMAppDelegate shareAppDelegate];
    [[[appDelegate.window subviews] lastObject] addSubview:helpView];
}

-(void)avatarTapedAtIndex:(NSInteger)index
{
    WMMUser *user = [honeyView.dataSource objectAtIndex:index];
    
    NSDictionary *dic = [[WMNotificationCenter sharedNKNotificationCenter] feedDic];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        if ([[dic valueForKey:user.mid] boolValue]) {
            int numOfNotic = [[WMNotificationCenter sharedNKNotificationCenter] numOfNotics];
            if (numOfNotic>1) {
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:numOfNotic-1];
            }else {
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            }
        }
    }
    
    [self loadUserData:user];
}

-(void)loadUserData:(WMMUser *)user
{
    [[_contentContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.miViewController = nil;
    self.inviteViewController = nil;
    self.miViewController = [[[WMMiViewController alloc] init] autorelease];
    _miViewController.user = user;
    _miViewController.delegate = self;
    _miViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _miViewController.showTableView.frame = CGRectMake(0, 0, 320, NKContentHeight-62);
    //miViewController.showTableView.backgroundColor = [UIColor redColor];
    [_contentContainer addSubview:_miViewController.view];
}

-(void)addFriend
{
    if (_inviteViewController) {
        return;
    }
    
    [[_contentContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.miViewController = nil;
    self.inviteViewController = nil;
    
    self.inviteViewController = [[[WMInviteMiViewController alloc] init] autorelease];
    _inviteViewController.delegate = self;
    _inviteViewController.view.frame = self.view.bounds;
    [_contentContainer addSubview:_inviteViewController.view];
    
    
//    [self.followedMenViewController.view removeFromSuperview];
//    self.followedMenViewController = nil;
}

-(void)inviteController:(WMInviteMiViewController*)controller didInviteUser:(WMMUser*)user{
    
    if ([honeyView.dataSource containsObject:user]) {
        [honeyView relaodData:user];
    }
    else{
       
        honeyView.shouldReloadUserPage = YES;
         [honeyView relaodData:user];
    }
}

-(void)controller:(WMMiViewController *)controller didUnfollowUser:(WMMUser *)user
{
    if ([honeyView.dataSource containsObject:user]) {
        honeyView.shouldReloadUserPage = YES;
        [honeyView relaodData:[WMMUser me]];
        
        //[self loadUserData:[WMMUser me]];
    }
   
}

-(void)controller:(WMMiViewController *)controller didfollowUser:(WMMUser *)user
{
    if ([honeyView.dataSource containsObject:user]) {
        honeyView.shouldReloadUserPage = YES;
        [honeyView relaodData:user];
        //[self loadUserData:user];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
