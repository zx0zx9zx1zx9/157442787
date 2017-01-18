//
//  SqliteTool.h
//  Oc1
//
//  Created by zhangxin on 2017/1/17.
//  Copyright © 2017年 Apple inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TestModel.h"

@interface SqliteTool : NSObject

+ (SqliteTool *)shareinstance;

- (BOOL)creatSqliteDB;

//创建一个存储列表。 一个数据库可以创建很多列表，用来存储不同的对象。
- (BOOL)createTable;

//往表中插入数据
- (BOOL)insertModel:(TestModel *)model;

//更新表中的数据
- (BOOL)updateModel:(TestModel *)model;

//删除表中的数据
- (BOOL)deletedateModel:(TestModel *)model;

//查看表中的数据
- (NSMutableArray *)selectAllModel;
@end
