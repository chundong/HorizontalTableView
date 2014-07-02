#import "AppDelegate.h"

#import "HorizontalTableView.h"

CGFloat screenHeight(){
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    return height;
}
CGFloat screenWidth(){
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    return width;
}

@interface MyDataSource :NSObject<HorizontalTableViewDatasource>{
    
}

@end

@implementation MyDataSource
- (id)init{
    self= [super init];
    if (self) {
        
    }
    return self;
}
- (NSInteger)tableView:(HorizontalTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)heightForSection:(HorizontalTableView *)tableView{
    return 66;
}

- (HorizontalTableViewCell *)tableView:(HorizontalTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HorizontalTableViewCell* cell = NULL;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"hello"];
    if (cell == NULL) {
        cell = [[HorizontalTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"hello"];
    }
    if (indexPath.section % 2 == 0) {
        cell.backgroundColor = [UIColor blueColor];
    }else{
        cell.backgroundColor = [UIColor yellowColor];
    }
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [NSString stringWithFormat:@"section %ld row %ld",(long)indexPath.section,(long)indexPath.row];
    label.textColor = [UIColor blueColor];
    label.backgroundColor =[UIColor whiteColor];
    [label sizeToFit];
    [cell addSubview:label];
    
    return cell;
    //    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(HorizontalTableView *)tableView{
    return 13;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [NSString stringWithFormat:@"section %@",@(section)]; ;
}
@end

@interface MyDelegate : NSObject<HorizontalTableViewDelegate>


@end

@implementation MyDelegate

- (CGFloat)tableView:(HorizontalTableView*)tableView widthForRowAtIndexPath:(NSIndexPath *)indexPath{
    return screenWidth();
}
- (BOOL)showSectionAboveCell:(HorizontalTableView *)tableView{
    return NO;
}
@end


@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    HorizontalTableView* tableView = [[HorizontalTableView alloc] initWithFrame:CGRectMake(0, 20, screenWidth(), screenHeight() -20)];
    
    tableView.backgroundColor = [UIColor redColor];
    
    MyDataSource* myds = [[MyDataSource alloc] init];
    tableView.hDatasource = myds;
    tableView.hDelegate = [[MyDelegate alloc] init];
    [self.window addSubview:tableView];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end