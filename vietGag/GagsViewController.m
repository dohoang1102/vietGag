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
@property int curentPage;
@property int downloadingGags;
@property int maximunLoadedGags;
@property int maximumPages;

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

@synthesize maximunLoadedGags;
@synthesize scrollView;
@synthesize gagViews;
@synthesize gags;

@synthesize topLabel;
@synthesize downloadingGags;
@synthesize maximumPages;

-(void)loadPage:(NSInteger)page
{
    if (page < 0 || page >= self.maximumPages) {
        return;
    }
    
    UIView *gagView = [self.gagViews objectAtIndex:page];
    if ((NSNull*)gagView == [NSNull null]) {
        NSLog(@"====Gag: %.d", page);
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        Gag *currentGag = [gags objectAtIndex:page];
        GagScrollView *newPageView = [[GagScrollView alloc] initWithFrame:frame withGag:currentGag];

        
        [scrollView addSubview:newPageView];
        [gagViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page
{
    if (page < 0 || page >= self.maximumPages){
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
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x)* 2.0f + pageWidth) / (pageWidth * 2.0f);
    
    
    if (page == gags.count - 3) {
        ++self.curentPage;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^ {
            NSMutableArray * newGags = [self getGagsForPage:self.curentPage perPage:10 forUser:nil withQuery:nil withTag:nil withSource:nil];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [gags addObjectsFromArray:newGags];
                self.downloadingGags = 10;
                self.topLabel.text = [NSString stringWithFormat:@"Downloading more %d gags...", self.downloadingGags];
            });
        });
        
    }
    
    NSInteger firstPage = page;
    NSInteger lastPage = gags.count - 1;
    
    
//    for (NSInteger i = 0; i < firstPage; ++i) {
//        [self purgePage:i];
//    }
    
    for (NSInteger i = firstPage; i <= lastPage; ++i) {
        [self loadPage:i];
    }
    
//    for (NSInteger i = lastPage +1; i < 10; i++){
//        [self purgePage:i];
//    }
}

- (void)imageUpdated:(NSNotification *)notification {
    --self.downloadingGags;
    self.topLabel.text = [NSString stringWithFormat:@"Downloading more %d gags...", self.downloadingGags];
    NSLog(@"Image updated!" );
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.maximunLoadedGags = 100;
    self.maximumPages = 1000;
    self.curentPage = 1;
    self.downloadingGags = 10;
    self.topLabel.text = [NSString stringWithFormat:@"Downloading more %d gags...", self.downloadingGags];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageUpdated:) name:@"gagImageUpdated" object:nil];
    
    
    gags = [self getGagsForPage:1 perPage:10 forUser:nil withQuery:nil withTag:nil withSource:nil];
    
    gagViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.maximumPages; ++i) {
        [gagViews addObject:[NSNull null]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize pageScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pageScrollViewSize.width * 1000, pageScrollViewSize.height);
    [self loadVisiblePages];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadVisiblePages];
}

- (void)viewDidUnload
{
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
