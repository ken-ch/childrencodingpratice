//
//  ViewController.m
//  ipadtest2
//
//  Created by kench on 2018/5/31.
//  Copyright © 2018年 kench. All rights reserved.
//



#import "ViewController.h"
#import "optionals.h"
#import "AppDelegate.h"
#import "optionalsCell.h"

#import <AudioToolbox/AudioToolbox.h>

#import "TableViewAnimationKitHeaders.h"

#import "NSNotificationListener.h"
#import "NotificationSender.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIView *optionview;//候选区的view


@property(nonatomic,strong)NSMutableArray *mainarray;//存储数据的数组
@property(nonatomic,strong)NSDictionary *maindict;

@property(nonatomic,strong)UITableView *maintv;//tableview



@property(nonatomic,strong)UIButton *optionstart;
@property(nonatomic,strong)UIButton *optionend;
@property(nonatomic,strong)UIButton *lighton;
@property(nonatomic,strong)UIButton *lightoff;
@property(nonatomic,strong)UIButton *optiondelay;

@property(nonatomic,strong)NSMutableArray *delnamearray; //删除命令行的时候的一个判断要用的全局可变数组

@property(nonatomic,strong)UIButton *sendarraybtn;//进行数组的校验 校验完成后和蓝牙进行通讯并发送数组
@property(nonatomic,strong)NSMutableArray *sendarray;//再使用蓝牙进行文件传输的时候是所需要传过去的命令的数组

@property(nonatomic,strong)UITextView *infotextview;//将程序有关的信息写入到这个textview里面

@property(nonatomic,strong)UIButton *additionalclear;//程序信息的清除按钮（先放着）

@property(nonatomic,strong)NSArray *pickerds;//pickerview
@property(nonatomic,strong)UIPickerView *picker;
@property(nonatomic,strong)NSString *pickerstr;
@property(nonatomic,strong)UILabel *cellclicklbl;

@property(nonatomic,strong)UITextView *rightinfotextview;//用来显示每个按钮的介绍
@property(nonatomic,strong)UILabel *righttoplabel;//用来显示蓝牙的链接状态

//@property(nonatomic,strong)UITextField *pickerfield;//(实验)
//@property(nonatomic,strong)UIButton *pickerbtn;//(实验)

@property(nonatomic,assign)NSInteger index; //用来让长按弹出的alert知道 现在长按的是哪一个cell


@property(nonatomic,assign)CGPoint startpoint;//用来记录控件的初始位置（startbtn用）
@property(nonatomic,assign)CGPoint stoppoint;//用来记录控件的初始位置（end用）
@property(nonatomic,assign)CGPoint onpoint;//用来记录控件的初始位置（onbtn用）
@property(nonatomic,assign)CGPoint offpoint;//用来记录控件的初始位置（offbtn用）
@property(nonatomic,assign)CGPoint delaypoint;//用来记录控件的初始位置（delaybtn用）

@property(nonatomic,strong)UIPanGestureRecognizer *PanGestureRecognizer;//添加在试图上拖动的手势（startbtn用）
@property(nonatomic,strong)UIPanGestureRecognizer *stopPanGestureRecognizer;//添加在试图上拖动的手势（end用）
@property(nonatomic,strong)UIPanGestureRecognizer *onPanGestureRecognizer;//添加在试图上拖动的手势（onbtn用）
@property(nonatomic,strong)UIPanGestureRecognizer *offPanGestureRecognizer;//添加在试图上拖动的手势（offbtn用）
@property(nonatomic,strong)UIPanGestureRecognizer *delayPanGestureRecognizer;//添加在试图上拖动的手势（delaybtn用）


@end

@implementation ViewController

//#pragma mark懒加载index
//-(NSIndexPath *)index{
//    if (_index == nil) {
//        _index = [[NSIndexPath alloc]init];
//    }
//
//    return _index;
//}

-(NSDictionary *)maindict{
    if (_maindict == nil) {
        _maindict = [[NSMutableDictionary alloc]init];
    }
    return _maindict;
}


#pragma mark pickerds懒加载==============
-(NSArray *)pickerds{
    if (_pickerds == nil) {
        _pickerds = [[NSMutableArray alloc]init];
    }
    return _pickerds;
}

#pragma mark delnamearray懒加载==============
-(NSMutableArray *)delnamearray{
    if (_delnamearray == nil) {
        _delnamearray = [[NSMutableArray alloc]init];
    }
    return _delnamearray;
}

#pragma mark mainarray懒加载==============
-(NSMutableArray *)mainarray{
   // NSLog(@"mainarray懒加载");
    if (_mainarray == nil) {
        _mainarray = [[NSMutableArray alloc]init];
    }
    return _mainarray;
}

