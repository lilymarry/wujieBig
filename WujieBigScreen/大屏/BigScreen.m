//
//  BigScreen.m
//  WujieBigScreen
//
//  Created by 天津沃天科技 on 2019/6/19.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import "BigScreen.h"
#import "TableListModel.h"
#import "SNBannerView.h"

#import "ExitModel.h"
#import "MarqueeView.h"
#import "LGJAutoRunLabel.h"
#import "AddCallNum.h"

#define rightDeskItemWigth 200//右侧桌面宽度

@interface BigScreen ()<UIScrollViewDelegate,AVSpeechSynthesizerDelegate,LGJAutoRunLabelDelegate,LGJAutoRunLabelDelegate>
{
    UIScrollView   *rightScrollView;
    NSMutableArray  *rightDeskData;//右侧座位数据
    NSTimer         *getDataTimer;
    NSInteger       index;
    NSArray  *callData;
    NSArray  *fiveData;
    NSString  *callIdStr;
    NSInteger timerCount;
    LGJAutoRunLabel *runLabel;
}
@property (nonatomic, strong)  MarqueeView *fiveView;
@property (strong, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic)   IBOutlet UIImageView *erCodeImagView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *scrollLabView;
@property (weak, nonatomic)   IBOutlet UIView *ExitBackView;
@property (weak, nonatomic)   IBOutlet UIView *rightView;
@property (weak, nonatomic)   IBOutlet NSLayoutConstraint *rightViewWW;


@end

@implementation BigScreen

#pragma  mark-------- view 视图
- (void)viewDidLoad {
    [super viewDidLoad];
    index=0;

    _ExitBackView.hidden=YES;
   
    _rightViewWW.constant=ScreenW/2-30;
    rightScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _rightViewWW.constant,ScreenH-50)];
    rightScrollView.bounces = NO;
    rightScrollView.delegate = self;
    rightScrollView.backgroundColor=[UIColor lightGrayColor];
    [self.rightView addSubview:rightScrollView];
    
    [self getRightData];
    
    [self getLeftData];

     runLabel = [[LGJAutoRunLabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW/3-100,    _scrollLabView.frame.size.height)];
    runLabel.clipsToBounds= YES;
    runLabel.delegate = self;
    runLabel.directionType = LeftType;
    [_scrollLabView addSubview:runLabel];
    
    
    [self startGetDataTimer];
  
 
}


//隐藏NavigationBar
-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES]; //设置隐藏
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    UILongPressGestureRecognizer *longPressGest= [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressView:)];
    longPressGest.minimumPressDuration = 0.5;
    [self.view addGestureRecognizer:longPressGest];
}

-(void) viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
    [_fiveView stopScrollText];
   [self stopScrollText];
}
-(void)initRightScrollView
{
    for (UIView *view in [rightScrollView subviews]) {
        [view removeFromSuperview];
    }
    
    CGFloat contentWidth = 0;
 //   CGFloat contentHeight = 0;
    
    if (rightScrollView.bounds.size.width> rightDeskData.count*rightDeskItemWigth) {
        contentWidth=rightScrollView.bounds.size.width;
    }
    else
    {
         contentWidth=rightDeskData.count*rightDeskItemWigth;
      
    }
    
//    if (rightScrollView.bounds.size.height>[self cherkDataMaxCount:rightDeskData]*80) {
//         contentHeight = rightScrollView.bounds.size.height;
//    }
//    else
//    {
//          contentHeight = [self cherkDataMaxCount:rightDeskData]*80;
//    }
      rightScrollView.contentSize = CGSizeMake(contentWidth,0);
    
    if (rightDeskData.count>0) {
        int i=0;
        CGFloat width = 0;
        CGFloat height=(rightScrollView.frame.size.height-80)/10;
        
        if (rightScrollView.bounds.size.width> rightDeskData.count*rightDeskItemWigth) {
            width = (ScreenW/2-20)/rightDeskData.count-10;
        }
        else
        {
            width=rightDeskItemWigth;
            
        }
        UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 0,  rightScrollView.contentSize.width, 80)];
        lineview.backgroundColor=[UIColor lightGrayColor];
        [rightScrollView addSubview:lineview];
        
        for (TableListModel *model in rightDeskData) {
            
            UIView *titleview=[[UIView alloc]initWithFrame:CGRectMake(i*width+0.5,0, width-1, 79)];
            titleview.backgroundColor=[UIColor whiteColor];
            [lineview addSubview:titleview];
            
            UILabel *titlelab=[[UILabel alloc]initWithFrame:CGRectMake(0,0,titleview.frame.size.width, 40)];
            titlelab.text=model.name;
            titlelab.font=[UIFont systemFontOfSize:18];
            titlelab.textColor=[UIColor redColor];
            titlelab.backgroundColor=[UIColor whiteColor];
            titlelab.textAlignment=NSTextAlignmentCenter;
            [titleview addSubview:titlelab];
            
            
            UILabel *subTitlelab=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, titleview.frame.size.width, 39)];
            subTitlelab.text=[NSString stringWithFormat:@"(等待桌数%@)",model.wait_number];
            subTitlelab.font=[UIFont systemFontOfSize:18];
            subTitlelab.textAlignment=NSTextAlignmentCenter;
            subTitlelab.textColor=[UIColor redColor];
            subTitlelab.backgroundColor=[UIColor whiteColor];
            [titleview addSubview:subTitlelab];
            
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(i*width+0.5, 80, width-1, rightScrollView.bounds.size.height-80)];
            view.backgroundColor=[UIColor whiteColor];
            int j=0;
            for (TableListModel *subModel in model.num_list) {
                UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
                but.frame=CGRectMake(0, height*j, view.frame.size.width, height);
                if (j%2==0) {
                     but.backgroundColor=[UIColor groupTableViewBackgroundColor];
                    [but setImage:[UIImage imageNamed:@"not_reached"] forState:UIControlStateNormal];
                }
                else
                {
                     but.backgroundColor=[UIColor whiteColor];
                     [but setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
                }
                [but setTitle:[NSString stringWithFormat:@" %@",subModel.number_show] forState:UIControlStateNormal];
             
                but.font=[UIFont systemFontOfSize:18];
                [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [view addSubview:but];
                j++;
            }
            [rightScrollView addSubview:view];
            i++;
        }
    }
}
#pragma  mark--------  计时器
-(void)startGetDataTimer
{
    timerCount=1;
    getDataTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadView) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:getDataTimer  forMode:NSRunLoopCommonModes];
}



