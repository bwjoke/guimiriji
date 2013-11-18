//
//  WMFavorViewController.m
//  WEIMI
//
//  Created by King on 4/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMFavorViewController.h"
#import "WMHelpView.h"
#import "WMAppDelegate.h"

@interface WMFavorViewController ()
{
    WMHoneyView *honeyView;
    BOOL reloadByDelegate;
}
@end

@implementation WMFavorViewController


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
    honeyView.isMiyuPage = NO;
    [honeyView relaodData:[WMMUser me]];
//    if (!honeyView.isAddView) {
//        [honeyView relaodData:[honeyView.dataSource objectAtIndex:honeyView.currentIndex]];
//    }
//    honeyView = [WMHoneyView shareHoneyView:CGRectMake(0, 0, 320, 104)] ;
//    honeyView.delegate = self;
//    [self.contentView insertSubview:honeyView atIndex:0];
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"shoucanghelp"]) {
        [self showHelpView];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"shoucanghelp"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    headBar.hidden = YES;
    
    self.view.clipsToBounds = YES;
    
    UIImageView *book = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:(NKMainHeight>460)?@"redbook5":@"redbook4"]] autorelease];
    [self.contentView insertSubview:book atIndex:0];
    
    
    
    honeyView = [WMHoneyView shareHoneyView:CGRectMake(0, 0, 320, 54)];
    honeyView.delegate = self;
    self.dataSource = honeyView.dataSource;
    [self.contentView insertSubview:honeyView atIndex:0];
    
//    CGRect frame = self.showTableView.frame;
//    frame.origin.y = 60;
    
     [self.showTableView removeFromSuperview];
    
    
    
    if (honeyView.isAddView) {
        self.contentContainer = [[[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.origin.x, 55, self.contentView.frame.size.width, self.contentView.frame.size.height)] autorelease];
        [self addFriend];
    }else {
        self.contentContainer = [[[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.origin.x, 80, self.contentView.frame.size.width, self.contentView.frame.size.height)] autorelease];
        WMMUser *user;
        if (honeyView.dataSource) {
            user = [honeyView.dataSource objectAtIndex:honeyView.currentIndex];
        }else {
            user = [WMMUser me];
        }
        [self loadDataByUser:user];
        
    }
    
    [self.contentView insertSubview:self.contentContainer atIndex:10];
    
}

-(void)reloadFavPage
{
    WMMUser *user;
    if (honeyView.dataSource) {
        user = [honeyView.dataSource objectAtIndex:honeyView.currentIndex];
    }else {
        user = [WMMUser me];
    }
    [self loadDataByUser:user];
    reloadByDelegate = YES;
}

-(void)showHelpView
{
    WMHelpView *helpView = [[[WMHelpView alloc] initWithFrame:CGRectMake(0, 0, 320,SCREEN_HEIGHT)] autorelease];
    if (SCREEN_HEIGHT>480) {
        [helpView setImage:[UIImage imageNamed:@"shoucang_tip_hi"]];
    }else {
        [helpView setImage:[UIImage imageNamed:@"shoucang_tip"]];
    }
    WMAppDelegate *appDelegate = [WMAppDelegate shareAppDelegate];
    [[[appDelegate.window subviews] lastObject] addSubview:helpView];
}

-(void)avatarTapedAtIndex:(NSInteger)index
{
    WMMUser *user = [honeyView.dataSource objectAtIndex:index];
    [self loadDataByUser:user];
}

-(void)loadDataByUser:(WMMUser *)user
{
    
    [[_contentContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.followedMenViewController = nil;
    self.inviteViewController = nil;
    if ([user.relation isEqualToString:NKRelationFollowing] || [user.relation isEqualToString:NKRelationFollower]){
        // show Follow
        CGRect frame = self.contentContainer.frame;
        frame.origin.y = 55;
        self.contentContainer.frame = frame;
        self.miViewController = nil;
        self.inviteViewController = nil;
        self.miViewController = [[[WMMiViewController alloc] init] autorelease];
        _miViewController.user = user;
        _miViewController.delegate = self;
        _miViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        _miViewController.showTableView.frame = CGRectMake(0, 13, 320, NKContentHeight-68-22);
        //miViewController.showTableView.backgroundColor = [UIColor redColor];
        [_contentContainer addSubview:_miViewController.view];
        
    }else {
        CGRect frame = self.contentContainer.frame;
        frame.origin.y = 80;
        self.contentContainer.frame = frame;
        self.followedMenViewController = [[[WMFollowedMenViewController alloc] init] autorelease];
        _followedMenViewController.user = user;
        _followedMenViewController.hideProgress = reloadByDelegate;
        //_followedMenViewController.delegate = self;
        _followedMenViewController.view.frame = CGRectMake(0, -54, self.view.bounds.size.width, self.view.bounds.size.height);
        _followedMenViewController.showTableView.frame = CGRectMake(27, 13+54, 274, NKContentHeight-68-22-22);
        [_contentContainer addSubview:_followedMenViewController.view];
    
    }
    
    
}

-(void)addFriend
{
    if (_inviteViewController) {
        return;
    }
    CGRect frame = self.contentContainer.frame;
    frame.origin.y = 55;
    self.contentContainer.frame = frame;
    [[_contentContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.followedMenViewController = nil;
    self.inviteViewController = nil;
    
    self.inviteViewController = [[[WMInviteMiViewController alloc] init] autorelease];
    _inviteViewController.delegate = self;
    _inviteViewController.view.frame = self.view.bounds;
    [_contentContainer addSubview:_inviteViewController.view];
    
    
    [self.followedMenViewController.view removeFromSuperview];
    self.followedMenViewController = nil;
}

-(void)inviteController:(WMInviteMiViewController*)controller didInviteUser:(WMMUser*)user{
    
    if ([honeyView.dataSource containsObject:user]) {
        
    }
    else{
        honeyView.shouldReloadUserPage = YES;
        [honeyView relaodData:user];
        
    }
}

-(void)controller:(WMMiViewController *)controller didUnfollowUser:(WMMUser *)user
{
    if ([honeyView.dataSource containsObject:user]) {
        [honeyView relaodData:[WMMUser me]];
        [self loadDataByUser:[WMMUser me]];
    }
    
}

-(void)controller:(WMMiViewController *)controller didfollowUser:(WMMUser *)user
{
    if ([honeyView.dataSource containsObject:user]) {
        honeyView.shouldReloadUserPage = YES;
        [honeyView relaodData:user];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
