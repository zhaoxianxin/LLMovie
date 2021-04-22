//
//  LLCircleListCell.m
//  LLMovie
//
//  Created by xin xian on 2021/3/14.
//

#import "LLCircleListCell.h"
#import "HZYImageScanView.h"

@interface LLCircleListCell()
//信息
@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) UILabel *contentLabel;
//图片
@property (nonatomic, strong) UIView *imageContainer;

//按钮
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) BOOL isInDetail; // 详情模式
@end

@implementation LLCircleListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *headerIV = [[UIImageView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), XX_ADJUST_SIZE(46), XX_ADJUST_SIZE(115), XX_ADJUST_SIZE(115))];
        headerIV.layer.cornerRadius = headerIV.height/2;
        headerIV.layer.masksToBounds = YES;
        headerIV.backgroundColor = UIColorFromString(@"AAAAAA");
        headerIV.userInteractionEnabled = YES;
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xx_clickHeader)];
            [headerIV addGestureRecognizer:tap];
        }
        [self.contentView addSubview:self.headerIV=headerIV];
        
        UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        reportButton.frame = CGRectMake(XX_SCREEN_WIDTH-XX_ADJUST_SIZE(69+43), XX_ADJUST_SIZE(69), XX_ADJUST_SIZE(69), XX_ADJUST_SIZE(69));
        [reportButton setImage:[UIImage imageNamed:@"circle_list_report"] forState:UIControlStateNormal];
        [reportButton addTarget:self action:@selector(xx_clickReport) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.reportButton=reportButton];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerIV.right + XX_ADJUST_SIZE(29), XX_ADJUST_SIZE(46), reportButton.left-XX_ADJUST_SIZE(29*2)-headerIV.right, XX_ADJUST_SIZE(63))];
        nameLabel.font = XX_SYSTEM_FONT(46);
        nameLabel.textColor = UIColorFromString(@"222222");
        [self.contentView addSubview:self.nameLabel=nameLabel];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom + XX_ADJUST_SIZE(9), nameLabel.width, XX_ADJUST_SIZE(49))];
        timeLabel.font = XX_SYSTEM_FONT(35);
        timeLabel.textColor = UIColorFromString(@"AAAAAA");
        [self.contentView addSubview:self.timeLabel=timeLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), headerIV.bottom + XX_ADJUST_SIZE(46), XX_SCREEN_WIDTH-XX_ADJUST_SIZE(43*2), XX_ADJUST_SIZE(63))];
        contentLabel.numberOfLines = 0;
        contentLabel.font = XX_SYSTEM_FONT(40);
        contentLabel.textColor = UIColorFromString(@"222222");
        [self.contentView addSubview:self.contentLabel=contentLabel];
        
        //图片区
        CGFloat top = contentLabel.bottom + XX_ADJUST_SIZE(43);
        CGFloat imageSize = XX_ADJUST_SIZE(317);
        CGFloat gap = XX_ADJUST_SIZE(23);
        CGFloat leftGap = XX_ADJUST_SIZE(43);
        
        UIView *imageContainer = [[UIView alloc] initWithFrame:CGRectMake(leftGap, top, XX_SCREEN_WIDTH-leftGap*2, imageSize*2+gap)];
        [self.contentView addSubview:self.imageContainer=imageContainer];
        
        for (int i = 0; i < 6; i++) {
            {
                UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake((imageSize+gap) * (i%3), (imageSize+gap) * (i/3), imageSize, imageSize)];
                pic.tag = 1000+i;
                pic.userInteractionEnabled = YES;
                pic.contentMode = UIViewContentModeScaleAspectFill;
                pic.hidden = YES;
                pic.layer.masksToBounds = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xx_clickImage:)];
                [pic addGestureRecognizer:tap];
                [imageContainer addSubview:pic];
            }
        }
        
        top = self.imageContainer.bottom;
        
        //按钮区
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(XX_ADJUST_SIZE(8), top, XX_ADJUST_SIZE(139), XX_ADJUST_SIZE(139));
            [button setImage:[UIImage imageNamed:@"ll_circle_list_uncollect"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"ll_circle_list_collect"] forState:UIControlStateSelected];
            button.titleLabel.font = XX_SYSTEM_FONT(35);
            [button setTitle:@"0" forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromString(@"333333") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(xx_clickCollect) forControlEvents:UIControlEventTouchUpInside];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, XX_ADJUST_SIZE(-10), 0, 0);
            [self.contentView addSubview:self.collectButton=button];
        }
        
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(self.collectButton.right+XX_ADJUST_SIZE(89), top, XX_ADJUST_SIZE(139), XX_ADJUST_SIZE(139));
            [button setImage:[UIImage imageNamed:@"ll_circle_list_comment"] forState:UIControlStateNormal];
            button.titleLabel.font = XX_SYSTEM_FONT(35);
            [button setTitle:@"0" forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromString(@"333333") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(xx_clickComment) forControlEvents:UIControlEventTouchUpInside];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, XX_ADJUST_SIZE(-10), 0, 0);
            [self.contentView addSubview:self.commentButton=button];
        }
        
        top += XX_ADJUST_SIZE(139);
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), top-XX_LINE_SIZE, XX_SCREEN_WIDTH-XX_ADJUST_SIZE(43), XX_LINE_SIZE)];
        lineView.backgroundColor = UIColorFromString(@"EAEAEA");
        [self.contentView addSubview:self.lineView=lineView];
    }
    return self;
}

