//
//  ZUOCommentCell.m
//  ZUO
//
//  Created by King on 9/28/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "ZUOCommentCell.h"





@implementation ZUOCommentCell

@synthesize avatar;
@synthesize name;
@synthesize time;
@synthesize content;

@synthesize contentEmojo;

-(void)dealloc{
    
    
    
    [super dealloc];
}

+(CGFloat)cellHeightForObject:(id)object{
    
    
    NKMRecord *message = (NKMRecord *)object;
    
//    CGFloat height = [message.content sizeWithFont:contentFont constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    LWVMRichTextContent *postContent = [[[LWVMRichTextContent alloc] initWithContent:message.content
                                                                            withType:LWVMRichTextShowContentTypeComment] autorelease];
    
    [postContent resetNodeFrameWithOriginX:0 withOriginY:0];
    
    CGFloat height = postContent.height;
    
    return MAX(52, height+28+9);
    
}


-(void)showForObject:(id)object{
    
    [super showForObject:object];
    NKMRecord *message = (NKMRecord *)object;
    
    [avatar bindValueOfModel:message.sender forKeyPath:@"avatar"];
    name.text = message.sender.name;
    
    time.text = [NKDateUtil intervalSinceNowWithDate:message.createTime];
    
//    CGRect contentFrame = content.frame;
//    contentFrame.size.height = [message.content sizeWithFont:contentFont constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
//    content.frame = contentFrame;
//    
//    content.text = message.content;
    

    bottomLine.frame = CGRectMake(0, [ZUOCommentCell cellHeightForObject:object]-1, 320, 1);
    
    LWVMRichTextContent *postContent = [[[LWVMRichTextContent alloc] initWithContent:message.content
                                                                            withType:LWVMRichTextShowContentTypeComment] autorelease];
    
    [postContent resetNodeFrameWithOriginX:0 withOriginY:0];
    
    CGRect contentsFrame = contentEmojo.frame;
    contentsFrame.size.height = postContent.height;
    contentEmojo.frame = contentsFrame;
    contentEmojo.richTextContent = postContent;
    [contentEmojo setNeedsDisplay];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#FFF4F4"];
        
        CGRect bottomLineFrame = bottomLine.frame;
        bottomLineFrame.origin.y = 0;
        bottomLine.frame = bottomLineFrame;
        bottomLine.image = nil;
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"#f1ece4"];
        [self.contentView addSubview:bottomLine];
        
        UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"miyu_avatar_shadow"]];
        shadow.frame = CGRectMake(12, 7, 36, 36);
        [self.contentView addSubview:shadow];
        [shadow release];
        
        self.avatar = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(12, 7, 36, 36)] autorelease];
        [self.contentView insertSubview:self.avatar belowSubview:shadow];
        
        
        
        self.name = [[[UILabel alloc] initWithFrame:CGRectMake(59, 5, 180, 16)] autorelease];
        self.name.textColor = [UIColor colorWithHexString:@"#A6937C"];
        [self.contentView addSubview:name];
        name.font = [UIFont boldSystemFontOfSize:12];
        name.backgroundColor = [UIColor clearColor];
        
        
        
        self.time = [[[UILabel alloc] initWithFrame:CGRectMake(200, 5, 100, 14)] autorelease];
        [self.contentView addSubview:time];
        time.textAlignment = UITextAlignmentRight;
        time.textColor = [UIColor colorWithHexString:@"#D1CDA5"];
        time.font = [UIFont systemFontOfSize:10];
        time.backgroundColor = [UIColor clearColor];
        
//        self.time = [[[UILabel alloc] initWithFrame:CGRectMake(248, 10, 50, 14)] autorelease];
//        [self.contentView addSubview:time];
//        time.font = [UIFont systemFontOfSize:12];
//        time.backgroundColor = [UIColor clearColor];
//        time.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
        
//        self.content = [[[UILabel alloc] initWithFrame:CGRectMake(59, 28, contentWidth, 14)] autorelease];
//        [self.contentView addSubview:content];
//        content.numberOfLines = 0;
//        content.lineBreakMode = NSLineBreakByWordWrapping;
//        content.font = contentFont;
//        content.backgroundColor = [UIColor clearColor];
//        content.textColor = [UIColor colorWithHexString:@"#8D8D8D"];
        
        self.contentEmojo = [[[LWRichTextContentView alloc] initWithFrame:CGRectMake(59, 27, CommentCellcontentWidth, 14) withFont:CommentCellcontentFont withTextColor:[UIColor colorWithHexString:@"#7E6B5A"] withTextShadowColor:nil withTextShadowOffSet:CGSizeZero] autorelease];
        [self.contentView addSubview:contentEmojo];
        [contentEmojo setBackgroundColor:[UIColor clearColor]];
    
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