//-(NSUInteger)cherkDataMaxCount:(NSArray *)arr
//{
//    if (arr.count>0) {
//        TableListModel *model=arr[0];
//        NSUInteger index=model.num_list.count;
//
//        for (int i=1; i<arr.count; i++) {
//            TableListModel *model=arr[i];
//            if (model.num_list.count>index) {
//                index= model.num_list.count;
//            }
//
//        }
//        return index;
//    }
//    else
//    {
//        return 0;
//    }
//
//
//}

-(void)reloadView
{
  
    timerCount++;
    NSLog(@"timerCount  %ld",(long)timerCount);
    if (timerCount%7==0&&timerCount%17!=0) {
        if (index<callData.count)
                {
                    if (callData.count>0) {
                        [runLabel stopAnimation];
                        [runLabel addContentView:[self createLabelWithText:callData[index] textColor:[UIColor                                                                                                                                                              blackColor] labelFont:[UIFont systemFontOfSize:14]]];
                        [runLabel startAnimation];
                        
                        [self  syntheticVoice:callData[index]];
                      
                        TableListModel *model=fiveData[index] ;
                        callIdStr=model.id;
                        [self updateID];
                        index++;
                    }
                   
                   
                }
                else
                {
                    index=0;
                    [self getLeftData];
                   
               }
    }
    else if (timerCount%17==0&&timerCount%5!=0){
        [self getRightData];
    }
    
  
}

-(void)stopScrollText
{
    [getDataTimer invalidate];
    getDataTimer=nil;
}

#pragma  mark-------- 长按点击
-(void)longPressView:(UILongPressGestureRecognizer *)longPressGest{
    _ExitBackView.hidden=NO;
}
#pragma  mark-------- 退出
-(IBAction)exitPress:(id)sender
{
    ExitModel * model=[[ExitModel alloc]init];
    [MBProgressHUD showMessage:nil toView:self.view];
    
    [model ExitModelSuccess:^(NSString * _Nonnull code, NSString * _Nonnull message) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([code intValue]==200) {
            self->_ExitBackView.hidden=YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showSuccess:message toView:self.view];
        }
        
    } andFailure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:[error localizedDescription] toView:self.view];
        
    }];
}
#pragma  mark-------- getData
-(void)getRightData
{
  //  [MBProgressHUD showMessage:nil toView:self.view];
    TableListModel *model=[[TableListModel alloc]init];
    [model TableListModelSuccess:^(NSString * _Nonnull code, NSString * _Nonnull message, id  _Nonnull data) {
  //  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([code intValue]==200) {
            
            TableListModel *list=(TableListModel *)data;
            SNBannerView *banner=[[SNBannerView alloc]initWithFrame:self->_bannerView.frame delegate:nil imageURLs:list.data.merchant_info.photos placeholderImageName:@"无界优品默认空视图"  currentPageTintColor:[UIColor redColor] pageTintColor:[UIColor lightGrayColor]];
            
            [self->_bannerView addSubview:banner];
            
            if (list.data.merchant_info.qr_code.img.length>0) {
                [self->_erCodeImagView sd_setImageWithURL:[NSURL URLWithString:list.data.merchant_info.qr_code.img] placeholderImage:[UIImage imageNamed:@"无界优品默认空视图"]];
            }
            
            if (list.data.desk_info.count) {
                //右侧数据
                self->rightDeskData =[NSMutableArray arrayWithArray:list.data.desk_info];
                [self initRightScrollView];
                [self->rightScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
         
        }
        else
        {
            [MBProgressHUD showError:message toView:self.view];
        }
        
    } andFailure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:[error localizedDescription] toView:self.view];
    }];
}

