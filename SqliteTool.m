//
//  SqliteTool.m
//  Oc1
//
//  Created by zhangxin on 2017/1/17.
//  Copyright © 2017年 Apple inc. All rights reserved.
//

#import "SqliteTool.h"
#import "TestModel.h"



@implementation SqliteTool

{
    
    sqlite3 *_dbPoint;  //用于保存数据库对象的地址
    
}

+ (SqliteTool *)shareinstance{
    
    static SqliteTool *tool = nil;
    
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        
        tool=[[SqliteTool alloc] init];
        
    });
    
    return tool;
    
}

//如果系统根据这个文件路径查找的时候有对应文件则直接打开数据库,如果没有则会创建一个相应的数据库
- (BOOL)creatSqliteDB{
    NSString *sqitePath = [NSHomeDirectory() stringByAppendingPathComponent:@"testModel.sqlite"];
    
    int result = sqlite3_open([sqitePath UTF8String], &_dbPoint); //在指定路径下，创建一个数据，并将数据库的地址赋值给_dbPoint
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
        NSLog(@"%@",sqitePath);
        return YES;
    }else{
        NSLog(@"数据库打开失败");
    }
    return NO;
}

- (BOOL)closeSqliteDB{
    int result = sqlite3_close(_dbPoint);
    if (result==SQLITE_OK) {
        NSLog(@"数据库关闭成功");
        return YES;
        
    }else{
        NSLog(@"数据库关闭失败");
    }
    return NO;
}

- (BOOL)createTable{
    //语句中包涵的信息应该仔细， nsstring类型对应的是text 数组对应arr 整型对应integer 等等
    NSString *sqlStr = @"create table if not exists test(number integer primary key autoincrement,name text,age integer,sex text)";
    //执行这条sql语句
    int result = sqlite3_exec(_dbPoint, [sqlStr UTF8String], nil, nil, nil);
    
    if (result == SQLITE_OK) {
        NSLog(@"表创建成功");
        return YES;
    }else{
        NSLog(@"表创建失败");
    }
    return NO;
}

//往表中插入数据
- (BOOL)insertModel:(TestModel *)model{
    NSString *sqlStr=[NSString stringWithFormat:@"insert into test (name,age,sex) values ('%@','%ld','%@')",model.name,model.age,model.sex];
    //执行sql语句
    int result = sqlite3_exec(_dbPoint, [sqlStr UTF8String], nil, nil, nil);
    if (result == SQLITE_OK) {
        NSLog(@"添加%@成功",model.name);
        return YES;
    }else {
        NSLog(@"添加model失败");
    }
    return NO;
}

//删除表中的内容
- (BOOL)deletedateModel:(TestModel *)model{
    
    NSString *sqlStr=[NSString stringWithFormat:@"delete from test where name='%@'",model.name];
    
    //    NSString *sqlStr=[NSString stringWithFormat:@"delete from test"];  //不添加添加条件则删除所有数据
    
    //执行sql语句
    int result = sqlite3_exec(_dbPoint, [sqlStr UTF8String], nil, nil, nil);
    if (result == SQLITE_OK) {
        NSLog(@"删除%@成功",model.name);
        return YES;
    }else {
        NSLog(@"删除失败");
    }
    return NO;
}

//更新表中的数据
- (BOOL)updateModel:(TestModel *)model{
    NSString *sqlStr= [NSString stringWithFormat:@"update test set sex='%@',age=%ld where name='%@'",model.sex,model.age,model.name];
    //执行sql语句
    int result = sqlite3_exec(_dbPoint, [sqlStr UTF8String], nil, nil, nil);
    if (result == SQLITE_OK) {
        NSLog(@"修改成功");
        return YES;
    }else {
        NSLog(@"修改失败");
    }
    return NO;
}

- (NSMutableArray *)selectAllModel{
    NSString *sqlStr=@"select * from test";
    sqlite3_stmt *stmt=nil;
    int result=sqlite3_prepare_v2(_dbPoint, [sqlStr UTF8String], -1, &stmt, nil);//这个方法相当于把数据库和跟随指针关联,一同完成查询功能
    
    NSMutableArray *modelArr = [NSMutableArray array];
    //初始化学生类数组 获取遍历得到的数据
    if (result == SQLITE_OK) {
        NSLog(@"查询成功");
        //开始遍历查询数据库的每一行数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //让跟随指针进行遍历查询,如果没有行,才会停止循环
            //满足条件,则逐列的读取内容
            //第二个参数表示当前这列数据在表的第几列
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            int age = sqlite3_column_int(stmt, 2);
            const unsigned char *sex = sqlite3_column_text(stmt,3);
            //把列里的数据再进行类型的转换
            NSInteger modelAge = age;
            NSString *modelName = [NSString stringWithUTF8String:(const char *)name];
            NSString *modelSex = [NSString stringWithUTF8String:(const char *)sex];
            //给对象赋值,然后把对象放到数组里
            TestModel *model = [[TestModel alloc] init];
            model.name = modelName;
            model.sex = modelSex;
            model.age = modelAge;
            [modelArr addObject:model];
        }
    }else{
        NSLog(@"查询失败");
    }
    return modelArr;
}
@end
