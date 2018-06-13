//
//  NSNotificationListener.h
//  ipadtest2
//
//  Created by kench on 2018/6/8.
//  Copyright © 2018年 kench. All rights reserved.
//

#import <Foundation/Foundation.h>
//通知的监听者
@interface NSNotificationListener : NSObject

@property(nonatomic,copy)NSString *name;

//写一个方法 在通知发生的时候可以监听这个通知
-(void)m1:(NSNotification *)noteinfo;
//这个noteinfo包括了name object 和userinfo
@end
