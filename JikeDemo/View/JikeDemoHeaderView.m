//
//  JikeDemoHeaderView.m
//  JikeDemo
//
//  Created by Lin Wei on 4/28/16.
//  Copyright © 2016 linw. All rights reserved.
//

#import "JikeDemoHeaderView.h"

@interface JikeDemoHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundViewBelow;
@property (weak, nonatomic) IBOutlet UIView *backgroundViewBeyond;
@property (weak, nonatomic) IBOutlet UIView *button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTop;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgVIewBeyondHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBeyondTop;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bvViewBelowHeightP;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;

@property (nonatomic, assign) CGFloat initImageViewHeight;
@property (nonatomic, assign) CGFloat initImageViewWidth;
@property (nonatomic, assign) CGFloat initImageViewTopDistance;
@property (nonatomic, assign) CGFloat initImageViewBottomDistance;
@property (nonatomic, assign) CGFloat initBgViewBeyondHeight;
@property (nonatomic, assign) CGFloat initLabelTopHeight;
@property (nonatomic, assign) CGFloat initLabelBottmHeight;
@property (nonatomic, assign) CGFloat initButtonBottomHeight;
@property (nonatomic, assign) CGFloat initButtonHeight;


@property (nonatomic, assign) CGFloat topConstant;
@property (nonatomic, assign) CGFloat bottomConstant;

@property (nonatomic, assign) CGFloat offsetY;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation JikeDemoHeaderView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _isFirst = false;
        self.clipsToBounds = true;
        _offsetY = 0.0;
        
    }
    return self;
}

