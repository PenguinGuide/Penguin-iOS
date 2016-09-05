//
//  PGPopover.m
//  Penguin
//
//  Created by Jing Dai on 9/1/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define PopoverCell @"PopoverCell"

#import "PGPopover.h"
#import "PGPopoverItem.h"

@interface PGPopoverCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;

- (void)setCellWithItem:(PGPopoverItem *)item;

@end

@implementation PGPopoverCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.label];
}

- (void)setCellWithItem:(PGPopoverItem *)item
{
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    if (item.selected) {
        attachment.image = [UIImage imageNamed:item.highlightIcon];
    } else {
        attachment.image = [UIImage imageNamed:item.icon];
    }
    attachment.bounds = CGRectMake(5, -1, attachment.image.size.width, attachment.image.size.height);
    
    NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:item.title];
    [attrS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:NSMakeRange(0, item.title.length)];
    if (item.selected) {
        [attrS addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:239.f/256.f green:103.f/256.f blue:51.f/256.f alpha:1.f] range:NSMakeRange(0, item.title.length)];
    } else {
        [attrS addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:175.f/256.f green:175.f/256.f blue:175.f/256.f alpha:1.f] range:NSMakeRange(0, item.title.length)];
    }
    
    NSAttributedString *attachmentStr = [NSAttributedString attributedStringWithAttachment:attachment];
    [attrS appendAttributedString:attachmentStr];
    
    self.label.attributedText = attrS;
}

@end

@interface PGPopoverArrow : UIView

@end

@implementation PGPopoverArrow

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.f);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y+rect.size.height);
    CGContextAddLineToPoint(context, rect.origin.x+rect.size.width/2, rect.origin.y);
    CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end

@interface PGPopover () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UITableView *popoverTableView;
@property (nonatomic, strong) PGPopoverArrow *arrowView;
@property (nonatomic, assign) CGFloat itemHeight;

@end

@implementation PGPopover

+ (PGPopover *)popoverWithItems:(NSArray *)items itemHeight:(CGFloat)itemHeight
{
    PGPopover *popover = [[PGPopover alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    popover.items = items;
    popover.itemHeight = itemHeight;
    
    popover.popoverTableView.frame = CGRectMake(0, 0, 160, itemHeight*items.count);
    
    return popover;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.popoverTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 160, 0) style:UITableViewStylePlain];
        self.popoverTableView.clipsToBounds = YES;
        self.popoverTableView.layer.cornerRadius = 4.f;
        self.popoverTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.popoverTableView.dataSource = self;
        self.popoverTableView.delegate = self;
        self.popoverTableView.bounces = NO;
        
        [self.popoverTableView registerClass:[PGPopoverCell class] forCellReuseIdentifier:PopoverCell];
        
        self.arrowView = [[PGPopoverArrow alloc] initWithFrame:CGRectMake(0, 0, 12, 10)];
        self.arrowView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.arrowView];
        [self insertSubview:self.popoverTableView aboveSubview:self.arrowView];
        
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)showPopoverFromView:(UIView *)view
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    CGRect viewRect = [view convertRect:view.bounds toView:keyWindow];
    
    CGRect frame = self.popoverTableView.frame;
    frame = CGRectMake(viewRect.origin.x-frame.size.width/2, viewRect.origin.y+viewRect.size.height+5+5, frame.size.width, frame.size.height);
    if (frame.origin.x < 10) {
        frame = CGRectMake(10, frame.origin.y, frame.size.width, frame.size.height);
    } else if (frame.origin.x+frame.size.width > [UIScreen mainScreen].bounds.size.width-10) {
        frame = CGRectMake([UIScreen mainScreen].bounds.size.width-10-frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
    }
    self.popoverTableView.frame = frame;
    self.arrowView.frame = CGRectMake(viewRect.origin.x, viewRect.origin.y+viewRect.size.height+5, self.arrowView.frame.size.width, self.arrowView.frame.size.height);
    
    [self.popoverTableView reloadData];
    [keyWindow addSubview:self];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGPopoverCell *cell = [tableView dequeueReusableCellWithIdentifier:PopoverCell];
    
    if (cell == nil) {
        cell = [[PGPopoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PopoverCell];
    }
    
    [cell setCellWithItem:self.items[indexPath.row]];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemDidSelect:)]) {
        [self.delegate itemDidSelect:indexPath.row];
    }
    
    [self removeFromSuperview];
}

- (void)viewTapped
{
    [self removeFromSuperview];
}

@end
