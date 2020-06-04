//
//  TakeNum.m
//  WujieBigScreen
//
//  Created by 天津沃天科技 on 2019/6/17.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import "TakeNum.h"
#import "NSString+PinYin.h"
#import "PersonViewCell.h"
#import "NumTableListModel.h"
#import "ViewTablePicModel.h"
#import "RowNumPicView.h"
#import "TakeNumberModel.h"
#import "ExitModel.h"
@interface TakeNum ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *numWords;//键盘数字
    NSArray *nameWords;//键盘字母
    
    NSMutableArray*str_Arr;//选中字符串数组
    
    BOOL isCase;//大小写
    BOOL isEnglish;//中英文
    NSArray *nameTableViewData;
    
    NSString  *sexStr;
    NSArray *desk_list_arr;//楼层数组
    NSArray *sub_desk_list_arr;
    
    NSTimer *lineTimer;

}
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;

@property (weak, nonatomic) IBOutlet UITextField *phone_tf;
@property (weak, nonatomic) IBOutlet UITextField *name_tf;

@property (weak, nonatomic) IBOutlet UIView *phoneLine;
@property (weak, nonatomic) IBOutlet UIView *nameLine;

@property (weak, nonatomic) IBOutlet UIView *num_keyBoardView;
@property (weak, nonatomic) IBOutlet UIView *words_keyBoardView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *num_keyBoardViewHH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *words_keyBoardViewHH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *num_keyBoardViewWW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *words_keyBoardViewWW;


@property (nonatomic, strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *nameTableView;
@property (weak, nonatomic) IBOutlet UITableView *sub_floorTableView;
@property (weak, nonatomic) IBOutlet UITableView *floorTableView;

@property (weak, nonatomic) IBOutlet UIButton *floorBtn;
@property (weak, nonatomic) IBOutlet UILabel *floorLab;

@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;

@property (weak, nonatomic) IBOutlet UIImageView *banaView;

@property(nonatomic,strong)NSIndexPath *lastPath;

@property (weak, nonatomic) IBOutlet UIView *ExitBackView;

@property (assign, nonatomic) CGFloat time;


@property (weak, nonatomic) IBOutlet UILabel *numLab;


@end

@implementation TakeNum

#pragma mark ----loadview
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    numWords=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"ABC",@"0",@"删除"];
 nameWords=@[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"大写",@"123",@"n",@"m",@"中/英",@"删除"];
    
    str_Arr=[NSMutableArray array];
    
    
    _num_keyBoardView.hidden= NO;
    _num_keyBoardViewHH.constant=310;
    
    _words_keyBoardView.hidden= YES;
    _words_keyBoardViewHH.constant=0;
    
    
    _phoneBtn.selected=YES;
    _nameBtn.selected=NO;
    
    isCase=NO;//
    isEnglish=NO;//默认中文
    
    [self loadNum_keyBoardView];
    [self loadWords_keyBoardView];
    [self initNameDataSource];
    _nameTableView.hidden=YES;
    
    _sub_floorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_sub_floorTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PersonViewCell class]) bundle:nil] forCellReuseIdentifier:@"PersonViewCell"];
    
    _floorBtn.selected=NO;
    _floorTableView.hidden=YES;
    
    _manBtn.selected=YES;
    _womanBtn.selected=NO;
    sexStr=@"先生";
    
    [self getData];
 
    _ExitBackView.hidden=YES;
    
    
    _phoneLine.hidden=NO;
    _nameLine.hidden=YES;
    [self startTimer];
}
-(void)viewDidAppear:(BOOL)animated
{
    UILongPressGestureRecognizer *longPressGest= [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressView:)];
    longPressGest.minimumPressDuration = 0.5;
    [self.view addGestureRecognizer:longPressGest];
}

//隐藏NavigationBar
-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES]; //设置隐藏
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];//获取真实的frame
    //  NSLog(@"xzxx %f",  _num_keyBoardView.frame.size.width);
    
}

