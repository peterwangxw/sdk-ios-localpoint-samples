//
//  PWVerticalSegmentedControl.h
//  PWLocalpoint
//
//  Created by Alejandro Mendez on 4/21/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWVerticalSegmentedControlSegment : NSObject

@property (readonly,nonatomic) BOOL selected;
@property (readonly,nonatomic) NSString *title;

@end


IB_DESIGNABLE
@interface PWVerticalSegmentedControl : UIControl

@property (nonatomic) IBInspectable NSInteger numberOfSegments;
@property (readonly,nonatomic) NSArray* segments;
@property (nonatomic) IBInspectable BOOL collapsed;
@property (nonatomic) IBInspectable BOOL collapsable;
@property (nonatomic) IBInspectable BOOL expandDown;
@property (nonatomic) NSInteger itemHeight;

- (void)addSegmentWithTitle:(NSString*)title;
- (void)addSegmentWithTitle:(NSString*)title selected:(BOOL)selected;

@end
