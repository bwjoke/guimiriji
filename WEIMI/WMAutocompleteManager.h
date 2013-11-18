//
//  Created by steve on 13-5-31.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMAutocompleteTextField.h"

typedef enum {
    WMAutocompleteTypeEmail, // Default
} WMAutocompleteType;

@interface WMAutocompleteManager : NSObject <WMAutocompleteDataSource>

+ (WMAutocompleteManager *)sharedManager;

@end
