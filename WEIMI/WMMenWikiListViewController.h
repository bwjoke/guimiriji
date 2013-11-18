//
//  WMMenWikiListViewController.h
//  WEIMI
//
//  Created by steve on 13-7-19.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//
@protocol WMMenWikiListDelegate <NSObject>

@optional
-(void)didScrollViewStartScrollTo:(int)scrollToPage;

@end

#import <UIKit/UIKit.h>

@interface WMMenWikiListViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    NSMutableArray *viewControllers;
    int kNumberOfPages;
    int currentPage;
    CGFloat position;
}
@property(nonatomic,strong)NSMutableArray *viewControllers;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic)int kNumberOfPages;
@property(nonatomic)int currentPage;
@property(nonatomic,unsafe_unretained)id<WMMenWikiListDelegate>delegate;

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
-(void)scrolTo:(int)page;
@end
