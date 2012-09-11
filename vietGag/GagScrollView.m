//
//  gagView.m
//  vietGag
//
//  Created by William on 8/30/12.
//  Copyright (c) 2012 Vinova. All rights reserved.
//

#import "GagScrollView.h"

@interface GagScrollView()
    
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *gagImage;
@property (nonatomic, strong) Gag *gag;

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recoginer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recoginer;

@end

@implementation GagScrollView

@synthesize gag;

- (void)centerScrollViewContents {
    CGSize boundsSize = self.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}


- (void)scrollViewDoubleTapped:(UITapGestureRecognizer *)recoginer {
    CGPoint pointInView = [recoginer locationInView:self.imageView];
    NSLog(@"----- Double tapped at %.1f - %.1f", pointInView.x, pointInView.y);
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer *)recoginer
{
    NSLog(@"----- Two Finger Tapped\n");
}

- (void)downloadGagImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^ {
        UIImage *image = [[UIImage alloc] initWithData:
                          [NSData dataWithContentsOfURL:[NSURL URLWithString:self.gag.imageURL]]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (!image)
                return;
            
            self.gagImage = image;
            CGFloat scale = self.gagImage.size.width / self.frame.size.width;
            self.contentSize = CGSizeMake(self.gagImage.size.width / scale, self.gagImage.size.height / scale);
            UIImageView *imageView = [[UIImageView alloc] initWithImage:self.gagImage];
            imageView.frame = CGRectMake(0.0f, 0.0f, 320, self.gagImage.size.height / scale);
            [self addSubview:imageView];
            self.imageView = imageView;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gagImageUpdated" object:self];
        });
    });
    
    
//    NSLog(@"downloading image data from: %@", self.gag.imageURL);
//    NSURL *downloadURl = [NSURL URLWithString:self.gag.imageURL];
//    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:downloadURl];
//    [request setCompletionBlock:^{
//        NSLog(@"Image file downloaded.");
    
//        NSData *data = [request responseData];
//        self.gagImage = [UIImage imageWithData:data];
//        CGFloat scale = self.gagImage.size.width / self.frame.size.width;
//        self.contentSize = CGSizeMake(self.gagImage.size.width / scale, self.gagImage.size.height / scale);
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.gagImage];
//        imageView.frame = CGRectMake(0.0f, 0.0f, 320, self.gagImage.size.height / scale);
//        [self addSubview:imageView];
//        self.imageView = imageView;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"gagImageUpdated" object:self];
//    }];
//    [request setFailedBlock:^{
//        NSError *error = [request error];
//        NSLog(@"Error downloading image file: %@", error.localizedDescription);
//    }];
//    [request startAsynchronous];
}

- (id)initWithFrame:(CGRect)frame withGag:(Gag *)gagData;
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.gag = gagData;
        NSLog(@"GagScrollView frame: %.1f - %.1f", self.frame.size.width, self.frame.size.height);
        // Download the gagImage
        
        [self downloadGagImage];
        
        UITapGestureRecognizer *doubleTaprecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
        doubleTaprecognizer.numberOfTapsRequired = 2;
        doubleTaprecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTaprecognizer];
        
        UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
        twoFingerTapRecognizer.numberOfTapsRequired = 1;
        twoFingerTapRecognizer.numberOfTouchesRequired = 2;
        [self addGestureRecognizer:twoFingerTapRecognizer];
        
        CGRect scrollViewFrame = self.frame;
        CGFloat scaleWidth = scrollViewFrame.size.width / self.contentSize.width;
        CGFloat scaleHeight = scrollViewFrame.size.height / self.contentSize.height;
        
        CGFloat minScale = MIN(scaleWidth, scaleHeight);
        self.minimumZoomScale = minScale;
        self.maximumZoomScale = 1.0f;
        self.zoomScale = minScale;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