-(void)getLeftData
{
  //  [MBProgressHUD showMessage:nil toView:self.view];
    TableListModel *model=[[TableListModel alloc]init];
    [model TableListModelSuccess:^(NSString * _Nonnull code, NSString * _Nonnull message, id  _Nonnull data) {
     //   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([code intValue]==200) {
            TableListModel *list=(TableListModel *)data;
    
             //5组数据
             self->fiveData= [NSArray arrayWithArray:list.data.merchant_info.qr_code.details];
             
             [self->_fiveView stopScrollText];
             [self->_fiveView removeFromSuperview];
             self->callData=nil;
             [self->runLabel stopAnimation];
             if (self->fiveData.count>0) {
             
             NSArray *data=[self scrollContentWithArr: self->fiveData];
             NSArray *data1=[self  callContentWithArr:self->fiveData];
             self->_fiveView =[[MarqueeView alloc]initWithFrame:CGRectMake(0, 0, self->_contentView.frame.size.width, self->_contentView.frame.size.height) withTitle:[self cherkThreeDataWithArr:data]];
             [self->_contentView addSubview:self->_fiveView];
             [self->_fiveView startScroll];
             
             self->callData=[NSArray arrayWithArray:data1];
             self->index=0;
             }
          
            
        }
        else
        {
            [MBProgressHUD showError:message toView:self.view];
        }
        
    } andFailure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:[error localizedDescription] toView:self.view];
    }];
}
#pragma mark--------  辅助方法
-(NSArray *)callContentWithArr:(NSArray *)arr
{
    NSMutableArray *array=[NSMutableArray array];
    for (  TableListModel *list in arr) {
        [array addObject:list.call_word];
        
    }
    return array;
}
-(NSArray *)scrollContentWithArr:(NSArray *)arr
{
    NSMutableArray *array=[NSMutableArray array];
    for (  TableListModel *list in arr) {
        NSString *str=[NSString stringWithFormat:@"%@ | %@ | %@", list.second_name,list.number_show,  list.user_name];
        [array addObject:str];
        
    }
    return array;
}
//每三组数据合成一个数组,放在一个大数组中
-(NSArray *)cherkThreeDataWithArr:(NSArray *)data
{
    NSMutableArray *arr = [NSMutableArray  arrayWithArray:data];
    //分组并动态管理数组
    NSMutableArray *bigArr = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableArray *smallArr  = nil;
    for (int i = 0; i < [arr count]; i++) {
        if (i % 3 == 0) {
            smallArr = [[NSMutableArray alloc] initWithCapacity:1];
            [bigArr addObject:smallArr];

        }
        [smallArr addObject:[arr objectAtIndex:i]];
    }

    return bigArr;
}
- (UILabel *)createLabelWithText: (NSString *)text textColor:(UIColor *)textColor labelFont:(UIFont *)font {
    NSString *string = [NSString stringWithFormat:@"%@", text];
    
    CGSize titleSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT,  _scrollLabView.frame.size.height)];
    CGFloat width =titleSize.width;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width,  _scrollLabView.frame.size.height)];
    label.font = font;
    label.text = string;
    label.textColor = textColor;
    return label;
}
#pragma mark 声音合成
- (void)syntheticVoice:(NSString *)soundStr {//  语音合成

    AVSpeechSynthesizer * synthsizer = [[AVSpeechSynthesizer alloc] init];
    synthsizer.delegate = self;
    AVSpeechUtterance * utterance = [[AVSpeechUtterance alloc] initWithString:soundStr];//需要转换的文本
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//国家语言
    utterance.rate = 0.5f;//声速
    utterance.volume = 1;

    [synthsizer speakUtterance:utterance];
}
#pragma mark ----AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"----开始播放");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---完成播放");
}
//#pragma mark scrollViewDelegate
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView==rightScrollView) {
//        if (getDataTimer!=nil) {
//            NSLog(@"start");
//            [getDataTimer  invalidate];
//             getDataTimer=nil;
//        }
//    }
//}
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (scrollView==rightScrollView) {
//        if (getDataTimer==nil) {
//            NSLog(@"end----1");
//             [self  startGetDataTimer];
//        }
//    }
//}
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (scrollView==rightScrollView) {
//        if (getDataTimer==nil) {
//            NSLog(@"end----2");
//            [self  startGetDataTimer];
//        }
//    }
//}

-(void)updateID
{
    AddCallNum *add=[[AddCallNum alloc]init];
    add.id=callIdStr;
    [add AddCallNumSuccess:^(NSString * _Nonnull code, NSString * _Nonnull message, id  _Nonnull data) {
        NSLog(@"updateIDssss %@",message);
    } andFailure:^(NSError * _Nonnull error) {
        
    }];
    
    
}
@end
