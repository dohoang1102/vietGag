//
//  GagsViewController.m
//  vietGag
//
//  Created by Huy Nguyen Luong on 8/27/12.
//  Copyright (c) 2012 Vinova. All rights reserved.
//

#import "GagsViewController.h"

@interface GagsViewController ()

@property (nonatomic, strong) NSMutableArray *gagViews;
@property (nonatomic, strong) NSMutableArray *gags;
@property (nonatomic, strong) NSArray *gagImages;

-(NSMutableArray *)getGagsForPage:(int)page
                          perPage:(int)perPage
                          forUser:(NSString *)userId
                        withQuery:(NSString *)query
                          withTag:(NSString *)tag
                       withSource:(NSString *)source;
-(void)loadVisiblePages;
-(void)loadPage:(NSInteger)page;
-(void)purgePage:(NSInteger)page;
@end

@implementation GagsViewController
@synthesize gagImageView;
@synthesize gagLabel;
@synthesize gagScrollView;
@synthesize gagViews;
@synthesize gags;
@synthesize gagImages;

-(void)loadPage:(NSInteger)page
{
    if (page < 0 || page >= 10) {
        return;
    }
    
    UIView *gagView = [self.gagViews objectAtIndex:page];
    if ((NSNull*)gagView == [NSNull null]) {
        
        CGRect frame = self.gagScrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        Gag *currentGag = [gags objectAtIndex:page];
        NSURL *imageURl = [NSURL URLWithString:currentGag.imageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURl];
        UIImage *gagImage = [UIImage imageWithData:imageData];
//        UIImage *gagImage = [self.gagImages objectAtIndex:page];
        
        
        UIScrollView *newPageView = [[UIScrollView alloc] initWithFrame:CGRectMake(frame.size.width * page, 0.0f, frame.size.width, frame.size.height)];
        newPageView.delegate = self;
                
        NSLog(@"newPageView 's Frame: %.1f - %.1f", newPageView.frame.size.width, newPageView.frame.size.height);
    
        
        CGFloat scale = gagImage.size.width / newPageView.frame.size.width;
        
        CGFloat finalScale = MIN(scale, 1.0f / scale);
        
        newPageView.contentSize = CGSizeMake( gagImage.size.width * finalScale, gagImage.size.height * finalScale);
        
//        newPageView.contentSize = gagImage.size;
        
        NSLog(@"newPageView.contentSize: %.1f %.1f", newPageView.contentSize.width, newPageView.contentSize.height);
        
       
        
        UIImageView *newImageView = [[UIImageView alloc]initWithImage:gagImage];
        newImageView.frame = CGRectMake(0.0f, 0.0f, 320, gagImage.size.height * finalScale);
        

        [newPageView addSubview:newImageView];
        
        [gagScrollView addSubview:newPageView];
        [gagViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page
{
    if (page < 0 || page >= 10){
        return;
    }
    
    UIView *pageView = [self.gagViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.gagViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

-(void)loadVisiblePages
{
    CGFloat pageWidth = self.gagScrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.gagScrollView.contentOffset.x)* 2.0f + pageWidth) / (pageWidth * 2.0f);
    
    NSInteger firstPage = page -1;
    NSInteger lastPage = page +1;
    
    for (NSInteger i = 0; i < firstPage; ++i) {
        [self purgePage:i];
    }
    
    for (NSInteger i = firstPage; i <= lastPage; ++i) {
        [self loadPage:i];
    }
    
    for (NSInteger i = lastPage +1; i < 10; i++){
        [self purgePage:i];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    gags = [self getGagsForPage:1 perPage:10 forUser:nil withQuery:nil withTag:nil withSource:nil];
    gagViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 10; ++i) {
        [gagViews addObject:[NSNull null]];
    }
    
    gagImages = [NSArray arrayWithObjects:
                 [UIImage imageNamed:@"1.jpg"],
                 [UIImage imageNamed:@"2.jpg"],
                 [UIImage imageNamed:@"3.jpg"],
                 [UIImage imageNamed:@"4.jpg"],
                 [UIImage imageNamed:@"5.jpg"],
                 [UIImage imageNamed:@"6.jpg"],
                 [UIImage imageNamed:@"7.gif"],
                 [UIImage imageNamed:@"8.gif"],
                 [UIImage imageNamed:@"9.jpg"],
                 [UIImage imageNamed:@"10.jpg"],
                 nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize pageScrollViewSize = self.gagScrollView.frame.size;
    self.gagScrollView.contentSize = CGSizeMake(pageScrollViewSize.width * 10, pageScrollViewSize.height);
    
    [self loadVisiblePages];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadVisiblePages];
}

- (void)viewDidUnload
{
    [self setGagImageView:nil];
    [self setGagLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(NSMutableArray *)getGagsForPage:(int)page
              perPage:(int)perPage
              forUser:(NSString *)userId
            withQuery:(NSString *)query
              withTag:(NSString *)tag
           withSource:(NSString *)source
{
        
    NSString *queryString = @"";
    if (query) {
        NSString* escapedQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        queryString = [NSString stringWithFormat:@"&q=%@", escapedQuery];
    }
    
    NSString *queryUser=@"";
    if (userId) {
        queryUser = [NSString stringWithFormat:@"&udid=%@",userId];
    }
    
    NSString *queryTag=@"";
    if (tag) {
        queryTag = [NSString stringWithFormat:@"&tag=%@", tag];
    }
    
    NSString *querySource=@"";
    if (source) {
        querySource = [NSString stringWithFormat:@"&source=%@", source];
    }
    
	NSString* searchURL = [NSString stringWithFormat:@"http://vietgag.vinova.sg/gags.json?page=%d&per_page=%d%@%@%@%@", page, perPage, queryUser, queryString, queryTag, querySource];

	NSError* error = nil;
	NSURLResponse* response = nil;
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
	
	NSURL* URL = [NSURL URLWithString:searchURL];
	[request setURL:URL];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
	[request setTimeoutInterval:30];
	
	NSData* jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
	if (error)
	{
		NSLog(@"Error performing request %@", searchURL);
	}
    
	NSDictionary *gagsDict = [jsonData objectFromJSONData];

//  NSLog(@"this is response json%@", gagsDict);
    
    NSMutableArray *gagsLoaded = [[NSMutableArray alloc] init];
    
    for (NSDictionary* gagItem in gagsDict) {
        Gag *gag = [[Gag alloc] init];
        gag.Id = [gagItem objectForKey:@"id"];
        gag.title = [gagItem objectForKey:@"title"];
        gag.imageURL = [gagItem objectForKey:@"image_url"];
        gag.gagURL = [gagItem objectForKey:@"gag_url"];
        gag.likesCount = [[gagItem objectForKey:@"likes_count"] intValue];
        [gagsLoaded addObject:gag];
    }
    return gagsLoaded;
}

@end