#pragma mark sendarray懒加载==============
-(NSMutableArray *)sendarray{
    if (_sendarray == nil) {
        _sendarray = [[NSMutableArray alloc]init];
    }
    return _sendarray;
}

#pragma mark PanGestureRecognizer懒加载==============
-(UIPanGestureRecognizer *)PanGestureRecognizer{
    if (_PanGestureRecognizer == nil) {
        _PanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragmoved:)];
    }
    return _PanGestureRecognizer;
}

#pragma mark stopPanGestureRecognizer懒加载==============
-(UIPanGestureRecognizer *)stopPanGestureRecognizer{
    if (_stopPanGestureRecognizer == nil) {
        _stopPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(stopdragmoved:)];
    }
    return _stopPanGestureRecognizer;
}

#pragma mark onPanGestureRecognizer懒加载==============
-(UIPanGestureRecognizer *)onPanGestureRecognizer{
    if (_onPanGestureRecognizer == nil) {
        _onPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(ondragmoved:)];
    }
    return _onPanGestureRecognizer;
}

#pragma mark offPanGestureRecognizer懒加载==============
-(UIPanGestureRecognizer *)offPanGestureRecognizer{
    if (_offPanGestureRecognizer == nil) {
        _offPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(offdragmoved:)];
    }
    return _offPanGestureRecognizer;
}

#pragma mark delayPanGestureRecognizer懒加载==============
-(UIPanGestureRecognizer *)delayPanGestureRecognizer{
    if (_delayPanGestureRecognizer == nil) {
        _delayPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(delaydragmoved:)];
    }
    return _delayPanGestureRecognizer;
}

#pragma mark 隐藏状态栏=================
//隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return YES;
}

//强制横屏没商量
- (void)setNewOrientation:(BOOL)fullscreen

{
    
    if (fullscreen) {
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }else{
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }
    
}
-(void)orientationcontrol{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = YES;//(以上2行代码,可以理解为打开横屏开关)
    [self setNewOrientation:YES];//调用转屏代码
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self orientationcontrol];//设置横屏
    
    [self createview];
    
    [self createleftbtn];

    [self createmaintv];
    
    [self createaddtionalview];
    
    [self createrightview];
    
    [self listenbluetoothstate];
    //通知的监听
    
}

#pragma mark 设置左侧栏的view==============
-(void)createview{
    NSLog(@"width = %f",self.view.frame.size.width);
    NSLog(@"height = %f",self.view.frame.size.height);
   
    CGFloat X = 0;
    CGFloat Y = 50;
    CGFloat W = self.view.frame.size.width *0.3;
    CGFloat H = self.view.frame.size.height - Y -5;
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(X, Y, W, H)];
    [self.view addSubview:leftview];
    leftview.backgroundColor = [UIColor whiteColor];
    leftview.layer.cornerRadius = 10;
    self.optionview = leftview;

    [self.view bringSubviewToFront:leftview];
    
    UIView *topleftview = [[UIView alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width *0.3, 40)];
    [self.view addSubview:topleftview];
    topleftview.backgroundColor = [UIColor whiteColor];
    topleftview.layer.cornerRadius = 10;
 
    
    UILabel *topleftlbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width *0.3, 40)];
    topleftlbl.text = @"功能选择区";
    topleftlbl.textAlignment = NSTextAlignmentCenter;
    topleftlbl.font = [UIFont systemFontOfSize:30];
    [topleftview addSubview:topleftlbl];
  
    
   
    
    
    [self.view sendSubviewToBack:topleftlbl];
    [self.view sendSubviewToBack:topleftview];
    
    
}

