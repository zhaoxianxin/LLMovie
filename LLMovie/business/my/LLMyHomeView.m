//
//  LLMyHomeView.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/15.
//

#import "LLMyHomeView.h"
#import "LLUserModel.h"
#import "LLMyHomeFunCell.h"

@interface LLMyHomeView() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *funcList;
@property (nonatomic, strong) LLUserModel *userModel;
//信息
@property (nonatomic, strong) UIImageView *headIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UILabel *praiseLabel;
@property (nonatomic, strong) UIImageView *priseIV;
@end

@implementation LLMyHomeView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.funcList = [NSMutableArray array];
        self.backgroundColor = [UIColor yellowColor];
        
        [self.funcList addObjectsFromArray:@[
            @{
                @"title":@"我的动态",
                @"routing":@"xx://my_circle_list"
            },
            @{
                @"title":@"我的想看",
                @"routing":@"xx://my_movie_will"
            },
            @{
                @"title":@"关于我们",
                @"routing":@"xx://my_aboutus"
            },
            @{
                @"title":@"设置",
                @"routing":@"xx://my_setting"
            },@{
                @"title":@"消息",
                @"routing":@"xx://my_messages"
            },
        ]];
        
        LLUserModel *userModel = [[LLUserModel alloc] init];
        userModel.userId = [LLUserManager loginUserId];
        userModel.userName = [LLUserManager loginUserName];
        userModel.userIcon = [LLUserManager loginImage];
        userModel.praiseCount = [LLUserManager isLogin] ? 3 : 0;
        self.userModel = userModel;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        tableView.tableHeaderView = [self ll_createHeaderView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView=tableView];
        
    }
    return self;
}

- (UITableView *)ll_tableView {
    return self.tableView;
}

- (void)ll_update {
    self.userModel.userName = [LLUserManager loginUserName];
    self.userModel.userIcon = [LLUserManager loginImage];
    self.nameLabel.text = self.userModel.userName;
    self.idLabel.text = [NSString stringWithFormat:@"%@", self.userModel.userId];
    self.praiseLabel.attributedText = [self xx_praiseAttr];
    [self.praiseLabel sizeToFit];
    self.praiseLabel.centerX = self.priseIV.centerX;
    
    if ([LLUserManager isLogin]) {
        [self.headIV xx_imageWithUrl:self.userModel.userIcon];
    } else {
        [self.headIV xx_imageWithWithColor:UIColorFromString(@"F5F5F5")];
    }
}

- (UIView *)ll_createHeaderView {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, XX_ADJUST_SIZE(179+323+6))];
    
    //背景
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, header.width, XX_ADJUST_SIZE(389))];
    backImageView.image = [UIImage imageNamed:@"ll_my_header_top"];
    [header addSubview:backImageView];
    
    //白框
    UIImageView *infoBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, XX_ADJUST_SIZE(179), header.width, XX_ADJUST_SIZE(323))];
    infoBack.image = [UIImage imageNamed:@"ll_my_header_center"];
    infoBack.userInteractionEnabled = YES;
    [header addSubview:infoBack];
    
    {
        UIImageView *headIV = [[UIImageView alloc] initWithFrame:CGRectMake(XX_ADJUST_SIZE(101), XX_ADJUST_SIZE(75), XX_ADJUST_SIZE(161), XX_ADJUST_SIZE(161))];
        headIV.layer.cornerRadius = headIV.height / 2;
        headIV.userInteractionEnabled = YES;
        headIV.layer.masksToBounds = YES;
        if ([LLUserManager isLogin]) {
            [headIV xx_imageWithUrl:self.userModel.userIcon];
        } else {
            [headIV xx_imageWithWithColor:UIColorFromString(@"F5F5F5")];
        }
        [infoBack addSubview:self.headIV=headIV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xx_tapUserHeader)];
        [headIV addGestureRecognizer:tap];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headIV.right + XX_ADJUST_SIZE(29), XX_ADJUST_SIZE(89), infoBack.width-headIV.right + XX_ADJUST_SIZE(245+29), XX_ADJUST_SIZE(72))];
        nameLabel.font = XX_SYSTEM_FONT(52);
        nameLabel.textColor = UIColorFromString(@"222222");
        nameLabel.text = self.userModel.userName;
        [infoBack addSubview:self.nameLabel=nameLabel];
        
        UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom + XX_ADJUST_SIZE(14), XX_ADJUST_SIZE(220), XX_ADJUST_SIZE(49))];
        idLabel.font = XX_SYSTEM_FONT(35);
        idLabel.textColor = UIColorFromString(@"979AA1");
        idLabel.text = [NSString stringWithFormat:@"%@",  self.userModel.userId];
        [infoBack addSubview:self.idLabel=idLabel];
        
        //点赞
        UIImageView *priseIV = [[UIImageView alloc] initWithFrame:CGRectMake(infoBack.width-XX_ADJUST_SIZE(130+86), XX_ADJUST_SIZE(81), XX_ADJUST_SIZE(75), XX_ADJUST_SIZE(75))];
        priseIV.image = [UIImage imageNamed:@"ll_my_prise_icon"];
        [infoBack addSubview:self.priseIV=priseIV];
        
        UILabel *praiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, priseIV.bottom + XX_ADJUST_SIZE(12), 0, XX_ADJUST_SIZE(72))];
        praiseLabel.font = XX_SYSTEM_FONT(35);
        praiseLabel.textColor = UIColorFromString(@"222222");
        praiseLabel.textAlignment = NSTextAlignmentRight;
        praiseLabel.attributedText = [self xx_praiseAttr];
        [praiseLabel sizeToFit];
        praiseLabel.centerX = priseIV.centerX;
        [infoBack addSubview:self.praiseLabel=praiseLabel];
        
    }
    
    return header;
}


- (NSAttributedString *)xx_praiseAttr {
    NSString *countStr = [NSString stringWithFormat:@"%d", (int)self.userModel.praiseCount];
    NSString *string = [NSString stringWithFormat:@"收到%@个赞", countStr];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attr addAttributes:@{
        NSFontAttributeName: XX_SYSTEM_FONT(52),
    } range:[string rangeOfString:countStr]];
    
    return attr;
}

- (void)xx_tapUserHeader {
    if (![LLUserManager isLogin]) {
        [LLUserManager ll_showLogin];
        return;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return XX_ADJUST_SIZE(138);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.funcList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLMyHomeFunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLMyHomeFunCell"];
    if (!cell) {
        cell = [[LLMyHomeFunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLMyHomeFunCell"];
    }
    NSDictionary *funcDict = self.funcList[indexPath.row];
    cell.titleLabel.text = funcDict[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *funcDict = self.funcList[indexPath.row];
    NSString *routing = funcDict[@"routing"];
    
    if (![routing isEqualToString:@"xx://my_aboutus"] && ![LLUserManager isLogin]) {
        [LLUserManager ll_showLogin];
        return;
    }
    
    [[LLRouterManager shareInstance] ll_routeUrl:routing obj:nil];
}


@end
