//
//  WMLineLabel.m
//  WEIMI
//
//  Created by steve on 13-4-9.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMLineLabel.h"
#import "UIColor+HexString.h"

@implementation WMLineLabel

- (id)initWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont systemFontOfSize:fontSize];
        self.textColor = [UIColor colorWithHexString:@"#A6937C"];
        self.textAlignment = UITextAlignmentLeft;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGSize fontSize =[self.text sizeWithFont:self.font
                                    forWidth:self.bounds.size.width
                               lineBreakMode:UILineBreakModeTailTruncation];
    
    
    // Get the fonts color.
    
    const float * colors = CGColorGetComponents(self.textColor.CGColor);
    // Sets the color to draw the line
    CGContextSetRGBStrokeColor(ctx, colors[0], colors[1], colors[2], 1.0f); // Format : RGBA
    
    // Line Width : make thinner or bigger if you want
    CGContextSetLineWidth(ctx, 0.6f);
    
    // Calculate the starting point (left) and target (right)
    CGPoint l = CGPointMake(0,
                            self.frame.size.height/2.0 +fontSize.height/2.0);
    
    CGPoint r = CGPointMake(fontSize.width,
                            self.frame.size.height/2.0 + fontSize.height/2.0);
    
    
    // Add Move Command to point the draw cursor to the starting point
    CGContextMoveToPoint(ctx, l.x, l.y);
    
    // Add Command to draw a Line
    CGContextAddLineToPoint(ctx, r.x, r.y);
    
    
    // Actually draw the line.
    CGContextStrokePath(ctx);
    
    // should be nothing, but who knows...
    //[super drawRect:rect];
    
}

@end