#pragma mark 设置左侧栏的按钮==============
-(void)createleftbtn{
    NSLog(@"width = %f",self.view.frame.size.width);
    NSLog(@"height = %f",self.view.frame.size.height);
    
    CGFloat margin = 15;

    CGFloat X = 10;
    CGFloat Y = margin;
    CGFloat W = self.view.frame.size.width *0.3 - 20;
    CGFloat H = 80;
    
    UIButton *startbtn = [[UIButton alloc]initWithFrame:CGRectMake(X , Y , W , H)];
    [startbtn setTitle:@"开始" forState:UIControlStateNormal];
    startbtn.backgroundColor = [UIColor greenColor];
    [self.optionview addSubview:startbtn];
    startbtn.layer.cornerRadius = 10;
    startbtn.titleLabel.font = [UIFont systemFontOfSize:30];
    self.optionstart = startbtn;

    [startbtn addGestureRecognizer:self.PanGestureRecognizer];
    CGPoint startpoint = startbtn.center;
    self.startpoint = startpoint;
 
    
    UIButton *endbtn = [[UIButton alloc]initWithFrame:CGRectMake(X , Y + margin + H, W, H)];
      [endbtn setTitle:@"结束" forState:UIControlStateNormal];
      endbtn.backgroundColor = [UIColor purpleColor];
    [self.optionview addSubview:endbtn];
    endbtn.layer.cornerRadius = 10;
    endbtn.titleLabel.font = [UIFont systemFontOfSize:30];
    self.optionend = endbtn;
    
    [endbtn addGestureRecognizer:self.stopPanGestureRecognizer];
    CGPoint stoppoint = endbtn.center;
    self.stoppoint = stoppoint;
    
    UIButton *on = [[UIButton alloc]initWithFrame:CGRectMake(X ,  Y + margin*2 + H*2, W, H)];
      [on setTitle:@"点亮灯泡" forState:UIControlStateNormal];
    on.backgroundColor = [UIColor orangeColor];
    [self.optionview addSubview:on];
    on.layer.cornerRadius = 10;
    on.titleLabel.font = [UIFont systemFontOfSize:30];
    self.lighton = on;
    
    [on addGestureRecognizer:self.onPanGestureRecognizer];
    CGPoint onpoint = on.center;
    self.onpoint = onpoint;
    

    UIButton *off = [[UIButton alloc]initWithFrame:CGRectMake(X ,  Y + margin*3 + H*3, W, H)];
    [off setTitle:@"关闭灯泡" forState:UIControlStateNormal];
    off.backgroundColor = [UIColor magentaColor];
    [self.optionview addSubview:off];
    off.layer.cornerRadius = 10;
    off.titleLabel.font = [UIFont systemFontOfSize:30];
    self.lightoff = off;
    
    [off addGestureRecognizer:self.offPanGestureRecognizer];
    CGPoint offpoint = off.center;
    self.offpoint = offpoint;
    
    
    
    UIButton *delay = [[UIButton alloc]initWithFrame:CGRectMake(X , Y + margin*4 + H*4  , W, H)];
    [delay setTitle:@"延迟" forState:UIControlStateNormal];
    delay.backgroundColor = [UIColor yellowColor];
    [self.optionview addSubview:delay];
    delay.layer.cornerRadius = 10;
    delay.titleLabel.font = [UIFont systemFontOfSize:30];
    self.optiondelay = delay;
   
    [delay addGestureRecognizer:self.delayPanGestureRecognizer];
    CGPoint delaypoint = delay.center;
    self.delaypoint = delaypoint;
    
    
    UITextView *text = [[UITextView alloc]initWithFrame:CGRectMake(X, Y + margin*5 + H*5, W,200)];
    [self.optionview addSubview:text];
    text.editable = NO;//转换为不可编辑状态
    text.backgroundColor  = [UIColor lightGrayColor];
    text.text  = [NSString stringWithFormat: @" 在这里显示的是每一个模块的相应介绍，你需要把某一个模块拖到程序执行界面上再点击相应的模块就可以看到这个模块的相应介绍"];
    text.textColor = [UIColor blueColor];
    text.layer.cornerRadius = 10;
    text.font = [UIFont systemFontOfSize:17];
    self.rightinfotextview = text;
    
    
}

#pragma mark dragmoved方法==============
-(void)dragmoved:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [self.optionview bringSubviewToFront:self.optionstart];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint  translation = [panGestureRecognizer translationInView:self.view];
        
        self.optionstart.center = CGPointMake(self.optionstart.center.x + translation.x, self.optionstart.center.y + translation.y);
        
        [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
        
    }else{
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            if (CGRectContainsPoint(self.maintv.frame, self.optionstart.center)) {
                [self createmainarray:@"system start" andname:@"开始"];
                  [self.optionstart removeGestureRecognizer:panGestureRecognizer];
                [UIView animateWithDuration:0.3 animations:^{
                    self.optionstart.center = CGPointMake(self.startpoint.x, self.startpoint.y);
                }];
              
            }else{
                [UIView animateWithDuration:0.5 animations:^{
                    self.optionstart.center = CGPointMake(self.startpoint.x, self.startpoint.y);
                }];
            }
        }
    }
 
}

#pragma mark stopdragmoved方法==============
-(void)stopdragmoved:(UIPanGestureRecognizer *)panGestureRecognizer
{
     [self.optionview bringSubviewToFront:self.optionend];
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint  translation = [panGestureRecognizer translationInView:self.view];
        
        self.optionend.center = CGPointMake(self.optionend.center.x + translation.x, self.optionend.center.y + translation.y);
        
        [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
        
    }else{
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            if (CGRectContainsPoint(self.maintv.frame, self.optionend.center)) {
                [self createmainarray:@"system end" andname:@"结束"];
                [self.optionend removeGestureRecognizer:panGestureRecognizer];
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.optionend.center = CGPointMake(self.stoppoint.x, self.stoppoint.y);
                }];
                
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    self.optionend.center = CGPointMake(self.stoppoint.x, self.stoppoint.y);
                }];
            }
        }
    }
    
}

