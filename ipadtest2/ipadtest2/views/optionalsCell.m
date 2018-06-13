//
//  optionalsCell.m
//  ipadtest2
//
//  Created by kench on 2018/5/31.
//  Copyright © 2018年 kench. All rights reserved.
//

#import "optionalsCell.h"
#import "optionals.h"

@interface optionalsCell ()
@property(nonatomic,strong)UIButton *namebtn;


@end

@implementation optionalsCell

#pragma mark ===============重写initwithframe方法============
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建子控件
        
        UIButton *namebtn =[[UIButton alloc]init];
        namebtn.titleLabel.font = [UIFont systemFontOfSize:30];
        [namebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:namebtn];
        self.namebtn = namebtn;
        //namebtn.contentEdgeInsets =  UIEdgeInsetsMake(15, 20, 15, 20) ;
       // namebtn.backgroundColor = [UIColor redColor];
        
    }
    return self;
}

#pragma mark ===============重写frame模型的set方法============
-(void)setOptionals:(optionals *)optionals{
    _optionals = optionals;
    
    [self.namebtn setTitle:optionals.name forState:UIControlStateNormal];
    self.namebtn.enabled = NO;
    

    self.namebtn.frame = CGRectMake(110, 0, 400, 80);
 
    [self.namebtn setBackgroundImage:[UIImage imageNamed:@"paopao2"] forState:UIControlStateNormal];

    
}

#pragma mark ===============创建自定义cell的类方法===========
+(instancetype)optionalsCellWithTable:(UITableView *)tableview{
    static NSString *cid = @"cid";
    optionalsCell *cell = [tableview dequeueReusableCellWithIdentifier:cid];
    if (cell == nil) {
        cell  = [[optionalsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //设置不能被选中
    
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
