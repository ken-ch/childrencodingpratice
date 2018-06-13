//
//  optionalsCell.h
//  ipadtest2
//
//  Created by kench on 2018/5/31.
//  Copyright © 2018年 kench. All rights reserved.
//

#import <UIKit/UIKit.h>

@class optionals;
@interface optionalsCell : UITableViewCell

@property(nonatomic,strong)optionals *optionals;

+(instancetype)optionalsCellWithTable:(UITableView *)tableview;

@end
