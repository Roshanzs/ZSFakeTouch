//
//  ViewController.m
//  ZSFakeTouchDome
//
//  Created by WFstark on 2017/8/29.
//  Copyright © 2017年 stark. All rights reserved.
//

#import "ViewController.h"
#import "ZSFakeTouch.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()
@property(nonatomic,strong)UITextField *tex;
@property(nonatomic,strong)UITextField *te;

@property(nonatomic,strong)UITextField *tex1;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)int num;

@property(nonatomic,assign)int beforNum;
@property(nonatomic,strong)UILabel *lab;
@property(nonatomic,strong)UILabel *sliderlab;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.beforNum = 1;
    [self setUP];
    self.num = 1;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerClcik) userInfo:nil repeats:YES];
}

//截图
-(void)createScrren{
    UIWindow*screenWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* viewImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage,nil,nil,nil);
}


-(void)timerClcik{
    //    [self createScrren];
    self.beforNum++;
    self.lab.text = [NSString stringWithFormat:@"%d", self.beforNum];
    [self sliderClick];
    switch (self.num) {
        case 1:
        {
            [self touchesWithPoint:CGPointMake(170, 170)];
            self.tex1.text = nil;
            self.num++;
        }
            break;
        case 2:
        {
            [self touchesWithPoint:CGPointMake(100, 481)];
            self.num++;
        }
            break;
        case 3:
        {
            [self touchesWithPoint:CGPointMake(130, 481)];
            self.num++;
            [self.tex1 resignFirstResponder];
        }
            break;
        case 4:
        {
            [self touchesWithPoint:CGPointMake(170, 120)];
            self.num -= 3;
        }
            break;
            
        default:
            break;
    }
}

-(void)touchesWithPoint:(CGPoint)zspoint{
    [ZSFakeTouch beginTouchWithPoint:zspoint];
    [ZSFakeTouch endTouchWithPoint:zspoint];
    
}

-(void)setUP{
    
    UILabel *sliderlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 40)];
    self.sliderlab = sliderlab;
    sliderlab.text = @"模拟滑动";
    [self.view addSubview:sliderlab];
    
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(160, 40, 200, 40)];
    [self.view addSubview:slider];
    
    
    UILabel *btnlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 120, 40)];
    btnlab.text = @"按钮模拟点击:";
    [self.view addSubview:btnlab];
    
    UIButton *btn1 =[[UIButton alloc]initWithFrame:CGRectMake(160, 100, 40, 40)];
    btn1.backgroundColor = [UIColor grayColor];
    [btn1 setTitle:@"选中" forState:UIControlStateNormal];
    [btn1 setTitle:@"取消" forState:UIControlStateSelected];
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UILabel *texlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, 140, 40)];
    texlab.text = @"文本框模拟点击:";
    [self.view addSubview:texlab];
    
    
    UITextField *tex1 = [[UITextField alloc]initWithFrame:CGRectMake(160, 160, 100, 40)];
    self.tex1 = tex1;
    tex1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:tex1];
    
    
    
    UILabel *numlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 240, 120, 40)];
    numlab.text = @"模拟点击次数:";
    [self.view addSubview:numlab];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(140, 240, 100, 40)];
    self.lab = lab;
    [self.view addSubview:lab];
    
}

-(void)sliderClick{
    
    switch (self.num) {
        case 1:
        {
            [ZSFakeTouch beginTouchWithPoint:CGPointMake(170,60)];
            [ZSFakeTouch moveTouchWithPoint:CGPointMake(240,60)];
            [ZSFakeTouch endTouchWithPoint:CGPointMake(240,60)];
        }
            break;
        case 2:
        {
            [ZSFakeTouch beginTouchWithPoint:CGPointMake(240,60)];
            [ZSFakeTouch moveTouchWithPoint:CGPointMake(310,60)];
            [ZSFakeTouch endTouchWithPoint:CGPointMake(310,60)];
        }
            break;
        case 3:
        {
            [ZSFakeTouch beginTouchWithPoint:CGPointMake(310,60)];
            [ZSFakeTouch moveTouchWithPoint:CGPointMake(350,60)];
            [ZSFakeTouch endTouchWithPoint:CGPointMake(350,60)];
        }
            break;
        case 4:
        {
            [ZSFakeTouch beginTouchWithPoint:CGPointMake(350,60)];
            [ZSFakeTouch moveTouchWithPoint:CGPointMake(170,60)];
            [ZSFakeTouch endTouchWithPoint:CGPointMake(170,60)];
        }
            break;
        default:
            break;
    }
}


-(void)btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    NSLog(@"文本框文字 = %@",self.tex1.text);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