#pragma mark ondragmoved方法==============
-(void)ondragmoved:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [self.optionview bringSubviewToFront:self.lighton];
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint  translation = [panGestureRecognizer translationInView:self.view];
        
        self.lighton.center = CGPointMake(self.lighton.center.x + translation.x, self.lighton.center.y + translation.y);
        
        [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
        
    }else{
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            if (CGRectContainsPoint(self.maintv.frame, self.lighton.center)) {
                [self createmainarray:@"light on 1" andname:@"开1号灯"];
               
                [UIView animateWithDuration:0.3 animations:^{
                    self.lighton.center = CGPointMake(self.onpoint.x, self.onpoint.y);
                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    self.lighton.center = CGPointMake(self.onpoint.x, self.onpoint.y);
                }];
            }
        }
    }
    
}

#pragma mark offdragmoved方法==============
-(void)offdragmoved:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [self.optionview bringSubviewToFront:self.lightoff];
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint  translation = [panGestureRecognizer translationInView:self.view];
        
        self.lightoff.center = CGPointMake(self.lightoff.center.x + translation.x, self.lightoff.center.y + translation.y);
        
        [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
        
    }else{
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            if (CGRectContainsPoint(self.maintv.frame, self.lightoff.center)) {
                [self createmainarray:@"light off 1" andname:@"关1号灯"];
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.lightoff.center = CGPointMake(self.offpoint.x, self.offpoint.y);
                }];
                
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    self.lightoff.center = CGPointMake(self.offpoint.x, self.offpoint.y);
                }];
            }
        }
    }
    
}

#pragma mark delaydragmoved方法==============
-(void)delaydragmoved:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [self.optionview bringSubviewToFront:self.optiondelay];
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint  translation = [panGestureRecognizer translationInView:self.view];
        
        self.optiondelay.center = CGPointMake(self.optiondelay.center.x + translation.x, self.optiondelay.center.y + translation.y);
        
        [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
        
    }else{
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            if (CGRectContainsPoint(self.maintv.frame, self.optiondelay.center)) {
                [self createmainarray:@"delay for 1" andname:@"延迟1秒"];
                [UIView animateWithDuration:0.3 animations:^{
                    self.optiondelay.center = CGPointMake(self.delaypoint.x, self.delaypoint.y);
                }];
                
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    self.optiondelay.center = CGPointMake(self.delaypoint.x, self.delaypoint.y);
                }];
            }
        }
    }
    
}


#pragma mark 把生成一个mainarray抽成一个方法==================
-(void)createmainarray :(NSString *)intomean andname:(NSString *)intoname{
//    NSString *mean = [NSString stringWithFormat:@"%@",intomean];
//    NSString *name = [NSString stringWithFormat:@"%@",intoname];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:intomean forKey:@"mean"];
    [dict setObject:intoname forKey:@"name"];

    
    if (dict) {
        [self.mainarray addObject:dict];
        NSLog(@"mainarray = %@",self.mainarray);
        [self.maintv reloadData];
      

     }


    NSIndexPath *lastindexpath = [NSIndexPath indexPathForRow:self.mainarray.count -1 inSection:0];
    [self.maintv scrollToRowAtIndexPath:lastindexpath atScrollPosition:UITableViewScrollPositionTop animated:NO];//滚动到tableview的最后

    [self starAnimationWithTableView:self.maintv];//开启动画
    
    
}

#pragma mark 设置右边栏rightview==============
-(void)createrightview{
    CGFloat X = self.maintv.frame.size.width +self.maintv.frame.origin.x +5;
    CGFloat Y = self.maintv.frame.origin.y;
    CGFloat W = self.view.frame.size.width - X - 5;
    CGFloat H = self.maintv.frame.size.height ;
    UIView *rightview = [[UIView alloc]initWithFrame:CGRectMake(X, Y, W, H)];
    [self.view addSubview:rightview];
    rightview.backgroundColor = [UIColor whiteColor];
    rightview.layer.cornerRadius = 10;
   
    
    UIView *righttopview = [[UIView alloc]initWithFrame:CGRectMake(X, 5, W, 40)];
    righttopview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:righttopview];
    righttopview.layer.cornerRadius = 10;
    UILabel *rightoplbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, W, 40)];
    rightoplbl.text = @"模块信息区";
    rightoplbl.font = [UIFont systemFontOfSize:30];
    rightoplbl.textAlignment = NSTextAlignmentCenter;
    [righttopview addSubview:rightoplbl];
  
    
