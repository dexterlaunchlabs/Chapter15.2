//
//  BIDViewController.m
//  State Lab
//
//  Created by Dexter Launchlabs on 7/30/14.
//  Copyright (c) 2014 Dexter Launchlabs. All rights reserved.
//

#import "BIDViewController.h"

@interface BIDViewController ()
@property (assign, nonatomic) BOOL animate;
- (void)rotateLabelUp;
- (void)rotateLabelDown;
@end

@implementation BIDViewController

@synthesize label;
@synthesize animate;
@synthesize smiley, smileyView;
@synthesize segmentedControl;

- (void)applicationWillResignActive {
    NSLog(@"VC: %@", NSStringFromSelector(_cmd)); animate = NO;
}
- (void)applicationDidBecomeActive {
    NSLog(@"VC: %@", NSStringFromSelector(_cmd)); animate = YES;
    [self rotateLabelDown];
}
- (void)rotateLabelDown {
    [UIView animateWithDuration:0.5
                     animations:^{
                         label.transform = CGAffineTransformMakeRotation(M_PI);
                     }
                     completion:^(BOOL finished){
                         [self rotateLabelUp]; }];
}
- (void)rotateLabelUp {
    [UIView animateWithDuration:0.5
                     animations:^{
                         label.transform = CGAffineTransformMakeRotation(0);
                     }
                     completion:^(BOOL finished){
                         if (animate) {
                             [self rotateLabelDown];}
                     }];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive)
     name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    CGRect bounds = self.view.bounds;
    CGRect labelFrame = CGRectMake(bounds.origin.x, CGRectGetMidY(bounds) - 50,
                                   bounds.size.width, 100); self.label = [[UILabel alloc] initWithFrame:labelFrame]; label.font = [UIFont fontWithName:@"Helvetica" size:70];
    label.text = @"Bazinga!";
    label.textAlignment = UITextAlignmentCenter; label.backgroundColor = [UIColor clearColor]; [self.view addSubview:label];
    NSNumber *indexNumber;
    if (indexNumber = [[NSUserDefaults standardUserDefaults]
                       objectForKey:@"selectedIndex"]) { NSInteger selectedIndex = [indexNumber intValue];
        self.segmentedControl.selectedSegmentIndex = selectedIndex; }
    CGRect smileyFrame = CGRectMake(CGRectGetMidX(bounds) - 42,
                                    CGRectGetMidY(bounds)/2 - 42,
                                    84, 84);
    self.smileyView = [[UIImageView alloc] initWithFrame:smileyFrame];
    self.smileyView.contentMode = UIViewContentModeCenter;
    NSString *smileyPath = [[NSBundle mainBundle] pathForResource:@"smiley"
                                                           ofType:@"png"]; self.smiley = [UIImage imageWithContentsOfFile:smileyPath];
    self.smileyView.image = self.smiley;
    [self.view addSubview:smileyView];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects:
                                                                        @"One", @"Two", @"Three", @"Four", nil]] ; self.segmentedControl.frame = CGRectMake(bounds.origin.x + 20,CGRectGetMaxY(bounds) - 50, bounds.size.width - 40, 30);
    [self.view addSubview:segmentedControl];
    //[self rotateLabelDown];
}
- (void)viewDidUnload {
    [super viewDidUnload];
    self.smiley = nil;
    self.smileyView = nil;
    // Release any retained subviews of the main view. // e.g. self.myOutlet = nil;
    self.label = nil;
    self.segmentedControl = nil;
}
- (void)applicationDidEnterBackground { NSLog(@"VC: %@", NSStringFromSelector(_cmd));
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier taskId;
    taskId = [app beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background task ran out of time and was terminated.");
        [app endBackgroundTask:taskId]; }];
    if (taskId == UIBackgroundTaskInvalid) { NSLog(@"Failed to start background task!"); return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{ NSLog(@"Starting background task with %f seconds remaining",
                                                             app.backgroundTimeRemaining);
    
    
    
    
    self.smiley = nil;
    self.smileyView.image = nil;
    NSInteger selectedIndex = self.segmentedControl.selectedSegmentIndex; [[NSUserDefaults standardUserDefaults] setInteger:selectedIndex
                                                                                                                     forKey:@"selectedIndex"];
        [NSThread sleepForTimeInterval:25];
        NSLog(@"Finishing background task with %f seconds remaining", app.backgroundTimeRemaining);
        [app endBackgroundTask:taskId]; });
}
- (void)applicationWillEnterForeground {
    NSLog(@"VC: %@", NSStringFromSelector(_cmd));
    NSString *smileyPath = [[NSBundle mainBundle] pathForResource:@"smiley"
                                                           ofType:@"png"];
    self.smiley = [UIImage imageWithContentsOfFile:smileyPath];
    self.smileyView.image = self.smiley;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
