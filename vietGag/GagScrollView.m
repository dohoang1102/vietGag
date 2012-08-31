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

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recoginer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recoginer;

@end

@implementation GagScrollView

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

- (void)imageUpdated:(NSNotification *)notif {
    
    NSLog(@"Image updated!" );
}

- (id)initWithFrame:(CGRect)frame withGag:(Gag *)gag;
{
    self = [super initWithFrame:frame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageUpdated:) name:@"com.razeware.imagegrabber.imageupdated" object:nil];
    
    if (self) {
        NSLog(@"GagScrollView frame: %.1f - %.1f", self.frame.size.width, self.frame.size.height);
        // Download the gagImage
        NSURL *imageURl = [NSURL URLWithString:gag.imageURL];
//        NSData *imageData = [NSData dataWithContentsOfURL:imageURl];
//        UIImage *gagImage = [UIImage imageWithData:imageData];
        
        NSLog(@"downloading data from: %@", imageURl);
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:imageURl];
        [request setCompletionBlock:^{
            NSLog(@"Image file downloaded.");
            NSData *data = [request responseData];
            UIImage *gagImage = [UIImage imageWithData:data];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"com.razeware.imagegrabber.imageupdated" object:self];
            }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Error downloading image file: %@", error.localizedDescription);
        }];
        [request startAsynchronous];
        
//        NSLog(@"gagImage: %.1f - %.1f", gagImage.size.width, gagImage.size.height);
//        CGFloat scale = gagImage.size.width / self.frame.size.width;
//        self.contentSize = CGSizeMake(gagImage.size.width / scale, gagImage.size.height / scale);
//        NSLog(@"Content Size: %.1f - %.1f", self.contentSize.width, self.contentSize.height);
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:gagImage];
//        imageView.frame = CGRectMake(0.0f, 0.0f, 320, gagImage.size.height / scale);
//        NSLog(@"imageView frame: %.1f - %.1f", imageView.frame.size.width, imageView.frame.size.height);
//        [self addSubview:imageView];
//        
//        self.imageView = imageView;
        
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

- (id)initWithFrame:(CGRect)frame withGagImage:(UIImage *)image;
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"GagScrollView frame: %.1f - %.1f", self.frame.size.width, self.frame.size.height);
        NSLog(@"GagScrollView bounds: %.1f - %.1f", self.bounds.size.width, self.bounds.size.height);
        UIImage *gagImage = image;
        NSLog(@"gagImage: %.1f - %.1f", gagImage.size.width, gagImage.size.height);
        
        CGFloat scale = gagImage.size.width / self.frame.size.width;
        
        
        self.contentSize = CGSizeMake(gagImage.size.width / scale, gagImage.size.height / scale);
     
        
        NSLog(@"Content Size: %.1f - %.1f", self.contentSize.width, self.contentSize.height);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:gagImage];
        
        
        imageView.frame = CGRectMake(0.0f, 0.0f, 320, gagImage.size.height / scale);

        
        NSLog(@"imageView frame: %.1f - %.1f", imageView.frame.size.width, imageView.frame.size.height);
        [self addSubview:imageView];
        
        
        self.imageView = imageView;
        
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
        self.maximumZoomScale = 2.0f;
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