//    UITextView *text = [[UITextView alloc]initWithFrame:CGRectMake(10, Y+300, W-20, H-360)];
//    [rightview addSubview:text];
//    text.editable = NO;//转换为不可编辑状态
//    text.backgroundColor  = [UIColor lightGrayColor];
//    text.text  = [NSString stringWithFormat: @" 在这里显示的是每一个模块的相应介绍，你需要把某一个模块拖到程序执行界面上再点击相应的模块就可以看到这个模块的相应介绍"];
//    text.textColor = [UIColor blueColor];
//    text.layer.cornerRadius = 10;
//    text.font = [UIFont systemFontOfSize:17];
//    self.rightinfotextview = text;
    

    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, W-20, 120)];
    lbl.text = @"  这里将要显示的是蓝牙模块的连接状态。";
    lbl.lineBreakMode = 0;
    lbl.numberOfLines =0;
    
    lbl.font = [UIFont systemFontOfSize:17];
    lbl.layer.cornerRadius = 10;
    lbl.layer.masksToBounds= YES;
    lbl.textColor = [UIColor blueColor];
    lbl.backgroundColor = [UIColor lightGrayColor];
    [rightview addSubview:lbl];
    self.righttoplabel = lbl;
    
    [self.view sendSubviewToBack:righttopview];
    [self.view sendSubviewToBack:rightview];
}

#pragma mark 不是很重要的additionalview==============
-(void)createaddtionalview {
  
    CGFloat X = self.view.frame.size.width *0.3;
    CGFloat Y = 0;
    CGFloat W = 5;
    CGFloat H = self.view.frame.size.height ;
    UIView *obmview = [[UIView alloc]initWithFrame:CGRectMake(X, Y, W, H)];
    obmview.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:obmview];
    [self.view sendSubviewToBack:obmview];
    
    UIView *aboview = [[UIView alloc]initWithFrame:CGRectMake(X + W, Y + self.maintv.frame.size.height + 5+50, self.view.frame.size.width - W - self.optionview.frame.size.width, self.view.frame.size.height - self.maintv.frame.size.height - 5- 50)];
    [self.view addSubview:aboview];
    
      [self.view sendSubviewToBack:aboview];
    
    aboview.backgroundColor = [UIColor lightGrayColor];
    
  
    
    UIButton *sendbtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width *0.3 + 200 +10, 0, 200 - 10, aboview.frame.size.height - 5)];
    [sendbtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    sendbtn.titleLabel.font = [UIFont systemFontOfSize:30];
    sendbtn.backgroundColor = [UIColor whiteColor];
    sendbtn .layer.cornerRadius = 10;
    [aboview addSubview:sendbtn];
    [sendbtn addTarget:self action:@selector(sendclick) forControlEvents:UIControlEventTouchUpInside];
    self.sendarraybtn = sendbtn;
    
    UITextView *text = [[UITextView alloc]initWithFrame:CGRectMake(0, 0,aboview.frame.size.width - sendbtn.frame.size.width - 10, aboview.frame.size.height - 5)];
    text.editable = NO;//转换为不可编辑状态
    
    NSDate *nowdate = [NSDate date];//获取当前系统时间
    //创建一个日期时间的格式化器
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置格式
    formatter.dateFormat = @" yyyy-MM-dd HH:mm:ss";
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    NSString *time = [formatter stringFromDate:nowdate];

    text.text  = [NSString stringWithFormat: @"%@    welcome to this app,this app is aim to approve your logical thinking ability and train your brain !",time];
    text.textColor = [UIColor blueColor];
    text.layer.cornerRadius = 10;
    text.font = [UIFont systemFontOfSize:17];
    [aboview addSubview:text];
    self.infotextview = text;
    
    UIView *mbiview = [[UIView alloc]initWithFrame:CGRectMake( self.maintv.frame.size.width + self.maintv.frame.origin.x , 0, 5, self.view.frame.size.height -aboview.frame.size.height)];
    mbiview.backgroundColor = [UIColor lightGrayColor];
   [self.view addSubview:mbiview];
    [self.view sendSubviewToBack:mbiview];
    
}

#pragma mark send按钮的点击事件==============
-(void)sendclick{
    if (self.mainarray) {
        
        for (NSMutableDictionary *dict in self.mainarray) {
            NSString *name = [dict objectForKey:@"mean"];
            NSLog(@"name = %@",name);
            [self.sendarray addObject:name];
        }
        NSLog(@"sendarray = %@",self.sendarray);
        if (self.sendarray) {
            //这一步要校验
            [self checkarray];
            self.sendarray = nil;
        }
    }
    
 
}

