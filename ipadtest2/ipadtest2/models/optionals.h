//
//  optionals.h
//  ipadtest2
//
//  Created by kench on 2018/5/31.
//  Copyright © 2018年 kench. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface optionals : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *mean;

-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)optionalsWithDict:(NSDictionary *)dict;

@end
