//
//  Created by steve on 13-5-31.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMAutocompleteTextField.h"
#import "UIColor+HexString.h"

NSString *const TextDidAutoCompleted = @"TextDidAutoCompleted";

static NSObject<WMAutocompleteDataSource> *DefaultAutocompleteDataSource = nil;

@interface WMAutocompleteTextField ()

@property (nonatomic, strong) NSString *autocompleteString;
@property (nonatomic, strong) NSString *lastText;

@end

@implementation WMAutocompleteTextField

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self setupAutocompleteTextField];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupAutocompleteTextField];    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
    self.autocompleteString = nil;
    self.lastText = nil;
    [super dealloc];
}

- (void)setupAutocompleteTextField
{
    self.autocompleteLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.autocompleteLabel.font = self.font;
    self.autocompleteLabel.backgroundColor = [UIColor clearColor];
    self.autocompleteLabel.textColor = [UIColor colorWithHexString:@"#bfb2a3"];
    self.autocompleteLabel.lineBreakMode = UILineBreakModeClip;
    self.autocompleteLabel.hidden = YES;
    [self addSubview:self.autocompleteLabel];
    [self bringSubviewToFront:self.autocompleteLabel];

    self.autocompleteString = @"";

    self.ignoreCase = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ht_textDidChange:) name:UITextFieldTextDidChangeNotification object:self];
}

#pragma mark - Configuration

+ (void)setDefaultAutocompleteDataSource:(id)dataSource
{
    DefaultAutocompleteDataSource = dataSource;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self.autocompleteLabel setFont:font];
}

#pragma mark - UIResponder

- (BOOL)becomeFirstResponder
{
    if (!self.autocompleteDisabled)
    {
        if ([self clearsOnBeginEditing])
        {
            self.autocompleteLabel.text = @"";
        }

        self.autocompleteLabel.hidden = NO;
    }

    return [super becomeFirstResponder];
}

#pragma mark - Autocomplete Logic

- (CGRect)autocompleteRectForBounds:(CGRect)bounds
{
    CGRect returnRect = CGRectZero;
    CGRect textRect = [self textRectForBounds:self.bounds];
    
    CGSize prefixTextSize = [self.text sizeWithFont:self.font
                                  constrainedToSize:textRect.size
                                      lineBreakMode:UILineBreakModeCharacterWrap];
    
    CGSize autocompleteTextSize = [self.autocompleteString sizeWithFont:self.font
                                                  constrainedToSize:CGSizeMake(textRect.size.width-prefixTextSize.width, textRect.size.height)
                                                      lineBreakMode:UILineBreakModeCharacterWrap];
    
    returnRect = CGRectMake(textRect.origin.x + prefixTextSize.width + self.autocompleteTextOffset.x,
                            textRect.origin.y + self.autocompleteTextOffset.y,
                            autocompleteTextSize.width,
                            textRect.size.height);

    return returnRect;
}

- (void)ht_textDidChange:(NSNotification*)notification
{
    [self refreshAutocompleteText];
}

- (void)updateAutocompleteLabel
{
    [self.autocompleteLabel setText:self.autocompleteString];
    [self.autocompleteLabel sizeToFit];
    [self.autocompleteLabel setFrame: [self autocompleteRectForBounds:self.bounds]];
}

- (void)refreshAutocompleteText
{
    // Delete the blank characters
    
    if (!self.autocompleteDisabled)
    {
        id <WMAutocompleteDataSource> dataSource = nil;

        if ([self.autocompleteDataSource respondsToSelector:@selector(textField:completionForPrefix:ignoreCase:)])
        {
            dataSource = (id <WMAutocompleteDataSource>)self.autocompleteDataSource;
        }
        else if ([DefaultAutocompleteDataSource respondsToSelector:@selector(textField:completionForPrefix:ignoreCase:)])
        {
            dataSource = DefaultAutocompleteDataSource;
        }

        if (dataSource)
        {
            NSString *text = [self spaceFreeText];
            
            self.autocompleteString = [dataSource textField:self completionForPrefix:text ignoreCase:self.ignoreCase];

            if (text.length > self.lastText.length) {
                
                NSRegularExpression *regex = [NSRegularExpression
                                              regularExpressionWithPattern:@"@\\w{2}$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:NULL];
                
                NSUInteger numMatch = [regex numberOfMatchesInString:text options:0 range:NSMakeRange(0, [text length])];
                
                if (numMatch == 1 && ![self.autocompleteString isEqualToString:@""]) {
                    [self commitAutocompleteText];
                    
                    [self resignFirstResponder];
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:TextDidAutoCompleted
                     object:self
                     userInfo:nil];
                }
            }
        }
    }
    
    self.lastText = [[self.text copy] autorelease];
}

- (NSString *)spaceFreeText {
    NSString *text = [[self.text copy] autorelease];
    NSArray* words = [text componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
    text = [words componentsJoinedByString:@""];
    return text;
}

- (void)commitAutocompleteText
{
    if ([self.autocompleteString isEqualToString:@""] == NO
        && self.autocompleteDisabled == NO)
    {
        [self resignFirstResponder];
        self.text = [NSString stringWithFormat:@"%@%@", [self spaceFreeText], self.autocompleteString];

        self.autocompleteString = @"";
    }
}

- (void)forceRefreshAutocompleteText
{
    [self refreshAutocompleteText];
}

@end