#pragma mark sendarray 的校验==============
-(void)checkarray{
//    NSUInteger on = [self.sendarray indexOfObject:@"light on"];
//    NSUInteger off = [self.sendarray indexOfObject:@"light off"];
    
//    if (self.sendarray) {
//        if ([self.sendarray.firstObject isEqualToString:@"system start"]  && [self.sendarray.lastObject isEqualToString:@"system end"]){
//            if ([self.sendarray containsObject: @"light on"]  && [self.sendarray containsObject : @"light off"]) {
//                if (off > on) {
//                     NSLog(@"校验成功");
//                    [self alertview:@"success" andmessage:@"success"];
//                     [self writetolog:@"success"];
//                }else{
//                      [self alertview:@"程序语法错误" andmessage:@"小灯必须先打开才能关闭"];
//                      [self writetolog:@"小灯必须先打开才能关闭"];
//                }
//            }else{
//                   [self alertview:@"程序语法错误" andmessage:@"程序在包含打开小灯的同时要包含关闭小灯"];
//                   [self writetolog:@"程序在包含打开小灯的同时要包含关闭小灯"];
//            }
//        }else{
//            [self alertview:@"程序结构错误" andmessage:@"一个程序应该包含在开始和结束内"];
//             [self writetolog:@"一个程序应该包含在开始和结束内"];
//        }
//    }
    NSUInteger on = 0;
    NSUInteger off = 0;
    
    if (self.sendarray) {
        if ([self.sendarray.firstObject isEqualToString:@"system start"]&&[self.sendarray.lastObject isEqualToString:@"system end"]) {
            for (NSString *item in self.sendarray) {
                if ([item containsString:@"on"]) {
                    on++;
                }
                if ([item containsString:@"off"]) {
                    off++;
                }
            }
            if (on == off) {
                
                if ([self.delegate respondsToSelector:@selector(writemessage:andmutablearray:)]) {
                    NSLog(@"respondsToSelector");
                    for (NSUInteger i = 0; i< self.mainarray.count; i++) {
                         [self.delegate writemessage:self andmutablearray: [self.sendarray objectAtIndex:i]];
                        
                    }
                    
                    
                }
                [self alertview:@"success" andmessage:@"success"];
                [self writetolog:@"success"];
                
            }else{
                [self alertview:@"程序语法错误" andmessage:@"程序在包含打开小灯的同时要包含关闭小灯"];
                [self writetolog:@"程序在包含打开某小灯的同时要包含关闭这个小灯"];
            }
        }else{
            [self alertview:@"程序结构错误" andmessage:@"一个程序应该包含在开始和结束内"];
            [self writetolog:@"一个程序应该包含在开始和结束内"];
        }
    }else{
        [self alertview:@"程序结构错误" andmessage:@"一个程序应该包含在开始和结束内"];
         [self writetolog:@"一个程序应该包含在开始和结束内"];
    }
    
}

#pragma mark sendarray 的校验的alertview==============
-(void)alertview: (NSString *)title andmessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 最主要的tv==============
-(void)createmaintv{
    
    CGFloat X = self.view.frame.size.width *0.3 +5;
    CGFloat Y =40;
    CGFloat W = self.view.frame.size.width - X- 200;
    CGFloat H = self.view.frame.size.height - Y - 150;
    
    UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(X, Y +10 , W, H) ];
    [self.view addSubview:tv];
    tv.dataSource = self;
    tv.delegate = self;//代理数据源
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;//去除掉tableview的分割线
    
    tv.layer.cornerRadius = 10;//圆角矩形
    
    self.maintv = tv;
    
    [self.view sendSubviewToBack:tv];
    
    UIView *toptvview = [[UIView alloc]initWithFrame:CGRectMake(X, 5, W, 40)];
    toptvview.backgroundColor = [UIColor whiteColor];
    toptvview.layer.cornerRadius = 10;
    [self.view addSubview:toptvview];
    
    UILabel *toptvlbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, W, 40)];
    toptvlbl.text = @"程序运行区";
    toptvlbl.textAlignment = NSTextAlignmentCenter;
    toptvlbl.font = [UIFont systemFontOfSize:30];

    [toptvview addSubview:toptvlbl];
    [self.view sendSubviewToBack:toptvlbl];
    [self.view sendSubviewToBack:toptvview];

    
    
    
}

#pragma mark tableView的动画 ====================
- (void)starAnimationWithTableView:(UITableView *)tableView {
    
    [TableViewAnimationKit springListAnimationWithTableView:tableView];
    
}

