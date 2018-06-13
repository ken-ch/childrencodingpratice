//
//  ViewController.h
//  ipadtest2
//
//  Created by kench on 2018/5/31.
//  Copyright © 2018年 kench. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@protocol writemessagedelegate<NSObject>
-(void)writemessage:(ViewController *)viewcontroller andmutablearray:(NSMutableArray *)array;

@end

@interface ViewController : UIViewController
{
    CGPoint endpoint;
}

-(BOOL)anySubviewsScrolling:(UIView *)view;

@property(nonatomic,weak)id<writemessagedelegate>delegate;
@end

