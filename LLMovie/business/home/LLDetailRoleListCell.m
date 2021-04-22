//
//  LLDetailRoleListCell.m
//  LLMovie
//
//  Created by xin xian on 2021/3/23.
//

#import "LLDetailRoleListCell.h"

@interface LLDetailRoleView : UIView
@property (nonatomic, strong) UIImageView *headIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *subLabel;
@end

@implementation LLDetailRoleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *headIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, XX_ADJUST_SIZE(291))];
        headIV.layer.cornerRadius = XX_ADJUST_SIZE(23);
        headIV.layer.masksToBounds = YES;
        headIV.backgroundColor = UIColorFromString(@"A2A2A2");
        [self addSubview:self.headIV=headIV];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headIV.bottom+XX_ADJUST_SIZE(12), self.width, XX_ADJUST_SIZE(58))];
        nameLabel.font = XX_SYSTEM_FONT(40);
        nameLabel.textColor = UIColorFromString(@"222222");
        [self addSubview:self.nameLabel=nameLabel];
        
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.bottom+XX_ADJUST_SIZE(6), self.width, XX_ADJUST_SIZE(46))];
        subLabel.font = XX_SYSTEM_FONT(32);
        subLabel.textColor = UIColorFromString(@"AAAAAA");
        [self addSubview:self.subLabel=subLabel];
        
    }
    return self;
}

- (void)setData:(LLMovieRoleModel *)data {
    [self.headIV xx_imageWithUrl:data.userIcon];
    self.nameLabel.text = data.userName;
    self.subLabel.text = data.roleName;
}

@end

@interface LLDetailRoleListCell()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray <LLDetailRoleView *> *roleViewList;
@end

@implementation LLDetailRoleListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.roleViewList = [NSMutableArray array];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(43), XX_ADJUST_SIZE(43), XX_SCREEN_WIDTH-XX_ADJUST_SIZE(43+29), XX_ADJUST_SIZE(498-43*2))];
        scrollView.contentSize = scrollView.size;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:self.scrollView=scrollView];
    }
    return self;
}

- (void)setData:(NSArray <LLMovieRoleModel *> *)dataList {
    CGSize itemSize = CGSizeMake(XX_ADJUST_SIZE(230), XX_ADJUST_SIZE(498-43*2));
    CGFloat gap = XX_ADJUST_SIZE(29);
    
    for (LLDetailRoleView *view in self.roleViewList) {
        [view removeFromSuperview];
    }
    [self.roleViewList removeAllObjects];
    
    for (int i = 0; i < dataList.count; i++) {
        LLMovieRoleModel *model = dataList[i];
        
        LLDetailRoleView *view = [[LLDetailRoleView alloc] initWithFrame:CGRectMake((itemSize.width+gap)*i, 0, itemSize.width, itemSize.height)];
        view.tag = 1000+i;
        [view setData:model];
        
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ll_tapRole:)];
            [view addGestureRecognizer:tap];
        }
        
        [self.scrollView addSubview:view];
        [self.roleViewList addObject:view];
    }
    
    self.scrollView.contentSize = CGSizeMake((itemSize.width+gap)*dataList.count-gap, self.scrollView.height);
}

- (void)ll_tapRole:(UITapGestureRecognizer *)sender {
    NSInteger index = sender.view.tag - 1000;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didClickRoleAtIndex:)]) {
        [self.delegate cell:self didClickRoleAtIndex:index];
    }
}

- (UIImageView *)ll_roleImageViewForIndex:(NSInteger)index {
    return (UIImageView *)[self.scrollView viewWithTag:1000+index];
}

@end