#pragma mark 最主要的tv的datasource方法==============

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
         return self.mainarray.count;
}


#pragma mark 最主要的tv的datasource方法 以及长按模块==============
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    optionals *model = [[optionals alloc ] initWithDict:self.mainarray[indexPath.row]];

    optionalsCell *cell = [optionalsCell optionalsCellWithTable:tableView];
    
    cell.optionals =model;
    
    
    
    NSMutableDictionary *dict2 = self.mainarray[indexPath.row];
    NSString *select = [dict2 objectForKey:@"name"];
   if (![select isEqualToString:@"开始"]) {
       if (![select isEqualToString:@"结束"]) {
           UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellcongpress:)];
           longpress.minimumPressDuration = 0.5;
           [cell.contentView addGestureRecognizer:longpress];

      
          
       }
       
    }
    
    return cell;

}

#pragma mark 长按动作recognizer ===========================
-(void)cellcongpress:(UILongPressGestureRecognizer *)recognizer{
          CGPoint location = [recognizer locationInView:self.maintv];
    if (recognizer.state == UIGestureRecognizerStateBegan) {

        NSIndexPath *indexpath = [self.maintv indexPathForRowAtPoint:location];
        self.index = indexpath.row;
        NSMutableDictionary *dict2 = self.mainarray[indexpath.row];
        NSString *select = [dict2 objectForKey:@"name"];
        
       if ([select containsString:@"开"]){

            [self cellclickbtnaction:@"请选择你要控制的小灯" andmessage:@"\n\n\n\n"];
            
        }else if ([select containsString:@"关"]){
            
           
            [self cellclickbtnaction:@"请选择你要控制的小灯" andmessage:@"\n\n\n\n"];
            
        }else if ([select containsString:@"延迟"]){
         
            
            [self cellclickbtnaction:@"请选择你要延迟的时间" andmessage:@"\n\n\n\n"];
            
        }
 
    }

}

#pragma mark 点击的tableviewcell的alertview===========
-(void)cellclickbtnaction:(NSString *)title andmessage:(NSString *)message{
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pickerbtnclick];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    UIPickerView *cellpicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, 265, 100)];
    cellpicker.delegate = self;
    cellpicker.dataSource = self;
    [alert.view addSubview:cellpicker];
    self.picker = cellpicker;
    
    self.pickerds = @[@"1",@"2",@"3"];//先都设为123
}

#pragma mark 点击cell弹出的alert中的picker的代理和数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickerds.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    // self.pickerstr = nil;
    
    self.pickerstr = [self.pickerds objectAtIndex:row];
    NSLog(@"self.pickerstr = %@",self.pickerstr);
    
    return [self.pickerds objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}



#pragma mark  点击picker的按钮调用的方法=================
-(void)pickerbtnclick{
    NSDictionary *dict = self.mainarray[self.index];
    NSString *name = [dict objectForKey:@"name"];
    if ([name containsString:@"开"]) {
        
        [self replacearray:@"开" end:@"号"];
    }else if ([name containsString:@"关"]){
        
        [self replacearray:@"关" end:@"号"];
        
    }else if ([name containsString:@"延迟"]){
        
        [self replacearray:@"迟" end:@"秒"];
    }
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
    
}

#pragma mark 选中了某个tableviewcell========================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    //self.index = indexPath.row;
    
    
    NSMutableDictionary *dict2 = self.mainarray[indexPath.row];
    NSString *select = [dict2 objectForKey:@"name"];
    NSLog(@"select = %@",select);
    
    [self showinright:select];
   
}

#pragma mark 点击cell使得右边的信息栏发生改变
-(void)showinright:(NSString *)info{
    if ([info isEqualToString:@"开始"]) {
        self.rightinfotextview.text = @"这是开始模块，开始模块是一个程序最开始要运行的模块，一般一个程序还包括结束模块";
       // [self disablebtnandtext:@"开始"];
    }else if ([info isEqualToString:@"结束"]){
        self.rightinfotextview.text = @"这是结束模块，结束模块标着程序运行马上停止，所有的功能模块都应该写在结束模块上面";
      //  [self disablebtnandtext:@"结束"];
    }else if ([info containsString:@"开"]){
         self.rightinfotextview.text = @"这是开灯模块，开灯模块控制蓝牙小灯的开启，默认开启一号小灯，可以在这个信息栏的上方选择其他小灯，如果程序包含一个开灯模块那么程序必须再包含一个关灯模块";
        
     //   [self cellclickbtnaction:@"请选择你要控制的小灯" andmessage:@"\n\n\n\n"];
        
    }else if ([info containsString:@"关"]){
        self.rightinfotextview.text = @"这是关灯模块，关灯模块控制蓝牙小灯的关闭，默认关闭一号小灯，可以在这个信息栏的上方选择其他小灯，如果程序包含一个关灯模块那么程序必须再包含一个开灯模块";
        
     //   [self cellclickbtnaction:@"请选择你要控制的小灯" andmessage:@"\n\n\n\n"];
        
    }else if ([info containsString:@"延迟"]){
        self.rightinfotextview.text = @"这是延迟模块，延迟模块可以延迟程序的执行，默认延迟一秒钟，可以在这个信息栏的上方更改延迟时间。";
      
      //  [self cellclickbtnaction:@"请选择你要延迟的时间" andmessage:@"\n\n\n\n"];
        
    }
 
}

