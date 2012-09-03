//
//  GagsViewController.h
//  vietGag
//
//  Created by Huy Nguyen Luong on 8/27/12.
//  Copyright (c) 2012 Vinova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "Gag.h"
#import "GagScrollView.h"

@interface GagsViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;

@end
