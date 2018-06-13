//
//  bluetoothCell.m
//  ipadtest2
//
//  Created by kench on 2018/6/4.
//  Copyright © 2018年 kench. All rights reserved.
//

#import "bluetoothCell.h"

@implementation bluetoothCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self preparelayout];
    }
    return self;
}
-(void)preparelayout{

    
    self.blueimgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 300, 60)];
    self.blueimgview.image = [UIImage imageNamed:@"paopao"];
    [self.contentView addSubview:self.blueimgview];
    
    self.bluelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 300, 40)];
    self.bluelabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.bluelabel];

}

//+ (instancetype)CellWithTable:(UITableView *)tableview{
//    static NSString *cid = @"cid";
//    bluetoothCell *cell = [tableview dequeueReusableCellWithIdentifier:cid];
//    if (cell == nil) {
//        cell  = [[bluetoothCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
//    }
//    
//    
//    
//    return cell;
//    
//    
//}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
