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

@interface GagsViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *gagImageView;
@property (weak, nonatomic) IBOutlet UILabel *gagLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *gagScrollView;

@end
