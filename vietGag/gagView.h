//
//  gagView.h
//  vietGag
//
//  Created by William on 8/30/12.
//  Copyright (c) 2012 Vinova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gag.h"

@interface gagView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) Gag *gag;
@property (nonatomic, strong) UIImage *image;

@end
