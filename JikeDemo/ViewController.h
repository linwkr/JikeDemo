//
//  ViewController.h
//  JikeDemo
//
//  Created by Lin Wei on 4/28/16.
//  Copyright © 2016 linw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKTableViewDidScrollProtocol <NSObject>
- (void) jk_tableviewDidScrollToContentOffsetY:(CGFloat)offsetY;
- (CGFloat) jk_tableviewShowNavigationBar;
- (NSString *) jk_tableViewTitle;
@end

@interface ViewController : UIViewController

@end

