//
//  LLCirclePublicViewController.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/15.
//

#import "LLCirclePublicViewController.h"
#import "LLCircleModel.h"
#import <UITextView+Placeholder.h>
#import "ZFPhotosSelector.h"
#import "HZYImageScanView.h"

@interface LLCirclePublicViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, HZYImageScanViewDelegate>
@property (nonatomic, strong) UIView *imageContainer;
@property (nonatomic, strong) UITextView *textInput;
@property (nonatomic, strong) NSMutableArray <UIImage *> *imageList;
@property (nonatomic, strong) UIButton *addImageButton;
@end

@implementation LLCirclePublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"" showBack:YES];
    
    [self.naView setRightTitle:@"发表" color:UIColorFromString(@"FC7C4F") frame:CGRectMake(XX_SCREEN_WIDTH-XX_ADJUST_SIZE(172), self.naView.height-XX_ADJUST_SIZE(118), XX_ADJUST_SIZE(172), XX_ADJUST_SIZE(118))];
    
    self.imageList = [NSMutableArray array];
    
    CGFloat top = XX_NAVIGATION_HEIGHT;
    top += XX_ADJUST_SIZE(86);
    {
        UITextView *textInput = [[UITextView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), top, self.view.width-XX_ADJUST_SIZE(43*2), XX_ADJUST_SIZE(63+216))];
        textInput.placeholder = @"写下你想分享的话…";
        textInput.textColor = UIColorFromString(@"222222");
        textInput.font = XX_SYSTEM_FONT(46);
        [self.view addSubview:self.textInput=textInput];
        
        top += textInput.height;
    }
    
    top += XX_ADJUST_SIZE(43);
    CGFloat imageSize = XX_ADJUST_SIZE(317);
    CGFloat gap = XX_ADJUST_SIZE(23);
    CGFloat leftGap = XX_ADJUST_SIZE(43);
    
    UIView *imageContainer = [[UIView alloc] initWithFrame:CGRectMake(leftGap, top, XX_SCREEN_WIDTH-leftGap*2, imageSize*2+gap)];
    [self.view addSubview:self.imageContainer=imageContainer];
    
    for (int i = 0; i < 6; i++) {
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake((imageSize+gap) * (i%3), (imageSize+gap) * (i/3), imageSize, imageSize)];
        pic.tag = 1000+i;
        pic.layer.cornerRadius = XX_ADJUST_SIZE(12);
        pic.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xx_clickImage:)];
        [pic addGestureRecognizer:tap];
        [imageContainer addSubview:pic];
        
        if (i==0) {
            //添加按钮
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = pic.frame;
            [button setImage:[UIImage imageNamed:@"ll_circle_image_add"] forState:UIControlStateNormal];
            button.layer.backgroundColor = [UIColorFromString(@"F0F0F0") CGColor];
            button.layer.cornerRadius = XX_ADJUST_SIZE(12);
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(xx_clickAddImage) forControlEvents:UIControlEventTouchUpInside];
            [imageContainer addSubview:self.addImageButton=button];
        }
    }
    
}

- (void)xx_clickAddImage {
    __weak typeof(self)weakSelf = self;
    ZFPhotosSelector *photoSelector = [[ZFPhotosSelector alloc] init];
    photoSelector.selectPhotoOfMax = 6 - self.imageList.count;
    [photoSelector zf_showIn:self result:^(id responseObject) {
        [weakSelf xx_handleAddImages:(NSArray *)responseObject];
    }];
}

- (void)xx_clickImage:(UITapGestureRecognizer *)sender {
    NSInteger index = sender.view.tag - 1000;
    [HZYImageScanView showWithImages:self.imageList beginIndex:index deletable:YES delegate:self];
}

- (CGRect)imageViewFrameAtIndex:(NSUInteger)index forScanView:(HZYImageScanView *)scanView {
    UIImageView *imageView = [self.imageContainer viewWithTag:1000+index];
    return [imageView.superview convertRect:imageView.frame toView:UIApplication.sharedApplication.delegate.window];
}

- (void)scanView:(HZYImageScanView *)scanView imageDidDelete:(NSInteger)index {
    [self xx_clickDeleteWithIndex:index];
}

- (void)xx_clickDeleteWithIndex:(NSInteger)index {
    [self.imageList removeObjectAtIndex:index];
    for (int i = 0; i < 6; i++) {
        UIImageView *imageView = [self.imageContainer viewWithTag:1000+i];
        if (i >= self.imageList.count) {
            imageView.image = nil;
            imageView.userInteractionEnabled = NO;
            continue;
        }
        imageView.image = self.imageList[i];
        imageView.userInteractionEnabled = YES;
    }
    UIImageView *imageView = [self.imageContainer viewWithTag:1000+self.imageList.count];
    self.addImageButton.origin = imageView.origin;
}

- (void)xx_handleAddImages:(NSArray *)images {
    [self.imageList addObjectsFromArray:images];
    
    for (int i = 0; i < 6; i++) {
        UIImageView *imageView = [self.imageContainer viewWithTag:1000+i];
        if (i >= self.imageList.count) {
            imageView.image = nil;
            imageView.userInteractionEnabled = NO;
        } else {
            imageView.image = self.imageList[i];
            imageView.userInteractionEnabled = YES;
        }
    }
    
    if (self.imageList.count >= 6) {
        self.addImageButton.hidden = YES;
    } else {
        UIImageView *imageView = [self.imageContainer viewWithTag:1000+self.imageList.count];
        self.addImageButton.origin = imageView.origin;
    }
}

- (void)rightClick {
    if (self.textInput.text.length == 0) {
        [JKAlert alertText:@"请填写内容"];
        return;
    }
    if (self.imageList.count == 0) {
        [JKAlert alertText:@"请添加图片"];
        return;
    }
    
    LLCircleModel *model = [[LLCircleModel alloc] init];
    model.userName = [LLUserManager loginUserName];
    model.userId = [LLUserManager loginUserId];
    model.userIcon = [LLUserManager loginImage];
    
    {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
        model.time = currentDateString;
    }
    
    model.content = self.textInput.text;
    model.imageList = self.imageList;
    
    [JKAlert alertWaiting:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JKAlert alertWaiting:NO];
        if (self.DidPublish) {
            self.DidPublish(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)backClick {
    if (self.textInput.text.length > 0 || self.imageList.count > 0) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确认要放弃编辑吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [super backClick];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertVC animated:YES completion:NULL];
    } else {
        [super backClick];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