- (void)xx_clickHeader {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellClickHeader:)]) {
        [self.delegate cellClickHeader:self];
    }
}

- (void)xx_clickReport {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellClickReport:)]) {
        [self.delegate cellClickReport:self];
    }
}

- (void)xx_clickCollect {
    if (![LLUserManager isLogin]) {
        [LLUserManager ll_showLogin];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellClickCollect:)]) {
        [self.delegate cellClickCollect:self];
    }
}

- (void)xx_clickComment {
    if (![LLUserManager isLogin]) {
        [LLUserManager ll_showLogin];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellClickComment:)]) {
        [self.delegate cellClickComment:self];
    }
}

- (void)xx_clickImage:(UITapGestureRecognizer *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellClickImage:imageView:)]) {
        [self.delegate cellClickImage:self imageView:sender.view];
    }
}

- (UIImageView *)ll_imageViewForIndex:(NSInteger)index {
    return [self.imageContainer viewWithTag:1000+index];
}

- (void)ll_setInDetail {
    self.isInDetail = YES;
    self.reportButton.hidden = YES;
    self.lineView.hidden = YES;
}

- (void)setData:(LLCircleModel *)data {
    [self.headerIV xx_imageWithUrl:data.userIcon];
    self.nameLabel.text = data.userName;
    self.timeLabel.text = data.time;
    
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = XX_ADJUST_SIZE(10);
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:data.content attributes:@{
            NSFontAttributeName: XX_SYSTEM_FONT(46),
            NSParagraphStyleAttributeName: style,
        }];
        self.contentLabel.attributedText = attr;
    }
    self.contentLabel.height = data.xx_contentHeight;
    
    CGFloat top = self.contentLabel.bottom + XX_ADJUST_SIZE(43);
    
    //图片高度
    NSInteger imageCount = data.imageList.count;
    CGFloat imageHeight = 0;
    self.imageContainer.hidden = imageCount==0;
    self.imageContainer.top = top;
    if (imageCount == 0) {
        imageHeight = 0;
    } else if (imageCount == 1) {
        imageHeight = XX_ADJUST_SIZE(680-139);
    } else if (imageCount <= 3) {
        imageHeight = XX_ADJUST_SIZE(317);
    } else {
        imageHeight = XX_ADJUST_SIZE(317*2+23);
    }
    self.imageContainer.height = imageHeight;
    
    //处理6宫图
    CGFloat imageSize = XX_ADJUST_SIZE(317);
    CGFloat gap = XX_ADJUST_SIZE(23);
    
    for (int i = 0; i < 6; i++) {
        UIImageView *pic = [self.imageContainer viewWithTag:1000+i];
        if (i >= imageCount) {
            pic.hidden = YES;
            continue;
        }
        pic.hidden = NO;
        if (imageCount == 1) {
            pic.frame = CGRectMake(0, 0, imageHeight, imageHeight);
        } else {
            pic.frame = CGRectMake((imageSize+gap) * (i%3), (imageSize+gap) * (i/3), imageSize, imageSize);
        }
        [pic xx_imageWithUrl:data.imageList[i]];
    }
    
    top = self.imageContainer.bottom;
    self.commentButton.top = top;
    self.collectButton.top = top;
    
    top += XX_ADJUST_SIZE(139);
    self.lineView.top = top - XX_LINE_SIZE;
    
    self.collectButton.selected = data.isCollect;
    [self.collectButton setTitle:[NSString stringWithFormat:@"%d", (int)data.collectCount] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%d", (int)data.commentCount] forState:UIControlStateNormal];
    
}


@end
