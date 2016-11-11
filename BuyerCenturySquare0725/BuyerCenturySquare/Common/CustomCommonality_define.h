//
//  CustomCommonality_define.h
//  BuyerCenter
//
//  Created by 陈光 on 15/10/17.
//  Copyright © 2015年 左键视觉. All rights reserved.
//
/**
 *  自定义公用属性
 */

#ifndef CustomCommonality_define_h
#define CustomCommonality_define_h


//日志输出宏定义
#ifdef DEBUG
// 调试状态
#define MyLog(...) NSLog(__VA_ARGS__)
#else
// 发布状态
#define MyLog(...)

#endif



#endif /* CustomCommonality_define_h */
