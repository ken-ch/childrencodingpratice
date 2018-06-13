//
//  optionals.m
//  ipadtest2
//
//  Created by kench on 2018/5/31.
//  Copyright © 2018年 kench. All rights reserved.
//

#import "optionals.h"

@implementation optionals

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)optionalsWithDict:(NSDictionary *)dict{
    
    return  [[self alloc]initWithDict:dict];
    
}


@end
