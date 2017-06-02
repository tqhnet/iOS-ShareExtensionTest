//
//  AppDelegate.m
//  ShareExtensionTest
//
//  Created by tqh on 2017/6/2.
//  Copyright © 2017年 tqn. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@",NSHomeDirectory());
    
    [[NSUserDefaults standardUserDefaults]setObject:@"33" forKey:@"123"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
   
    //从share Extension里面得到的分享数据
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.YourExtension"];
    //读取数据
    
    BOOL hasNewShare = [userDefaults boolForKey:@"has-new-share"];
    if (hasNewShare) {
        //进行数据解析等操作
        NSLog(@"从分享中得到的网址链接是：%@", [userDefaults valueForKey:@"share-url"]);
        [userDefaults setBool:NO forKey:@"has-new-share"];
        [userDefaults synchronize];
    }else {
        NSLog(@"不处理");
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
