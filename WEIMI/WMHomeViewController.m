//
//  WMHomeViewController.m
//  WEIMI
//
//  Created by King on 10/24/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMHomeViewController.h"

@interface WMHomeViewController ()

@end

@implementation WMHomeViewController

@synthesize avatarContainer;
@synthesize contentContainer;

@synthesize inviteViewController;
@synthesize miViewController;

@synthesize bookScrollView;


-(void)dealloc{
    
    [inviteViewController release];
    [miViewController release];
    
    [_followedMenViewController release];
    
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
    
    headBar.hidden = YES;
    
    self.bookScrollView = [[[UIScrollView alloc] initWithFrame:self.contentView.bounds] autorelease];
    [self.contentView addSubview:bookScrollView];
    self.bookScrollView.pagingEnabled = YES;
    
    UIImageView *book = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(NKMainHeight>460)?@"redbook5":@"redbook4"]];
    [bookScrollView addSubview:book];
    CGRect bookFrame = book.frame;
    book.frame = bookFrame;
    [book release];
    
    bookScrollView.contentSize = CGSizeMake(bookFrame.size.width, bookScrollView.frame.size.height);
    bookScrollView.showsVerticalScrollIndicator = NO;
    bookScrollView.showsHorizontalScrollIndicator = NO;

    self.contentContainer = [[[UIView alloc] initWithFrame:self.contentView.bounds] autorelease];
    [self.bookScrollView addSubview:contentContainer];
    
    self.dataSource = [NSMutableArray arrayWithObjects:[WMMUser me], nil];
    self.avatarContainer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 54)] autorelease];
    [self.contentView insertSubview:avatarContainer atIndex:10];
    //[self showFriends];
    [self listFriends];

    [self showContentWithUser:[WMMUser me]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Get Friends

-(void)tapped:(UITapGestureRecognizer*)gesture{
    
    NKKVOImageView *view = (NKKVOImageView *)[gesture view];

    WMMUser *user = [view modelObject];
    [self showContentWithUser:user];
}

-(void)showContentWithUser:(WMMUser*)user animated:(BOOL)animated{
    for (id subview in [avatarContainer subviews]) {
        
        if ([subview isKindOfClass:[NKKVOImageView class]] && [subview modelObject] == user) {
            
            [self avatarAnimate:subview animated:animated];
        }
        
    }
    
    
    if (self.miViewController.user == user) {
        return;
    }
    
    
    
    
    [[contentContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.miViewController = nil;
    self.inviteViewController = nil;
    self.miViewController = [[[WMMiViewController alloc] init] autorelease];
    miViewController.user = user;
    miViewController.delegate = self;
    miViewController.view.frame = self.view.bounds;
    miViewController.showTableView.frame = CGRectMake(0, 68, 320, NKContentHeight-68-22);
    //miViewController.showTableView.backgroundColor = [UIColor redColor];
    [contentContainer addSubview:miViewController.view];
    
    
    [self.followedMenViewController.view removeFromSuperview];
    self.followedMenViewController = nil;
    
    if ([user.relation isEqualToString:NKRelationFriend] || user==[WMMUser me]) {
        self.followedMenViewController = [[[WMFollowedMenViewController alloc] init] autorelease];
        _followedMenViewController.user = user;
        _followedMenViewController.view.frame = CGRectMake(330, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        _followedMenViewController.showTableView.frame =  CGRectMake(miViewController.showTableView.frame.origin.x, miViewController.showTableView.frame.origin.y, 267, miViewController.showTableView.frame.size.height) ;
        [bookScrollView addSubview:_followedMenViewController.view];
    }
    
    

    
}
-(void)showContentWithUser:(WMMUser*)user{
    
    [self showContentWithUser:user animated:YES];
       
    
}

-(void)showFriends{
    
    
    [[avatarContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat startX = 12;
    CGFloat avatarDistance = 12;
    CGFloat avatarWidth = 50;
    
    NKKVOImageView *avatar = nil;

    for (WMMUser *user in self.dataSource) {
        avatar = [[NKKVOImageView alloc] initWithFrame:CGRectMake(startX, avatarDistance, avatarWidth, avatarWidth)];
        [avatar bindValueOfModel:user forKeyPath:@"avatar"];
        [avatarContainer addSubview:avatar];
        [avatar release];
        
        if ([user.relation isEqualToString:NKRelationFollowing]) {
            avatar.placeHolderImage = [UIImage imageNamed:@"miyu_avatar_wating"];
        }
        
        avatar.target = self;
        avatar.singleTapped = @selector(tapped:);
        
        UIImageView *shadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"miyu_avatar_shadow_normal"]] autorelease];
        [avatar addSubview:shadow];
        avatar.clipsToBounds = NO;
        
        shadow.frame = CGRectMake(-2, -1, shadow.frame.size.width, shadow.frame.size.height);
        startX += avatarDistance+avatarWidth;
        
    }
    
    if ([self.dataSource count]<5) {
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(startX, avatarDistance, avatarWidth, avatarWidth)];
        [addButton setImage:[UIImage imageNamed:@"miyu_avatar_add"] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:@"miyu_avatar_add"] forState:UIControlStateHighlighted];
        [addButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
        [avatarContainer addSubview:addButton];
        [addButton release];
        
        UIImageView *shadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"miyu_avatar_shadow_normal"]] autorelease];
        [addButton addSubview:shadow];
        
        shadow.frame = CGRectMake(-2, -1, shadow.frame.size.width, shadow.frame.size.height);
    }

    
    [self showContentWithUser:[WMMUser me]];
}


