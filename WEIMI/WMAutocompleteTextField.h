//
//  Created by steve on 13-5-31.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  WMAutocompleteTextField;

extern NSString *const TextDidAutoCompleted;

@protocol WMAutocompleteDataSource <NSObject>

- (NSString*)textField:(WMAutocompleteTextField*)textField
   completionForPrefix:(NSString*)prefix
            ignoreCase:(BOOL)ignoreCase;

@end

@interface WMAutocompleteTextField : UITextField

/*
 * Designated programmatic initializer (also compatible with Interface Builder)
 */
- (id)initWithFrame:(CGRect)frame;

/*
 * Autocomplete behavior
 */
@property (nonatomic, assign) NSUInteger autocompleteType; // Can be used by the dataSource to provide different types of autocomplete behavior
@property (nonatomic, assign) BOOL autocompleteDisabled;
@property (nonatomic, assign) BOOL ignoreCase;

/*
 * Configure text field appearance
 */
@property (nonatomic, strong) UILabel *autocompleteLabel;
- (void)setFont:(UIFont *)font;
@property (nonatomic, assign) CGPoint autocompleteTextOffset;

/*
 * Specify a data source responsible for determining autocomplete text.
 */
@property (nonatomic, assign) id<WMAutocompleteDataSource> autocompleteDataSource;
+ (void)setDefaultAutocompleteDataSource:(id<WMAutocompleteDataSource>)dataSource;

/*
 * Subclassing: override this method to alter the position of the autocomplete text
 */
- (CGRect)autocompleteRectForBounds:(CGRect)bounds;

/*
 * Refresh the autocomplete text manually (useful if you want the text to change while the user isn't editing the text)
 */
- (void)forceRefreshAutocompleteText;

@end