//
//  WMMenWikiPageViewController.h
//  WEIMI
//
//  Created by steve on 13-7-19.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "NKViewController.h"
#import "WMMenCell.h"
#import "WMManFeedCell.h"
#import "WMBaoliaoXiangqingViewController.h"
#import "WMManDetailViewController.h"
#import "WMCreateManViewController.h"
#import "WMWikiViewController.h"
#import "WMFavListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "WMChooseSchoolViewController.h"
#import "WMUniversityManListViewController.h"
#import "WMOauthViewController.h"

@interface WMMenWikiPageViewController : NKTableViewController<UITextFieldDelegate,WMBaoliaoXiangqingDelegate,WMManFeedCellDelegate,UIActionSheetDelegate,WMManDetailDelegate,CLLocationManagerDelegate, WMChooseSchoolViewDelegate>
{
    int pageNumber;
    UIView *headerView;
    UIButton *head;
    BOOL isSearch;
    WMMFeed *reportFeed;
    int getNearCount;
    NSArray *distanceArray;
    int nearType,distance;
    UIButton *distanceButton,*typeButton;
}

@property(nonatomic)BOOL isLast;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic,strong) NSString *category;
@property (nonatomic, strong) UITextField *searchFiled;
@property (nonatomic, strong) NSMutableArray *showDataSource;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) UITableView *showTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NKBadgeView *feedBadge;


@property (nonatomic) BOOL hasMore;
- (id)initWithPageNumber:(int)page;

-(void)reloadPage;
-(void)hideKeybord;
-(void)searchWithText:(NSString*)searchString;

@end
