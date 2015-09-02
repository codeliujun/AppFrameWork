//
//  ZHOrderObj.h
//  LIUAppFramework
//
//  Created by liujun on 15/9/2.
//  Copyright (c) 2015年 liujun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Imageurls;

@interface ZHOrderObj : NSObject


@property (nonatomic, assign) NSInteger IndexId;

@property (nonatomic, copy) NSString *BrandName;

@property (nonatomic, copy) NSString *BrandId;

@property (nonatomic, copy) NSString *StatusName;

@property (nonatomic, assign) NSInteger Resell_Price;

@property (nonatomic, assign) NSInteger PackNum;

@property (nonatomic, copy) NSString *Supplier2Id;

@property (nonatomic, assign) NSInteger Join_Price;

@property (nonatomic, copy) NSString *Unit;

@property (nonatomic, assign) NSInteger DisplayOrder;

@property (nonatomic, assign) NSInteger MinimumPurchaseAmount;

@property (nonatomic, assign) NSInteger TotalNum;

@property (nonatomic, assign) NSInteger InRoadNum;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *BarCode;

@property (nonatomic, copy) NSString *Warehouses;

@property (nonatomic, assign) NSInteger RealTimePrice;

@property (nonatomic, copy) NSString *Code;

@property (nonatomic, copy) NSString *NameSpecification;

@property (nonatomic, copy) NSString *Supplier3Id;

@property (nonatomic, copy) NSString *Model;

@property (nonatomic, copy) NSString *Content;

@property (nonatomic, assign) NSInteger Status;

@property (nonatomic, copy) NSString *Specification;

@property (nonatomic, copy) NSString *ThumbUrl;

@property (nonatomic, assign) NSInteger SafetyStock;

@property (nonatomic, copy) NSString *SupplierName;

@property (nonatomic, assign) NSInteger Hits;

@property (nonatomic, copy) NSString *Intro;

@property (nonatomic, assign) NSInteger Sell_Number;

@property (nonatomic, copy) NSString *CreateTime;

@property (nonatomic, copy) NSString *UnitStr;

@property (nonatomic, assign) NSInteger InstoreNumber;

@property (nonatomic, assign) NSInteger RealTimeNum;

@property (nonatomic, assign) BOOL IsHot;

@property (nonatomic, copy) NSString *ValidDate;

@property (nonatomic, assign) BOOL IsRecommend;

@property (nonatomic, assign) BOOL IsGroup;

@property (nonatomic, copy) NSString *ThumbFileId;

@property (nonatomic, assign) BOOL IsComment;

@property (nonatomic, copy) NSString *CategoryName;

@property (nonatomic, copy) NSString *SubName;

@property (nonatomic, copy) NSString *SEODescription;

@property (nonatomic, assign) CGFloat Member_Price;

@property (nonatomic, copy) NSString *SEOName;

@property (nonatomic, copy) NSString *CategoryId;

@property (nonatomic, copy) NSString *MSource;

@property (nonatomic, assign) CGFloat Sell_Price;

@property (nonatomic, copy) NSString *ProcurementCycle;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, assign) NSInteger Price;

@property (nonatomic, copy) NSString *Supplier1Id;

@property (nonatomic, copy) NSString *SEOKeyword;

@property (nonatomic, strong) NSArray *ImageUrls;

@end

@interface Imageurls : NSObject


@end
