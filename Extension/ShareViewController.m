//
//  ShareViewController.m
//  Extension
//
//  Created by tqh on 2017/6/2.
//  Copyright © 2017年 tqn. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareActViewController.h"

@interface ShareViewController ()

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.activityIndicatorView];
    self.view.backgroundColor = [UIColor redColor];
}

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    

    __weak ShareViewController *theController = self;
    __block BOOL hasExistsUrl = NO;
    [self.extensionContext.inputItems enumerateObjectsUsingBlock:^(NSExtensionItem *  _Nonnull extItem, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [extItem.attachments enumerateObjectsUsingBlock:^(NSItemProvider *  _Nonnull itemProvider, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([itemProvider hasItemConformingToTypeIdentifier:@"public.url"]) {
                
                [itemProvider loadItemForTypeIdentifier:@"public.url" options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                    
                    if ([(NSObject *)item isKindOfClass:[NSURL class]]){
                        NSLog(@"分享的URL = %@", item);
                        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.YourExtension"];
                        
                        //写入数据
                        [userDefaults setValue:((NSURL *)item).absoluteString forKey:@"share-url"];
                        //用于标记是新的分享
                        [userDefaults setBool:YES forKey:@"has-new-share"];
                        [self.activityIndicatorView stopAnimating];
                        [theController.extensionContext completeRequestReturningItems:@[extItem] completionHandler:nil];

                    }
                }];
                hasExistsUrl = YES;
                *stop = YES;
            }
        }];
        if (hasExistsUrl)
        {
            *stop = YES;
        }
    }];
    
    
    if (!hasExistsUrl) {
        //直接退出
       [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
    }
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    
    //定义两个配置项，分别记录用户选择是否公开以及公开的权限，然后根据配置的值
    static BOOL isPublic = NO;
    static NSInteger act = 0;
    
    NSMutableArray *items = [NSMutableArray array];
    
    //创建是否公开配置项
    SLComposeSheetConfigurationItem *item = [[SLComposeSheetConfigurationItem alloc] init];
    item.title = @"是否公开";
    item.value = isPublic ? @"是" : @"否";
    
    __weak ShareViewController *theController = self;
    __weak SLComposeSheetConfigurationItem *theItem = item;
    item.tapHandler = ^{
        
        isPublic = !isPublic;
        theItem.value = isPublic ? @"是" : @"否";
        
        
        [theController reloadConfigurationItems];
    };
    
    [items addObject:item];
    
    if (isPublic)
    {
        //如果公开标识为YES，则创建公开权限配置项
        SLComposeSheetConfigurationItem *actItem = [[SLComposeSheetConfigurationItem alloc] init];
        
        actItem.title = @"公开权限";
        
        switch (act)
        {
            case 0:
                actItem.value = @"所有人";
                break;
            case 1:
                actItem.value = @"好友";
                break;
            default:
                break;
        }
        
        actItem.tapHandler = ^{
            
            //设置分享权限时弹出选择界面
            ShareActViewController *actVC = [[ShareActViewController alloc] init];
            [theController pushConfigurationViewController:actVC];
            
            [actVC onSelected:^(NSIndexPath *indexPath) {
                
                //当选择完成时退出选择界面并刷新配置项。
                act = indexPath.row;
                [theController popConfigurationViewController];
                [theController reloadConfigurationItems];
                
            }];
            
        };
        
        [items addObject:actItem];
    }
    
    return items;
}

#pragma mark - 懒加载

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.backgroundColor = [UIColor redColor];
        _activityIndicatorView.frame = CGRectMake(self.view.frame.size.width/2 - 20, self.view.frame.size.height/2 - 20, 40, 40);
    }
    return _activityIndicatorView;
}

@end