- (void)updateConstraints {
    
    self.clipsToBounds = true;
    
    CGFloat offsetY = _offsetY;
    if (!_isFirst) {
        _initImageViewWidth = _imageViewWidth.constant;
        _initImageViewHeight = _imageViewHeight.constant;
        _initImageViewTopDistance = _imageViewTop.constant;
        
        _initBgViewBeyondHeight = _bgVIewBeyondHeight.constant;
        
        _initLabelTopHeight = _labelTop.constant;
        _initLabelBottmHeight = _labelBottom.constant;
        _initButtonBottomHeight = _buttonBottom.constant;
        
        _initButtonHeight = _buttonHeight.constant;
        _isFirst = true;
        
        CALayer *layer = _imageView.layer;
        layer.cornerRadius = 5.0f;
        layer.masksToBounds = true;
    }
    
    if (offsetY >= 0.0 && offsetY < 8) {
        [self bringSubviewToFront:_imageView];
        [self viewInitStatus];
    } else if (offsetY > 8 && offsetY < 72) {
        //图片变小 距离不变 下方背景缩小
        [self bringSubviewToFront:_imageView];
        
        //中间imageview与顶部距离不变，图片等比例缩小
        CGFloat fraction = (1.0 - (offsetY - 8.0) / 192.0);
        _imageViewWidth.constant = fraction * _initImageViewWidth;
        _imageViewHeight.constant = fraction * _initImageViewHeight;
        
        _imageViewTop.constant = _initImageViewTopDistance + offsetY - 8;
        
        _labelTop.constant = _initLabelTopHeight;
        
        /*old
        if (offsetY < (8 + _initLabelBottmHeight)) {
            _button.hidden = false;
            _labelBottom.constant = _initLabelBottmHeight * (1.0 - (offsetY - 8.0) / (_initLabelBottmHeight));
        } else if (offsetY < (8 + _initLabelBottmHeight + _initButtonHeight)) {
            _button.hidden = true;
            _labelBottom.constant = 0.5;
            _buttonHeight.constant = (1.0 - (offsetY - 8.0 - _initLabelBottmHeight) / _initButtonHeight) * _initButtonHeight;
        } else {
            _buttonHeight.constant = 0;
            CGFloat fixedH = 8.0 + _initLabelBottmHeight + _initButtonHeight;
            _buttonBottom.constant = (1.0 - (offsetY - fixedH) / _initButtonBottomHeight) * _initButtonBottomHeight;
        }
        */
        if (offsetY < (8 + 8)) {
            _button.hidden = false;
            _labelBottom.constant = _initLabelBottmHeight * (1.0 - (offsetY - 8.0) / (_initLabelBottmHeight));
        } else if (offsetY < (8 + 8 + _initButtonHeight)) {
            _button.hidden = true;
            _labelBottom.constant = 16;
            _buttonHeight.constant = (1.0 - (offsetY - 8.0 - 8.0) / _initButtonHeight) * _initButtonHeight;
        } else {
            CGFloat fraction = 1.0 - (offsetY - 40) / _initLabelTopHeight;
            _labelTop.constant = fraction * _initLabelTopHeight;
        }

    } else if(offsetY >= 72 && offsetY < 120) {
        
        _imageViewTop.constant = _initImageViewTopDistance + offsetY - 8;
        
        _imageViewWidth.constant = 0.666  * _initImageViewWidth;
        _imageViewHeight.constant = 0.666 * _initImageViewHeight;
        
        
        _labelBottom.constant = 16.0;
//        _buttonBottom.constant = 0.0;
        _buttonHeight.constant = 0.0;
        _labelTop.constant = 0.0;
        
        [self insertSubview:_imageView belowSubview:_backgroundViewBelow];
        
    } else if(offsetY >= 120 && offsetY < 184) {
        
        _imageViewWidth.constant = 0.666  * _initImageViewWidth;
        _imageViewHeight.constant = 0.666 * _initImageViewHeight;
        
        _labelBottom.constant = 16.0;
//        _buttonBottom.constant = 0.0;
        _buttonHeight.constant = 0.0;
        
        _imageViewTop.constant = _initImageViewTopDistance + offsetY - 8;
        
    } else if (offsetY > 184 && offsetY < 300) {
        
        _imageViewWidth.constant = 0.666  * _initImageViewWidth;
        _imageViewHeight.constant = 0.666 * _initImageViewHeight;
        
//        _labelBottom.constant = 16.0;
//        _buttonBottom.constant = 0.0;
        _buttonHeight.constant = 0.0;
        
        /* old
        if (offsetY > 184 && offsetY < 248) {
            CGFloat fraction = 1.0 - (offsetY - 184.0) / _initLabelTopHeight;
            _labelTop.constant = fraction * _initLabelTopHeight;
            _imageView.alpha = fraction / 2.0;
        } else if (offsetY < 300) {
            
        }
        */
        if (offsetY < 200) {
            _labelBottom.constant = (1- (offsetY - 184.0) / 16.0) * 16.0;
        } else if (offsetY > 200 && offsetY < 248) {
            CGFloat fraction = 1.0 - (offsetY - 200.0) / _initButtonBottomHeight;
            _buttonBottom.constant = fraction * _initButtonBottomHeight;
        }
        
        _imageViewTop.constant = _initImageViewTopDistance + offsetY - 8;
    } else if(offsetY < 0) {
        if (offsetY > -150) {
            //when offsetY is negative, exteng the view
            self.clipsToBounds = false;

            _bgViewBeyondTop.constant = offsetY;
            _bgVIewBeyondHeight.constant = _initBgViewBeyondHeight - offsetY;
            [self viewInitStatus];
            
        }
    }

    
    [super updateConstraints];
}

- (void)viewInitStatus {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _button.hidden = false;

                         _imageViewWidth.constant = _initImageViewWidth;
                         _imageViewHeight.constant = _initImageViewHeight;
                         
                         _labelBottom.constant = _initLabelBottmHeight;
                         _buttonBottom.constant = _initButtonBottomHeight;
                         _buttonHeight.constant = _initButtonHeight;
                         
                         _labelTop.constant = _initLabelTopHeight;
                         
//                         _imageViewTop.constant = _initImageViewTopDistance;
                         _imageView.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)jk_tableviewDidScrollToContentOffsetY:(CGFloat)offsetY {
    NSLog(@"%f", offsetY);
    _offsetY = offsetY;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (CGFloat)jk_tableviewShowNavigationBar {
    return self.bounds.size.height - 96;
}
- (NSString *)jk_tableViewTitle {
    return @"职人介绍所";
}

@end
