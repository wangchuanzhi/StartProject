//
//  ViewController.m
//  day33滚动翻页
//
//  Created by wangchuanzhi on 16/7/26.
//  Copyright © 2016年 wangchuanzhi. All rights reserved.
//

#import "ViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *sc;

@property(nonatomic,strong)UIPageControl *pc;

@property(nonatomic,strong)NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupSC];
    [self setupPageControl];
    [self setupTimer];
    
    
}
//初始化UIScrollView并且在上面添加照片
-(void)setupSC{
    self.sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, [self heightForImage])];
    self.sc.contentSize=CGSizeMake(SCREEN_WIDTH*5, self.sc.frame.size.height);
    for (int i=1; i<=5; i++) {
        NSString *name=[NSString stringWithFormat:@"img_0%d",i];
        UIImage *image=[UIImage imageNamed:name];
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake((i-1)*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.sc.frame.size.height)];
        imageview.image=image;
    
        [self.sc addSubview:imageview];
    }
    self.sc.delegate=self;
    //一页一页的翻
    self.sc.pagingEnabled=YES;
    
    [self.view addSubview:self.sc];
}
//初始化UIPageControl翻页的按钮
- (void)setupPageControl
{
    //self.sc.frame.origin.y从空白最顶端到到图片的顶端 + self.sc.frame.size.height 图片的高度
    self.pc=[[UIPageControl alloc]initWithFrame:CGRectMake(0, self.sc.frame.size.height+self.sc.frame.origin.y-15, SCREEN_WIDTH, 15)];
    //设置总页数
    [self.pc setNumberOfPages:5];
    //设置当前颜色
    [self.pc setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    //设置默认颜色
    [self.pc setPageIndicatorTintColor:[UIColor cyanColor]];
    //设置当前页数，也即是最初小点的位置
    self.pc.currentPage=0;
    //默认关闭
    self.pc.userInteractionEnabled = YES;
    
    
    [self.view addSubview:self.pc];
}
//计时器的初始化方法
-(void)setupTimer{

//计时器的初始化
    //这个方法是控制器运行的时候就自动执行NSTimer,这个是看传智播客中写到的
    
    //self.timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    self.timer=[NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    //如果图片下面放一个TEXT文本框的时候，当拖动文本框时候，上边的图片就不自动翻页了是因为NStimer的优先级没有UItextfield的高 解决办法是将他两个的优先级设置一样
    //修nstimer 的优先级与控件 的yiyang
    //创建一个消息循环
    //获取当前消息循环的对象
    NSRunLoop *loop=[NSRunLoop mainRunLoop];
    //改变nstimer的优先级
    [loop addTimer:self.timer forMode:NSRunLoopCommonModes];
    

}

//实现计时器开始计时的方法
-(void)timerAction{
//判断当前页是不是等于最后一页
    //拿到当前页if括号里的self.pc.currentPage可以换成page
    //NSInteger page=self.pc.currentPage;
    if(self.pc.currentPage==self.pc.numberOfPages-1){
    //返回第一页
        self.pc.currentPage=0;
        //sc的偏移量
        self.sc.contentOffset=CGPointMake(0, 0);
    }else{
    //前进一页
        self.pc.currentPage++;
    //设置SC的偏移量 和动画
        //偏移的横坐标等于当前的X的坐标加上SC宽度
        //设置UIScrollView的偏移等于新的ContentOffset（传智播客上看的）
        [self.sc setContentOffset:CGPointMake(self.sc.contentOffset.x+SCREEN_WIDTH, 0) animated:YES];
    }
}
//只要SC滚得时候就被调用 让pc也跟着动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //让这个小点点也跟着动
    
    //CGFloat const
    for (int i=1; i<=5; i++) {
        //当sc的x轴偏移等于当前屏幕宽，就是偏移了一页
        if(scrollView.contentOffset.x==SCREEN_WIDTH*(i-1)){
            //当前pc的页数也就是小点点的页数
            self.pc.currentPage=i-1;
        
        
        }
    }

}

//以下这两个方法意思是解决个BUG，当鼠标拖拽不松手的时候停顿几秒钟当放开手时 有两张图片会迅速自动翻页，后面的第三张就恢复原计划的翻页时间
//当滑动减速的时候就调用这个
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //调用计时器的方法
    [self setupTimer];
}
//当用户开始拖拽的时候

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    //计时器停止
    //自动停止后，没有再启动的方法
    //只有重新初始化，下次再启用计数器的时候需要从新创建一个计时器的对象

    [self.timer invalidate];
    //当调用了invalidate方法时 次计时器就废了 所以给他设置等于NIL
    self.timer=nil;
}
//拖拽完毕的时候
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//重新启动一个计时器
self.timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];

    //再次修该nstimer 的优先级与控件 的yiyang
    //创建一个消息循环
    //获取当前消息循环的对象
    NSRunLoop *loop=[NSRunLoop mainRunLoop];
    //改变nstimer的优先级
    [loop addTimer:self.timer forMode:NSRunLoopCommonModes];
    

    
}
//按照宽高比返回图片高度

- (CGFloat)heightForImage
{
    return 260.0*SCREEN_WIDTH/600.0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
