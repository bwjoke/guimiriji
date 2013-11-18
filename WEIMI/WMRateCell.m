//
//  WMRateCell.m
//  WEIMI
//
//  Created by King on 11/21/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMRateCell.h"
#import "WMDataService.h"

@implementation WMRateCell
{
    int rateValue;
    UILabel *_titleLabel;
}
//@synthesize rateLabel;

-(void)dealloc{
    
    [_delegate release];
    [super dealloc];
}

+(CGFloat)cellHeightForObject:(id)object{
    
    
    
    return 82;
}

-(void)showForObject:(id)object{
    
    self.showedObject = object;
    
    WMMScore *score = object;
    
    self.nameLabel.text = score.name;
    CGRect frame = self.nameLabel.frame;
    CGFloat width = [score.name sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(320, 20) lineBreakMode:NSLineBreakByCharWrapping].width;
    frame.origin.x = (320.0-width)/2;
    frame.size.width = width;
    self.nameLabel.frame = frame;
    frame = _deleteButton.frame;
    frame.origin.x = self.nameLabel.frame.origin.x + width+8;
    _deleteButton.frame = frame;
    [_programmaticallyCreatedSlider setValue:[score.score integerValue]];
    [self setMinimumTrackImageForSlider:_programmaticallyCreatedSlider fristInit:YES];

    id numScore = [score valueForKey:@"score"];
    
    if ([[numScore description] isEqualToString:@"?"]) {
        _titleLabel.text = @"";
    } else {
        [self refreshTitleLabel:_programmaticallyCreatedSlider];
    }
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)] autorelease];
        [self.contentView insertSubview:self.nameLabel atIndex:0];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor colorWithHexString:@"#C6B193"];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        
        
        //[self addSubview:slider];
        
        //self.userInteractionEnabled = YES;
        
        _programmaticallyCreatedSlider = [[[TVCalibratedSlider alloc] initWithFrame:CGRectZero withStyle:TavicsaStyle] autorelease];
        
        //[_programmaticallyCreatedSlider setThumbImage:nil forState:UIControlStateHighlighted];
        TVCalibratedSliderRange range;
        range.maximumValue = 10;
        range.minimumValue = -1;
        [_programmaticallyCreatedSlider setRange:range];
        [self.contentView insertSubview:_programmaticallyCreatedSlider atIndex:1];
        [_programmaticallyCreatedSlider setTextColorForHighlightedState:[UIColor whiteColor]];
        [_programmaticallyCreatedSlider setMarkerImageOffsetFromSlider:10];
        [_programmaticallyCreatedSlider setMarkerValueOffsetFromSlider:10];
        [_programmaticallyCreatedSlider setDelegate:self] ;
        //[_programmaticallyCreatedSlider setBackgroundColor:[UIColor redColor]];
        
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 24, 12, 12)];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_delete_dafen"] forState:UIControlStateNormal];
        _deleteButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteItem:)] autorelease];
        [_deleteButton addGestureRecognizer:tap];
        [self.contentView insertSubview:_deleteButton aboveSubview:_programmaticallyCreatedSlider];
        [_deleteButton release];
        
        _titleLabel = [[[UILabel alloc] init] autorelease];
        _titleLabel.bounds = CGRectMake(0.0f, 0.0f, 50.0f, 30.0f);
        _titleLabel.center = CGPointMake(_programmaticallyCreatedSlider.value * 23.55f + 55.0f, 69.0f);
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#a6937c"];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
    
    }
    return self;
}

- (void)valueChanged:(TVCalibratedSlider *)sender {
    [self.showedObject setValue:[NSNumber numberWithInteger:[sender value]] forKey:@"score"];
    [self setMinimumTrackImageForSlider:sender fristInit:NO];
    [_delegate reloadTotalScore];
    
    [self refreshTitleLabel:sender];
}

- (void)refreshTitleLabel:(TVCalibratedSlider *)sender {
    [self setMinimumTrackImageForSlider:_programmaticallyCreatedSlider fristInit:NO];
    _titleLabel.center = CGPointMake(sender.value * 23.55f + 55.0f, 69.0f);
    _titleLabel.text = sender.valueString;
}

-(void)setMinimumTrackImageForSlider:(TVCalibratedSlider *)sender fristInit:(BOOL)fristInit
{
    if (fristInit && [sender value] == 0) {
        [sender setMinimumTrackImage:@"slider_gray_1.png" withCapInsets:UIEdgeInsetsMake(0, 20, 0, 0) forState:UIControlStateNormal];
        [sender setFristInit:fristInit];
        return;
    }
    if ([sender value]<2) {
        [sender setMinimumTrackImage:@"slider_blue_3.png" withCapInsets:UIEdgeInsetsMake(0, 20, 0, 0) forState:UIControlStateNormal];
    }else if ([sender value]<4){
        [sender setMinimumTrackImage:@"slider_blue_2.png" withCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) forState:UIControlStateNormal];
    }
    else if ([sender value]<6){
        [sender setMinimumTrackImage:@"slider_blue_4.png" withCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) forState:UIControlStateNormal];
    }
    else if ([sender value]<8){
        [sender setMinimumTrackImage:@"slider_blue_5.png" withCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) forState:UIControlStateNormal];
    }
    else if ([sender value]<=10){
        [sender setMinimumTrackImage:@"slider_blue_6.png" withCapInsets:UIEdgeInsetsMake(0, 22, 0, 24) forState:UIControlStateNormal];
    }
}


-(void)deleteItem:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除这个打分项吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [_delegate deleteDataSourceItem:_index];
    }
}

@end