#pragma mark ----tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_nameTableView) {
        return nameTableViewData.count;
    }
    else  if (tableView==_sub_floorTableView)
    {
        return sub_desk_list_arr.count;
    }
    return 0;
//    else
//    {
//        return desk_list_arr.count;
//    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_nameTableView) {
        UITableViewCell *  cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        cell.textLabel.text= [NSString stringWithFormat:@"%@%@",nameTableViewData[indexPath.row],sexStr] ;
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        return cell;
    }
    else  if (tableView==_sub_floorTableView)
    {
        PersonViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PersonViewCell"];
        NumTableListModel *list=sub_desk_list_arr[indexPath.row];
        cell.nameLab.text=list.name;
        cell.seePicBtn.tag=indexPath.row;
        [cell.seePicBtn addTarget:self action:@selector(picBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        if (_lastPath.row==indexPath.row&&_lastPath!=nil) {
            cell.flagImagv.image=[UIImage imageNamed:@"对勾选中"];
            
        }
        else
        {
            cell.flagImagv.image=[UIImage imageNamed:@"对勾未选中"];
        }
        return cell;
    }
//    else
//    {
//        UITableViewCell *  cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
//
//        cell.textLabel.text=desk_list_arr[indexPath.row][@"name"];
//        cell.textLabel.font=[UIFont systemFontOfSize:14];
//
//        return cell;
//    }
    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   if (tableView==_nameTableView) {
    UITableViewCell *  cell= [tableView cellForRowAtIndexPath:indexPath];
    _nameTableView.hidden=YES;
    _name_tf.text=  cell.textLabel.text;
    [str_Arr removeAllObjects];
    
    [lineTimer invalidate];
    _phoneLine.hidden=YES;
    _nameLine.hidden=YES;
    
}
    if (tableView ==_sub_floorTableView) {
        int newRow =(int) [indexPath row];
        int oldRow =(int)( (_lastPath !=nil)?[_lastPath row]:-1);
        if (newRow != oldRow) {
            PersonViewCell *newcell =(PersonViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            newcell.flagImagv.image=[UIImage imageNamed:@"对勾选中"];
            
            PersonViewCell *oldCell =(PersonViewCell *)[tableView cellForRowAtIndexPath:_lastPath];
            oldCell.flagImagv.image=[UIImage imageNamed:@"对勾未选中"];
            _lastPath = indexPath;
            
            if (self->sub_desk_list_arr.count >0) {
                NumTableListModel *list=self->sub_desk_list_arr[_lastPath.item];
                NSMutableAttributedString * AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@，前边排队人数%@位 ",list.name,list.wait_number]];
                
                [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(list.name.length+7,list.wait_number.length)];
                self->_numLab.attributedText=AttributedStr;
            }
            
        }
        
    }
//    if (tableView ==_floorTableView) {
//        _floorLab.text=desk_list_arr[indexPath.row][@"name"];
//        sub_desk_list_arr=desk_list_arr[indexPath.row][@"take_list"];
//        _floorTableView.hidden=YES;
//        _floorBtn.selected=NO;
//        [_sub_floorTableView  reloadData];
//        [self setSelectFirstIndexPath];
//
//    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
    
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (tableView ==_sub_floorTableView) {
//        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, _sub_floorTableView.frame.size.width, 30)];
//        UILabel *lab=[[UILabel alloc]initWithFrame:view.frame];
//        lab.text=@"共100人排队";
//        lab.font=[UIFont systemFontOfSize:14];
//        [view  addSubview:lab];
//        return view;
//    }
//    return nil;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (tableView ==_sub_floorTableView) {
//        return 30;
//    }
//    return 0.01;
//}
#pragma mark ----initkeyBoardView
-(void)loadNum_keyBoardView
{
    
    int totalColumns =3;
    _num_keyBoardViewWW.constant=ScreenW/2-160;
    CGFloat appW =  _num_keyBoardViewWW.constant/3-5;
    CGFloat appH = 70;
    
    //间隙
    CGFloat maginX = 5;
    CGFloat maginY = 5;
    
    for (int i=0; i<numWords.count; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat col = i%totalColumns;
        CGFloat row = i/totalColumns;
        CGFloat appX =col*(appW+maginX)+maginX;
        CGFloat appY= row*(appH+maginY)+maginY;
        but.frame=CGRectMake(appX, appY,appW, appH);
        but.backgroundColor=color(253, 201, 129);
        [but setTitleColor:color(131, 65, 2) forState:UIControlStateNormal];
        
        if ([numWords[i] isEqualToString:@"删除"]) {
            [but setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        }
        else
        {
            [but setTitle:numWords[i] forState:UIControlStateNormal];
        }
        but.tag=i;
        [but addTarget:self action:@selector(numPress:) forControlEvents:UIControlEventTouchUpInside];
        [_num_keyBoardView addSubview:but];
    }
    
    
}
-(void)loadWords_keyBoardView
{
    
    int totalColumns =6;
    
    _words_keyBoardViewWW.constant=ScreenW/2-160;
    CGFloat appW =  _words_keyBoardViewWW.constant/6-5;
    CGFloat appH =  70;
    
    //间隙
    CGFloat maginX = 5;
    CGFloat maginY = 5;
    
    for (int i=0; i<nameWords.count; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat col = i%totalColumns;
        CGFloat row = i/totalColumns;
        CGFloat appX =col*(appW+maginX)+maginX;
        CGFloat appY= row*(appH+maginY)+maginY;
        but.frame=CGRectMake(appX, appY,appW, appH);
        but.backgroundColor=color(253, 201, 129);
        [but setTitleColor:color(131, 65, 2) forState:UIControlStateNormal];
        if ([nameWords[i] isEqualToString:@"删除"]) {
            
            [but setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        }
        else if ([nameWords[i] isEqualToString:@"大写"]) {
            UIImageView *imag=[[UIImageView alloc ]initWithFrame:CGRectMake(CGRectGetWidth(but.frame)/2-10, CGRectGetHeight(but.frame)/2-10, 20, 20)];
            imag.image=[UIImage imageNamed:@"大写"];
            [but addSubview:imag];
            
        }
        else if ([nameWords[i] isEqualToString:@"中/英"]) {
            
            NSMutableAttributedString * AttributedStr = [[NSMutableAttributedString alloc]initWithString:nameWords[i]];
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:color(131, 65, 2)  range:NSMakeRange(1,2)];
            [but setAttributedTitle:AttributedStr forState:UIControlStateNormal];
            
            NSMutableAttributedString * AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:nameWords[i]];
            [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:color(131, 65, 2)  range:NSMakeRange(0,2)];
            [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2,1)];
            [but setAttributedTitle:AttributedStr1 forState:UIControlStateSelected];
            
        }
        else
        {
            [but setTitle:nameWords[i] forState:UIControlStateNormal];
            [but setTitle:[nameWords[i] uppercaseString ] forState:UIControlStateSelected];
        }
        
        but.tag=i;
        but.selected=NO;
        [but addTarget:self action:@selector(namePress:) forControlEvents:UIControlEventTouchUpInside];
        [_words_keyBoardView addSubview:but];
    }
}
#pragma mark ------- touchesBegan
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [lineTimer invalidate];
    _phoneLine.hidden=YES;
    _nameLine.hidden=YES;
    _nameTableView.hidden=YES;
}
#pragma mark ------- IBAction
-(void)longPressView:(UILongPressGestureRecognizer *)longPressGest{
    _ExitBackView.hidden=NO;
}
- (IBAction)selectNumView:(id)sender
{
    [lineTimer invalidate];
    _phoneLine.hidden=YES;
    _nameLine.hidden=YES;
    [self startTimer];
    _num_keyBoardView.hidden= NO;
    _num_keyBoardViewHH.constant=310;
    _words_keyBoardView.hidden= YES;
    _words_keyBoardViewHH.constant=0;
    _phoneBtn.selected=YES;
    _nameBtn.selected=NO;
    
    [str_Arr removeAllObjects];
}

- (IBAction)selectWordView:(id)sender {
    [lineTimer invalidate];
    _phoneLine.hidden=YES;
    _nameLine.hidden=YES;
    [self startTimer];
    _num_keyBoardView.hidden= YES;
    _num_keyBoardViewHH.constant=0;
    _words_keyBoardView.hidden= NO;
    _words_keyBoardViewHH.constant=380;
    _phoneBtn.selected=NO;
    _nameBtn.selected=YES;
    
    [str_Arr removeAllObjects];
}

- (IBAction)selectFloorPress:(id)sender {
    [lineTimer invalidate];
    _phoneLine.hidden=YES;
    _nameLine.hidden=YES;
    _floorBtn.selected=!_floorBtn.selected;
    if (_floorBtn.selected) {
        _floorTableView.hidden=NO;
    }
    else
    {
        _floorTableView.hidden=YES;
    }
    [self setSelectFirstIndexPath];
}
#pragma mark  选择性别
- (IBAction)selectSexPress:(id)sender {
    [lineTimer invalidate];
    _phoneLine.hidden=YES;
    _nameLine.hidden=YES;
    UIButton *but=(UIButton *)sender;
    if (but.tag==2001) {
        _manBtn.selected=YES;
        _womanBtn.selected=NO;
        sexStr=@"先生";
    }
    else
    {
        _manBtn.selected=NO;
        _womanBtn.selected=YES;
        sexStr=@"女士";
    }
    _name_tf.text=nil;
    _nameTableView.hidden=YES;
}
#pragma mark  退出
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
#pragma mark  查看图片
-(void)picBtnPress:(UIButton *)but
{
      ViewTablePicModel *picView=[[ViewTablePicModel alloc]init];
    if (sub_desk_list_arr.count>0) {
        NumTableListModel  *get=  sub_desk_list_arr[but.tag];
        
        picView.desk_type_id=[NSString stringWithFormat:@"%d",[get.id intValue ]];
    }
   
    picView.merchant_id=[[LoginModel shareInstance] getUserInfo].user_info.merchant_id ;
    [MBProgressHUD showMessage:nil toView:self.view];
    [picView ViewTablePicModelSuccess:^(NSString * _Nonnull code, NSString * _Nonnull message,NSDictionary *picDic ) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([code intValue]==200) {
            RowNumPicView *pic=[[RowNumPicView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
            pic.urlArr=picDic[@"img"];
            [self.view.window addSubview:pic];
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
#pragma mark  提交
- (IBAction)submitPress:(id)sender {
      TakeNumberModel *model=[[TakeNumberModel alloc]init];
    if (_phone_tf.text.length==0) {
        [MBProgressHUD showSuccess:@"请输入手机号" toView:self.view];
        return;
    }
    NSString *str =[ValiMobile valiMobile: _phone_tf.text];
    if (str.length>0) {
        [MBProgressHUD showSuccess:str toView:self.view];
        return;
    }
    if (_name_tf.text.length==0) {
        [MBProgressHUD showSuccess:@"请输入联系人" toView:self.view];
        return;
    }
    if (sub_desk_list_arr. count>0) {
     NumTableListModel  *get=  sub_desk_list_arr[_lastPath.row];
        model.desk_type_id=[NSString stringWithFormat:@"%d",[get.id intValue ]];
    }
    else
    {
        [MBProgressHUD showSuccess:@"选择桌位类型" toView:self.view];
        return;
    }
  
    model.merchant_id=[[LoginModel shareInstance] getUserInfo].user_info.merchant_id ;
    model.num_type=@"2";
    model.create_user_type=@"2";
    model.create_user_id=[[LoginModel shareInstance] getUserInfo].user_info.uid;
    model.use_time=@"0";
    model.user_name=_name_tf.text;
    model.user_phone=_phone_tf.text;
    [MBProgressHUD showMessage:nil toView:self.view];
    [model TakeNumberModelSuccess:^(NSString * _Nonnull code, NSString * _Nonnull message, NSDictionary * _Nonnull dataDic) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([code intValue]==200) {
            [MBProgressHUD showSuccess:message toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self resetPress:nil];
            });
        } else {
            [MBProgressHUD showError:message toView:self.view];
        }
        
    } andFailure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:[error localizedDescription] toView:self.view];
        
    }];
}

#pragma mark  重置
- (IBAction)resetPress:(id)sender
{
    _manBtn.selected=YES;
    _womanBtn.selected=NO;
    sexStr=@"先生";
    
    _num_keyBoardView.hidden= NO;
    _num_keyBoardViewHH.constant=310;
    _words_keyBoardView.hidden= YES;
    _words_keyBoardViewHH.constant=0;
    
    _phoneBtn.selected=YES;
    _nameBtn.selected=NO;
    _name_tf.text=nil;
    _phone_tf.text=nil;
    _nameTableView.hidden=YES;
    [str_Arr removeAllObjects];
    
    [lineTimer invalidate];
    _phoneLine.hidden=NO;
    _nameLine.hidden=YES;
    [self startTimer];
    
    
    _floorBtn.selected=NO;
    _floorTableView.hidden=YES;
//    if ( [desk_list_arr count]>0) {
//        _floorLab.text=desk_list_arr[0][@"name"];
//        sub_desk_list_arr=desk_list_arr[0][@"data"];
//        [_floorTableView reloadData];
//        [_sub_floorTableView reloadData];
//        [self setSelectFirstIndexPath];
//    }
        [self setSelectFirstIndexPath];
    
    
}
#pragma mark ---手机号
-(void)numPress:(UIButton *)but
{
    [lineTimer invalidate];
    _phoneLine.hidden=YES;
    _nameLine.hidden=YES;
    [self startTimer];
    
    if ([numWords[but.tag] isEqualToString:@"ABC"]) {
        if (_phoneBtn.selected) {
            return;
        }
        _num_keyBoardView.hidden= YES;
        _num_keyBoardViewHH.constant=0;
        _words_keyBoardView.hidden= NO;
        _words_keyBoardViewHH.constant=380;
        
        
    }
    else if ([numWords[but.tag] isEqualToString:@"删除"]) {
        if(str_Arr.count>0)
        {
            [str_Arr removeLastObject];}
    }
    else
    {
        [str_Arr addObject:but.titleLabel.text];
    }
    
    
    NSMutableString *str=[NSMutableString string];
    for (int i=0 ;i<str_Arr.count ;i++ ) {
        [str appendString:str_Arr[i]];
    }
    if (_phoneBtn.selected) {
        
        _phone_tf.text=str;
    }
    
    if(_nameBtn.selected)
    {
        
        _name_tf.text=str;
    }
    
}
#pragma mark ---联系人
-(void)namePress:(UIButton *)but
{
    [lineTimer invalidate];
    _phoneLine.hidden=YES;
    _nameLine.hidden=YES;
    [self startTimer];
    
    if ([nameWords[but.tag] isEqualToString:@"大写"]) {
        
        but.selected=!but.selected;
        for (UIButton *button  in _words_keyBoardView.subviews) {
            if ([button isKindOfClass:[UIButton class]] ) {
                if (but.selected) {
                    if (button.tag!=28) {
                        button.selected=YES;
                        isCase=YES;
                    }
                    
                }
                else
                {
                    if (button.tag!=28) {
                        button.selected=NO;
                        isCase=NO;
                    }
                    
                }
                
            }
        }
    }
    
    else if ([nameWords[but.tag] isEqualToString:@"123"]) {
        _num_keyBoardView.hidden= NO;
        _num_keyBoardViewHH.constant=310;
        _words_keyBoardView.hidden= YES;
        _words_keyBoardViewHH.constant=0;
    }
    else if ([nameWords[but.tag] isEqualToString:@"中/英"]) {
        but.selected=!but.selected;
        [str_Arr removeAllObjects];
        if (but.selected) {
            isEnglish=YES;
        }
        else{
            isEnglish=NO;
        }
    }
    else if ([nameWords[but.tag] isEqualToString:@"删除"]) {
        if(str_Arr.count>0)
        {
            [str_Arr removeLastObject];
            if (str_Arr.count==0) {
                _nameTableView.hidden=YES;
            }
            
        }
        
    }
    else
    {
        if (isCase) {
            [str_Arr addObject:[but.titleLabel.text uppercaseString]];
        }
        else
        {
            [str_Arr addObject:but.titleLabel.text];
        }
        
    }
    
    
    NSMutableString *str=[NSMutableString string];
    for (int i=0 ;i<str_Arr.count ;i++ ) {
        [str appendString:str_Arr[i]];
    }
    if (_phoneBtn.selected) {
        
        _phone_tf.text=str;
        
    }
    
    if(_nameBtn.selected)
    {
        
        if (isEnglish==NO) {
            
            _name_tf.text=str;
            
            if (str.length>0) {
                _nameTableView.hidden=NO;
                NSString *str1=[self getFirstLetterFromString:str];
                
                nameTableViewData=nil;
                for (NSDictionary *dict in self.dataArray) {
                    
                    NSString *title = dict[@"firstLetter"];
                    if ([str1 isEqualToString:title]) {
                        
                        nameTableViewData=[NSArray arrayWithArray:dict[@"content"]];
                        
                        break;
                    }
                    
                }
                
                [_nameTableView reloadData];
            }
        }
        else
        {
            _nameTableView.hidden=YES;
            _name_tf.text=str;
        }
        
    }
}
#pragma mark---imageTimer
-(void)startTimer
{
    self.time = 0.1;
    lineTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(updataImage:) userInfo:nil repeats:YES];
}
//背景图切换
- (void)updataImage:(NSTimer *)timer {
    if ( _phoneBtn.selected) {
        _phoneLine.hidden = !  _phoneLine.hidden;
    }
    else
    {
        _nameLine.hidden = !  _nameLine.hidden;
    }
    
}

-(void)setSelectFirstIndexPath
{
    
    _lastPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_sub_floorTableView  selectRowAtIndexPath:_lastPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [_sub_floorTableView reloadData];
    
//    if (sub_desk_list_arr.count>0)
//    {
//    _lastPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [_sub_floorTableView  selectRowAtIndexPath:_lastPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//    }
//    else
//    {
//        _lastPath=nil;
//    }
    
    
}
//获取字符串首字母(传入汉字字符串, 返回大写拼音首字母)
-(NSString *)getFirstLetterFromString:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *strPinYin = [str capitalizedString];
    //获取并返回首字母
    return [strPinYin substringToIndex:1];
}
#pragma mark -------- getData
-(void)getData
{
    NumTableListModel  *get=[[NumTableListModel alloc]init];
    [MBProgressHUD showMessage:nil toView:self.view];
    [get NumTableListModelSuccess:^(NSString * _Nonnull code, NSString * _Nonnull message,id data) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([code intValue]==200) {
            NumTableListModel  *get=(NumTableListModel *)data;
            
      
            [self->_banaView sd_setImageWithURL:[NSURL URLWithString:get.data.banner_img] placeholderImage:[UIImage imageNamed:@"无界优品默认空视图"]];
            
            self->sub_desk_list_arr=get.data.desk_list;
            
            if (self->sub_desk_list_arr.count >0) {
                NumTableListModel *list=self->sub_desk_list_arr[0];
                NSMutableAttributedString * AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@，前边排队人数%@位 ",list.name,list.wait_number]];
                
                [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(list.name.length+7,list.wait_number.length)];
                self->_numLab.attributedText=AttributedStr;
            }
            
//            self->desk_list_arr=data[@"desk_list"];
//            if ( [self->desk_list_arr count]>0) {
//                self->_floorLab.text=self->desk_list_arr[0][@"name"];
//                self->sub_desk_list_arr=self->desk_list_arr[0][@"take_list"];
//            }
            
      //      [self->_floorTableView reloadData];
            [self->_sub_floorTableView reloadData];
            
            if ([get.data.surname_list count]>0) {
                NSArray *   array= [self dataArrayFormNet:  get.data.surname_list];
               if (array .count>=self.dataArray.count) {
                    self.dataArray = [[array arrayWithPinYinFirstLetterFormat]mutableCopy];
               }
            }
               [self setSelectFirstIndexPath];
        
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
- (void)initNameDataSource
{
    NSArray *array = @[@"赵",@"钱",@"孙",@"李",@"周",@"吴",@"郑",@"王",
                       @"冯",@"陈",@"楮",@"卫",@"蒋",@"沈",@"韩",@"杨",
                       @"朱",@"秦",@"尤",@"许",@"何",@"吕",@"施",@"张",
                       @"孔",@"曹",@"严",@"华",@"金",@"魏",@"陶",@"姜",
                       @"戚",@"谢",@"邹",@"喻",@"柏",@"水",@"窦",@"章",
                       @"云",@"苏",@"潘",@"葛",@"奚",@"范",@"彭",@"郎",
                       @"鲁",@"韦",@"昌",@"马",@"苗",@"凤",@"花",@"方",
                       @"俞",@"任",@"袁",@"柳",@"酆",@"鲍",@"史",@"唐",
                       @"费",@"廉",@"岑",@"薛",@"雷",@"贺",@"倪",@"汤",
                       @"滕",@"殷",@"罗",@"毕",@"郝",@"邬",@"安",@"常",
                       @"乐",@"于",@"时",@"傅",@"皮",@"卞",@"齐",@"康",
                       @"伍",@"余",@"元",@"卜",@"顾",@"孟",@"平",@"黄",
                       @"和",@"穆",@"萧",@"尹",@"姚",@"邵",@"湛",@"汪",
                       @"祁",@"毛",@"禹",@"狄",@"米",@"贝",@"明",@"臧",
                       @"计",@"伏",@"成",@"戴",@"谈",@"宋",@"茅",@"庞",
                       @"熊",@"纪",@"舒",@"屈",@"项",@"祝",@"董",@"梁",
                       @"杜",@"阮",@"蓝",@"闽",@"席",@"季",@"麻",@"强",
                       @"贾",@"路",@"娄",@"危",@"江",@"童",@"颜",@"郭",
                       @"梅",@"盛",@"林",@"刁",@"锺",@"徐",@"丘",@"骆",
                       @"高",@"夏",@"蔡",@"田",@"樊",@"胡",@"凌",@"霍",
                       @"虞",@"万",@"支",@"柯",@"昝",@"管",@"卢",@"莫",
                       @"经",@"房",@"裘",@"缪",@"干",@"解",@"应",@"宗",
                       @"丁",@"宣",@"贲",@"邓",@"郁",@"单",@"杭",@"洪",
                       @"包",@"诸",@"左",@"石",@"崔",@"吉",@"钮",@"龚",
                       @"程",@"嵇",@"邢",@"滑",@"裴",@"陆",@"荣",@"翁",
                       @"荀",@"羊",@"於",@"惠",@"甄",@"麹",@"家",@"封",
                       @"芮",@"羿",@"储",@"靳",@"汲",@"邴",@"糜",@"松",
                       @"井",@"段",@"富",@"巫",@"乌",@"焦",@"巴",@"弓",
                       @"牧",@"隗",@"山",@"谷",@"车",@"侯",@"宓",@"蓬",
                       @"全",@"郗",@"班",@"仰",@"秋",@"仲",@"伊",@"宫",
                       @"宁",@"仇",@"栾",@"暴",@"斜",@"厉",@"戎",@"祖",
                       @"武",@"符",@"刘",@"景",@"詹",@"束",@"龙",@"叶",
                       @"幸",@"司",@"韶",@"郜",@"黎",@"蓟",@"薄",@"印",
                       @"宿",@"白",@"怀",@"蒲",@"邰",@"从",@"鄂",@"索",
                       @"咸",@"籍",@"赖",@"卓",@"蔺",@"屠",@"蒙",@"池",
                       @"乔",@"阴",@"郁",@"胥",@"能",@"苍",@"双",@"闻",
                       @"莘",@"党",@"翟",@"谭",@"贡",@"劳",@"逄",@"姬",
                       @"申",@"扶",@"堵",@"冉",@"宰",@"郦",@"雍",@"郤",
                       @"璩",@"桑",@"桂",@"濮",@"牛",@"寿",@"通",@"边",
                       @"扈",@"燕",@"冀",@"郏",@"浦",@"尚",@"农",@"温",
                       @"别",@"庄",@"晏",@"柴",@"瞿",@"阎",@"充",@"慕",
                       @"连",@"茹",@"习",@"宦",@"艾",@"鱼",@"容",@"向",
                       @"古",@"易",@"慎",@"戈",@"廖",@"庾",@"终",@"暨",
                       @"居",@"衡",@"步",@"都",@"耿",@"满",@"弘",@"匡",
                       @"国",@"文",@"寇",@"广",@"禄",@"阙",@"东",@"欧",
                       @"殳",@"沃",@"利",@"蔚",@"越",@"夔",@"隆",@"师",
                       @"巩",@"厍",@"聂",@"晁",@"勾",@"敖",@"融",@"冷",
                       @"訾",@"辛",@"阚",@"那",@"简",@"饶",@"空",@"曾",
                       @"毋",@"沙",@"乜",@"养",@"鞠",@"须",@"丰",@"巢",
                       @"关",@"蒯",@"相",@"查",@"后",@"荆",@"红",@"游",
                       @"竺",@"权",@"逑",@"盖",@"益",@"桓",@"公",
                       @"万俟",@"司马",@"上官",@"欧阳",@"夏侯",@"诸葛",
                       @"闻人",@"东方",@"赫连",@"皇甫",@"尉迟",@"公羊",
                       @"澹台",@"公冶",@"宗政",@"濮阳",@"淳于", @"单于",
                       @"太叔",@"申屠",@"公孙",@"仲孙",@"轩辕",@"令狐",
                       @"锺离",@"宇文",@"长孙",@"慕容",@"鲜于",@"闾丘",
                       @"司徒",@"司空",@"丌官",@"司寇",@"仉",@"督",
                       @"子车",@"颛孙",@"端木",@"巫马",@"公西",@"漆雕",
                       @"乐正",@"壤驷",@"公良",@"拓拔",@"夹谷",@"宰父",
                       @"谷梁",@"晋",@"楚",@"阎",@"法",@"汝",@"鄢",
                       @"涂",@"钦",@"段干",@"百里",@"东郭",@"南门",
                       @"呼延",@"归",@"海",@"羊舌",@"微生",@"岳",
                       @"帅",@"缑",@"亢",@"况",@"后",@"有",@"琴",
                       @"梁丘",@"左丘",@"东门",@"西门",@"商",@"牟",
                       @"佘",@"佴",@"伯",@"赏",@"南宫",@"墨",@"哈",
                       @"谯",@"笪",@"年",@"爱",@"阳",@"佟",@"第五",
                       @"言",@"福"];
    self.dataArray = [[array arrayWithPinYinFirstLetterFormat]mutableCopy];
    
    
}
-(NSArray *)dataArrayFormNet:(NSArray *)arr
{
    NSMutableArray *data=[NSMutableArray array];
    for (NumTableListModel *model in arr ) {
        [data addObject:model.second_name];
    }
    return data;
}
@end
