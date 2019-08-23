//
//  BLStopwatchManager.m
//  MDCarProject
//
//  Created by 张博文 on 2018/11/29.
//  Copyright © 2018年 于朝盼. All rights reserved.
//

#import "BLStopwatchManager.h"
#import "BLStopwatch.h"
@implementation BLStopwatchManager

+ (void)getstopManagerBlock:(stopBlock)block description:(NSString*)descriptionString
{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        // 处理耗时操作的代码块...
    
#if DEBUG
        
        [[BLStopwatch sharedStopwatch] start];
#endif
        if (block) {
            block();
        }

//    });
    
    [[BLStopwatch sharedStopwatch] splitWithDescription:descriptionString];
    [[BLStopwatch sharedStopwatch] stop];
}

+ (void)stopTimeAlertShow
{
#if DEBUG
    
    //        //通知主线程刷新
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            //回调或者说是通知主线程刷新，
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:[[BLStopwatch sharedStopwatch] prettyPrintedSplits] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
    //        });
#endif
}

@end
