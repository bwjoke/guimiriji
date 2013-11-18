//
//  WMManPhotosViewController.m
//  WEIMI
//
//  Created by King on 4/9/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMManPhotosViewController.h"
#import "WMAddBaoliaoViewController.h"

@interface WMManPhotosViewController ()

@end

@implementation WMManPhotosViewController

-(void)dealloc{
    
    [_man release];
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

-(void)rightButtonClick:(id)sender{
    
    WMAddBaoliaoViewController *addBaoliao = [[WMAddBaoliaoViewController alloc] init];
    addBaoliao.man = self.man;
    [NKNC pushViewController:addBaoliao animated:YES];
    [addBaoliao release];
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
    
    [self.headBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_head_back"]] autorelease] atIndex:0];
    [self addHeadShadow];
    
    [self addBackButton];
    [self addRightButtonWithTitle:@"添加"];
    showTableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 9)] autorelease];
    
    self.titleLabel.text = self.man.name;
    
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshData{
    
    NKRequestDelegate *rd = [NKRequestDelegate refreshRequestDelegateWithTarget:self];
    
    [[WMManService sharedWMManService] getManPhotosWithMID:self.man.mid offset:0 size:DefaultOneRequestSize andRequestDelegate:rd];
    
}

-(void)goBack:(id)sender
{
    [NKNC popViewControllerAnimated:YES];
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 105;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource count]/3+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"WMFeedCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat startX = 8;
        CGFloat startY = 0;
        
        UIImageView *imageBack = nil;
        NKKVOImageView *imageView = nil;

        for (int i=0; i<3; i++) {
            
            imageBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"manphoto_back"]] autorelease];
            [cell.contentView addSubview:imageBack];
            imageBack.frame = CGRectMake(startX, startY, imageBack.frame.size.width, imageBack.frame.size.height);
            imageBack.userInteractionEnabled = YES;
            
            imageView = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(3.5, 3, 90, 90)] autorelease];
            [imageBack addSubview:imageView];
            imageView.target = self;
            imageView.singleTapped = @selector(preView:);
            
            startX += 104;
        }
    }

    for (UIView *view in cell.contentView.subviews) {
        view.hidden = YES;
    }
    
    
    for (int i=0; i<MIN(3, self.dataSource.count-3*indexPath.row); i++) {
        
        
        UIImageView *imageBack = [cell.contentView.subviews objectAtIndex:i];
        imageBack.hidden = NO;
        
        NKKVOImageView *imageView = [imageBack.subviews lastObject];
        [imageView bindValueOfModel:[self.dataSource objectAtIndex:3*indexPath.row+i] forKeyPath:@"thumbnail"];
        
    }
    
    
    return cell;
}


-(void)preView:(UIGestureRecognizer*)gesture{

    
    NKKVOImageView *imageView = (NKKVOImageView *)[gesture view];
    
    NKPictureViewer *viewer = [NKPictureViewer pictureViewerForView:imageView];
    [viewer showPictureForObject:imageView.modelObject andKeyPath:@"picture"];
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




@end
