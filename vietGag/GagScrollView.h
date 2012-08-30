//
//  gagView.h
//  vietGag
//
//  Created by William on 8/30/12.
//  Copyright (c) 2012 Vinova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gag.h"

@interface GagScrollView : UIScrollView <UIScrollViewDelegate> {
    
}

- (id)initWithFrame:(CGRect)frame withGag:(Gag *)gag;
- (id)initWithFrame:(CGRect)frame withGagImage:(UIImage *)image;

@end