-(void)avatarAnimate:(UIView*)view animated:(BOOL)animated{
    
    [UIView animateWithDuration:animated?0.2:0 animations:^{
        
        for (UIView *subview in [avatarContainer subviews]) {
            
            CGRect subviewFrame = subview.frame;
            
            subviewFrame.origin.y = (subview==view)?7:12;
            
            subview.frame = subviewFrame;
            
        }
        
    }];
    
}



-(void)addFriend:(id)sender{
    
    if (self.inviteViewController) {
        return;
    }
    
    
    [self avatarAnimate:sender animated:YES];
    
    
    [[contentContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.miViewController = nil;
    self.inviteViewController = nil;
    
    self.inviteViewController = [[[WMInviteMiViewController alloc] init] autorelease];
    inviteViewController.delegate = self;
    inviteViewController.view.frame = self.view.bounds;
    [contentContainer addSubview:inviteViewController.view];
    
    
    [self.followedMenViewController.view removeFromSuperview];
    self.followedMenViewController = nil;
    
}

-(void)inviteController:(WMInviteMiViewController*)controller didInviteUser:(WMMUser*)user{
    
    if ([self.dataSource containsObject:user]) {
      
    }
    else{
        [self.dataSource addObject:user];
        [self showFriends];

    }
    [self showContentWithUser:user animated:NO];
    
}

-(void)controller:(WMMiViewController*)controller didUnfollowUser:(WMMUser*)user{
    
    if ([self.dataSource containsObject:user]) {
        [self.dataSource removeObject:user];
    }
    else{
        
    }
    [self showFriends];
    [self showContentWithUser:[WMMUser me]];
    
}

-(void)listFriends{
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(listFriendsOK:) andFailedSelector:@selector(listFriendsFailed:)];
    [[WMUserService  sharedWMUserService] getRelatedUsersWithUID:nil andRequestDelegate:rd];
    
}

-(void)listFriendsOK:(NKRequest*)request{

    self.dataSource = [NSMutableArray arrayWithArray:request.results];
    [self.dataSource insertObject:[WMMUser me] atIndex:0];
    
    [self showFriends];
    
}

-(void)listFriendsFailed:(NKRequest*)request{
    
    
}

@end
