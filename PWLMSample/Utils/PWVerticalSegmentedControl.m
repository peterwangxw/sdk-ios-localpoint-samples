//
//  PWVerticalSegmentedControl.m
//  PWLocalpoint
//
//  Created by Alejandro Mendez on 4/21/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import "PWVerticalSegmentedControl.h"

#define PWSegmentedControlBlue [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]

#pragma mark - PWVerticalSegmentedControlSegment

@interface PWVerticalSegmentedControlSegment()

@property (nonatomic) BOOL selected;
@property (nonatomic) NSString *title;

- (instancetype)initWithTitle:(NSString*)title;
- (instancetype)initWithTitle:(NSString*)title selected:(BOOL)selected;

@end

@implementation PWVerticalSegmentedControlSegment

- (instancetype)initWithTitle:(NSString*)title
{
    return [self initWithTitle:title selected:NO];
}

- (instancetype)initWithTitle:(NSString*)title selected:(BOOL)selected
{
    if(self = [super init])
    {
        _title = title;
    }
    return self;
}
@end

#pragma mark - PWSegmentControlButton

typedef NS_ENUM(NSUInteger, PWSegmentControlButtonPosition)
{
    PWSegmentControlButtonPositionMiddle,
    PWSegmentControlButtonPositionTop,
    PWSegmentControlButtonPositionBottom,
    PWSegmentControlButtonPositionSingleItem
};

IB_DESIGNABLE
@interface PWSegmentControlButton : UIButton

@property (nonatomic) PWSegmentControlButtonPosition position;
@property double cornerRadius;
@property UIBezierPath *mainButtonPath;
@property PWVerticalSegmentedControlSegment *segment;

@end

@implementation PWSegmentControlButton

- (UIBezierPath*)bezierWithRect:(CGRect)pathFrame
{
    UIBezierPath *path;
    if (self.position==PWSegmentControlButtonPositionTop)
    {
        path = [UIBezierPath bezierPathWithRoundedRect:pathFrame byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
    }
    else if (self.position==PWSegmentControlButtonPositionBottom)
    {
        path = [UIBezierPath bezierPathWithRoundedRect:pathFrame byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
    }
    else if (self.position==PWSegmentControlButtonPositionSingleItem)
    {
        path = [UIBezierPath bezierPathWithRoundedRect:pathFrame byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
    }
    else
    {
        path = [UIBezierPath bezierPathWithRect:pathFrame];
    }
    return path;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 20);
    [PWSegmentedControlBlue set];
    
    CGRect bounds = [self bounds];
    CGRect pathFrame = CGRectInset(bounds, 1, 1);
    CGRect fillPath = CGRectInset(pathFrame, 1, 1);
    
    UIBezierPath *path = [self bezierWithRect:pathFrame];
    UIBezierPath *internalFillPath = [self bezierWithRect:fillPath];
    
    self.mainButtonPath = path;
    [path stroke];
    
    if (self.segment.selected)
    {
        [path fill];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [[UIColor whiteColor] set];
        [internalFillPath fill];
        [self setTitleColor:PWSegmentedControlBlue forState:UIControlStateNormal];
    }
}

@end


#pragma mark - PWSegmentControlCollapseButton

IB_DESIGNABLE
@interface PWSegmentControlCollapseButton : PWSegmentControlButton

@property (nonatomic) BOOL arrowDown;

@end

@implementation PWSegmentControlCollapseButton

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [PWSegmentedControlBlue set];
    [self.mainButtonPath fill];
    
    CGRect bounds = [self bounds];
    
    [[UIColor whiteColor] set];
    UIBezierPath *path = [UIBezierPath bezierPath];
    double midY = CGRectGetMidY(bounds);
    double midX = CGRectGetMidX(bounds);
    double arrowWidth = 40;
    double arrowHeight = 16;
    path.lineWidth = 4;
    if (self.arrowDown) {
        [path moveToPoint:CGPointMake(midX-arrowWidth/2,midY-arrowHeight/2)];
        [path addLineToPoint:CGPointMake(midX,midY+arrowHeight/2)];
        [path addLineToPoint:CGPointMake(midX+arrowWidth/2,midY-arrowHeight/2)];
    }else{
        [path moveToPoint:CGPointMake(midX-arrowWidth/2,midY+arrowHeight/2)];
        [path addLineToPoint:CGPointMake(midX,midY-arrowHeight/2)];
        [path addLineToPoint:CGPointMake(midX+arrowWidth/2,midY+arrowHeight/2)];
    }
    [path stroke];
}

@end


#pragma mark - PWVerticalSegmentedControl

@interface PWVerticalSegmentedControl()

@property double cornerRadius;
@property (nonatomic) NSArray* buttons;
@property (nonatomic) NSArray* segments;
@property PWSegmentControlCollapseButton *collapseButton;
@property (nonatomic) NSArray* animatableConstraints;
@property (nonatomic) NSLayoutConstraint *heightContraint;

@end

@implementation PWVerticalSegmentedControl


- (instancetype)init
{
    if (self = [super init]) {
        [self internalInitialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self internalInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self internalInitialize];
    }
    return self;
}

#pragma mark - Public methods

- (void)addSegmentWithTitle:(NSString*)title selected:(BOOL)selected
{
    NSMutableArray *segments =  @[].mutableCopy;
    [segments addObjectsFromArray:self.segments];
    [segments addObject:[[PWVerticalSegmentedControlSegment alloc] initWithTitle:title selected:selected]];
    
    self.segments = segments.copy;
    self.numberOfSegments++;
}

-(void)addSegmentWithTitle:(NSString *)title
{
    [self addSegmentWithTitle:title selected:NO];
}

#pragma mark - Private methods

- (void)internalInitialize
{
    self.clipsToBounds = NO;
    _numberOfSegments = 0;
    _cornerRadius = 5;
    _itemHeight = 30;
    _collapsable = YES;
    [self buildButtons];
    
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIButton *button in  self.buttons) {
        CGRect expandedFrame = CGRectInset(button.frame, -4, -4);
        if (CGRectContainsPoint(expandedFrame, point)) {
            return YES;
        }
    }
    return [super pointInside:point withEvent:event];
}

