//
//  gagView.m
//  vietGag
//
//  Created by William on 8/30/12.
//  Copyright (c) 2012 Vinova. All rights reserved.
//

#import "GagScrollView.h"

@interface GagScrollView() {
    
}

@end

@implementation GagScrollView

- (id)initWithFrame:(CGRect)frame withGag:(Gag *)gag;
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"GagScrollView frame: %.1f - %.1f", self.frame.size.width, self.frame.size.height);
        // Download the gagImage
        NSURL *imageURl = [NSURL URLWithString:gag.imageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURl];
        UIImage *gagImage = [UIImage imageWithData:imageData];
        NSLog(@"gagImage: %.1f - %.1f", gagImage.size.width, gagImage.size.height);
        CGFloat scale = gagImage.size.width / self.frame.size.width;
        self.contentSize = CGSizeMake(gagImage.size.width / scale, gagImage.size.height / scale);
        NSLog(@"Content Size: %.1f - %.1f", self.contentSize.width, self.contentSize.height);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:gagImage];
        imageView.frame = CGRectMake(0.0f, 0.0f, 320, gagImage.size.height / scale);
        NSLog(@"imageView frame: %.1f - %.1f", imageView.frame.size.width, imageView.frame.size.height);
        [self addSubview:imageView];
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
