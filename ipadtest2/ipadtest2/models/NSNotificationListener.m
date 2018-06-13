//
//  NSNotificationListener.m
//  ipadtest2
//
//  Created by kench on 2018/6/8.
//  Copyright © 2018年 kench. All rights reserved.
//

#import "NSNotificationListener.h"

@implementation NSNotificationListener

-(void)m1:(NSNotification *)noteinfo{
    NSLog(@"noteinfo = %@",noteinfo.name);
    
    //noteinfo.object;监听到的通知是什么对象发布的
    //noteinfo.name;监听到的通知的名称
    // noteinfo.userInfo; 通知的具体内容
    
}

-(void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
