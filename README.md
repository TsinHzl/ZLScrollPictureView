# ZLScrollPictureView
### 常见的左右滑动轮播展示图片的框架

此框架支持常见的页面上方左右滑动图片的展示
简单的几句代码即可解决繁杂的展示，为你剩下更多的心

**********************************************************
## 使用说明：<br>
#### 将ZLScrollPictureView文件夹拖进你的项目之中，之后引用<br>
#### 使用以下的代码即可使用次框架<br>
### 特别说明：想要响应图片的点击方法，请成为其代理，并遵循协议：ZLScrollPictureViewDelegate<br>
并实现代理方法：<br>
 -(void)scrollPictureViewDidClicked:(UIButton *)button;<br>
或者：<br>
实现属性：<br>
@property (weak, nonatomic) void(^picClickedBlock)(UIButton *btn);<br>
### 特别注意：如果想获取点击图片的tag的，必须将其tag减1才是正确的tag值<br>
*************************************************************
```
//一般的工厂方法
+(instancetype)scrollPicWithPicsName:(NSArray *)picsName frame:(CGRect )frame;
可以改变pagecontrol的indicatorclolor的工厂方法
 +(instancetype)scrollPicWithPicsName:(NSArray *)picsName frame:(CGRect )frame pageControlCurrentTintColor:(UIColor *)currentColor pageContorlTintColor:(UIColor *)tintColor;

//根据图片的url进行图片的设置的工厂方法
+(instancetype)scrollPicWithPicNamesLink:(NSArray *)picNamesLink frame:(CGRect )frame;
//可以改变pagecontrol的indicatorclolor的工厂方法
 +(instancetype)scrollPicWithPicNamesLink:(NSArray *)picNamesLink frame:(CGRect )frame pageControlCurrentTintColor:(UIColor *)currentColor pageContorlTintColor:(UIColor *)tintColor;
```
**********************************************************

## 示例
```
ZLScrollPictureView *v = [ZLScrollPictureView scrollPicWithPicNamesLink:picsArr frame:self.view.bounds pageControlCurrentTintColor:[UIColor purpleColor] pageContorlTintColor:[UIColor whiteColor]];
[self.view addSubview:v];
```
### 设置代理
```
v.delegate = self;
```

### 遵循代理ZLScrollPictureViewDelegate并实现下面代理方法
```
#pragma mark - ZLScrollPictureViewDelegate
- (void)scrollPictureViewDidClicked:(UIButton *)button {
    if (button.tag == 1) {
       //做相应的图片点击响应事件
    }else if (button.tag == 2) {
    
    }
}
```

### 当然也可以用下面提供的这个block来处理图片点击事件
```
v.picClickedBlock = ^(UIButton *btn) {
        //做相应的图片点击响应事件
    };
```

