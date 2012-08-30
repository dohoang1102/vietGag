//
//  Gag.h
//  vietGag
//
//  Created by William on 8/27/12.
//  Copyright (c) 2012 Vinova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gag : NSObject

@property (strong) NSString *Id;
@property (strong) NSString *title;
@property (strong) NSString *imageURL;
@property (strong) NSString *gagURL;
@property (assign) int likesCount;

@end