- (void)buildButtons
{
    NSMutableArray *newSegments = @[].mutableCopy;
    
    for (int i = 0;i<self.numberOfSegments;i++)
    {
        if (self.segments.count<=i) {
            [newSegments addObject:[[PWVerticalSegmentedControlSegment alloc] initWithTitle:[NSString stringWithFormat:@"%d",i+1]]];
        }else{
            [newSegments addObject:[self.segments objectAtIndex:i]];
        }
    }
    self.segments = newSegments.copy;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    NSMutableArray *buttons = @[].mutableCopy;
    for (PWVerticalSegmentedControlSegment * segment in self.segments)
    {
        PWSegmentControlButton *button = [PWSegmentControlButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:segment.title forState:UIControlStateNormal];
        [self addSubview:button];
        button.backgroundColor = [UIColor clearColor];
        button.alpha = self.collapsed?0:1;
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.cornerRadius = self.cornerRadius;
        [buttons addObject:button];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        button.segment = segment;
    }
    
    if (self.collapsable)
    {
        PWSegmentControlCollapseButton *button = [PWSegmentControlCollapseButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        button.backgroundColor = [UIColor clearColor];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.cornerRadius = self.cornerRadius;
        [buttons addObject:button];
        self.collapseButton = button;
        if (!self.expandDown) {
            self.collapseButton.arrowDown = !self.collapsed;
        }
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    }else{
        self.collapseButton = nil;
    }
    self.buttons = buttons;
    
    [self refreshButtonsConstraints:buttons];
    
    [self updateConstraints];
    [self layoutSubviews];
}

- (void)refreshButtonsConstraints:(NSArray*)buttonArray
{
    UIView *prevView = nil;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0 constant:self.itemHeight]];
    
    NSMutableArray *animatableConstraints = @[].mutableCopy;
    for (PWSegmentControlButton *button in buttonArray) {
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:self.itemHeight]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        
        if ([button isEqual:[buttonArray firstObject]])
        {
            button.position = PWSegmentControlButtonPositionTop;
            if (self.expandDown)
            {
                [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
            }
        }else if ([button isEqual:[buttonArray lastObject]])
        {
            button.position = PWSegmentControlButtonPositionBottom;
            if (!self.expandDown)
            {
                [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
            }
        }
        
        if (prevView)
        {
            double constant = self.collapsed?self.itemHeight:0;
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:prevView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTop multiplier:1 constant:constant];
            [self addConstraint:constraint];
            [animatableConstraints addObject:constraint];
            
            
        }
        prevView = button;
    }
    if (self.collapsed) {
        self.collapseButton.position = PWSegmentControlButtonPositionSingleItem;
    }
    self.animatableConstraints = animatableConstraints.copy;
}

- (void)buttonPressed:(PWSegmentControlButton*)button
{
    if ([button isEqual:self.collapseButton])
    {
        self.collapsed = !self.collapsed;
    }else
    {
        button.segment.selected = !button.segment.selected;
        [button setNeedsDisplay];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
}

- (void)onCollapsedStatusChange
{
    if (self.expandDown) {
        self.collapseButton.arrowDown = self.collapsed;
    }else{
        self.collapseButton.arrowDown = !self.collapsed;
    }
    
    if (self.collapsed) {
        self.collapseButton.position = PWSegmentControlButtonPositionSingleItem;
    }else{
        self.collapseButton.position = PWSegmentControlButtonPositionBottom;
        
    }
    [self.collapseButton setNeedsDisplay];
    
    
    [UIView animateWithDuration:0.2f animations:^{
        for (NSLayoutConstraint *constraint in self.animatableConstraints)
        {
            constraint.constant = self.collapsed?self.itemHeight:0;
        }
        [self layoutIfNeeded];
        for (PWSegmentControlButton *button in self.buttons) {
            if (![button isEqual:[self.buttons lastObject]]) {
                button.alpha = self.collapsed?0:1;
            }
        }
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Overriding properties

-(void)setExpandDown:(BOOL)expandDown
{
    [self willChangeValueForKey:@"expandDown"];
    _expandDown = expandDown;
    [self didChangeValueForKey:@"expandDown"];
    [self buildButtons];
}

-(void)setItemHeight:(NSInteger)itemHeight
{
    [self willChangeValueForKey:@"itemHeight"];
    _itemHeight = itemHeight;
    [self didChangeValueForKey:@"itemHeight"];
    [self buildButtons];
}

-(void)setCollapsable:(BOOL)collapsable
{
    [self willChangeValueForKey:@"collapsable"];
    _collapsable = collapsable;
    [self didChangeValueForKey:@"collapsable"];
    [self buildButtons];
}

-(void)setCollapsed:(BOOL)collapsed
{
    [self willChangeValueForKey:@"collapsed"];
    _collapsed = collapsed;
    [self didChangeValueForKey:@"collapsed"];
    
    [self onCollapsedStatusChange];
}


-(void)setNumberOfSegments:(NSInteger)numberOfSegments
{
    [self willChangeValueForKey:@"numberOfSegments"];
    _numberOfSegments = numberOfSegments;
    [self didChangeValueForKey:@"numberOfSegments"];
    [self buildButtons];
}


@end