#pragma mark   替换mainarray================
-(void)replacearray :(NSString *)start end:(NSString *)end{
    
    NSLog(@"xxxxx");
    NSLog(@"self.index = %ld",(long)self.index);
    
    NSDictionary *dict = self.mainarray[self.index];
    NSString *name = [dict objectForKey:@"name"];
    NSString *mean = [dict objectForKey:@"mean"];
    NSLog(@"name = %@",name);
    NSRange namestartRange = [name rangeOfString:start];
    NSRange nameendRange = [name rangeOfString:end];
    NSRange range = NSMakeRange(namestartRange.location
                                + namestartRange.length,
                                nameendRange.location
                                - namestartRange.location
                                - nameendRange.length);

    NSString *nameresult = [name substringWithRange:range];
    NSString *newname = [name stringByReplacingOccurrencesOfString:nameresult withString:self.pickerstr];
    NSLog(@"newname = %@",newname);
    
    
    NSString *changemean = [mean substringToIndex: mean.length - 1];
    NSString *newmean = [NSString stringWithFormat:@"%@%@",changemean,self.pickerstr];
    
    NSMutableDictionary *newdict = [[NSMutableDictionary alloc]init];
    [newdict setObject:newname forKey:@"name"];
    [newdict setObject:newmean forKey:@"mean"];
    NSLog(@"newdict = %@",newdict);
    [self.mainarray replaceObjectAtIndex:self.index withObject:newdict];
    [self.maintv reloadData];
    [self starAnimationWithTableView:_maintv];
}



#pragma mark  commitEditingStyle删除功能
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.mainarray removeObjectAtIndex: indexPath.row];
        [self.maintv deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
      //  [self.maintv reloadData];
        //局部刷新
//        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
//        [self.maintv reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationTop];
        
        for (NSDictionary *dict in self.mainarray) {
            
            NSString *name = [dict objectForKey:@"name"];
            NSLog(@"name = %@",name);
            
            if (![self.delnamearray containsObject:name]) {
                   [self.delnamearray addObject:name];
            }
        }
         NSLog(@"self.delname = %@",_delnamearray);
        BOOL startisbool = [self.delnamearray containsObject:@"开始"];
        if (startisbool == 0) {
            NSLog(@"开始键激活");
           // self.optionstart.enabled = YES;
            [self.optionstart addGestureRecognizer:_PanGestureRecognizer];
        }
        BOOL endisbool = [self.delnamearray containsObject:@"结束"];
        if (endisbool == 0) {
            //self.optionend.enabled = YES;
            [self.optionend addGestureRecognizer:_stopPanGestureRecognizer];
        }
        
        self.delnamearray = nil;
    }
}
//开启向左滑动显示删除功能
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark 监听蓝牙状态的listener===================
-(void)listenbluetoothstate{
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi1:) name:@"blue" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi2:) name:@"connect" object:nil];
    
}
#pragma mark 监听蓝牙状态的方法===================
-(void)tongzhi1:(NSNotification *)text{
    NSLog(@"text = %@",text.userInfo);
    NSString *str = [text.userInfo objectForKey:@"accident"];
    [self writetolog:str];
    self.righttoplabel.text = str;
}

-(void)tongzhi2:(NSNotification *)text{
    NSLog(@"text2 = %@",text.userInfo);
    NSString *str = [text.userInfo objectForKey:@"connectstate"];
    [self writetolog:str];
    self.righttoplabel.text = str;
}

#pragma mark 写入到信息区的方法===================
-(void)writetolog: (NSString *)info{
    
     NSDate *nowdate = [NSDate date];//获取当前系统时间
    //创建一个日期时间的格式化器
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置格式
    formatter.dateFormat = @" yyyy-MM-dd HH:mm:ss";
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    
    NSString *time = [formatter stringFromDate:nowdate];
    
    self.infotextview.text = [NSString stringWithFormat:@"%@\r\n%@    %@" ,self.infotextview.text,time,info];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
