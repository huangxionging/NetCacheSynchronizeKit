# NetCacheSynchronizeKit
-----
本文档为`NetCacheSynchronizeKit` 的开发文档. 架构图


************
|      		|  				  		|
| :-------:	|:--------------------:	|
| 版本号:	  | V1.0					| 
| 作者:	   | huangxiong			|
| 联系方式:	  | huangxionging@qq.com	|
| 日期:	   |  2017.04.15			 |	


*************
##<a name="index"/>目录
* [一. SDK 架构](#Structure)

* [二. DataCache](#DataCache)
	* 2.1 [NCDataStorageManager](#NCDataStorageManager)
	* 2.2 [NCDataStorageTableModel](#NCDataStorageTableModel)
	* 2.3 [NCDataStorageItemModel](#NCDataStorageItemModel)
* [三. NetSynchronize](#NetSynchronize)
* [四. UtilityTool](#UtilityTool)
	* 4.1 [NSObject+Property](#Property)
	* 4.2 [NCDispatchMessageManager](#NCDispatchMessageManager)

##<a name="Structure"/> 一. SDK 架构
 	SDK 分为 DataCache 和 NetSynchronize 以及 UtilityTool 三部分组成
 	DataCache 是基于 FMDB 的数据库 ORM 实现, 无需编写 sql 语句, 可以非常方便的对数据进行增删改查, 而且数据库表名(TableName)就是相应的数据模型的类名. 非常方便的从数据模型映射到数据库.(包含NCDataStorageManager, NCDataStorageTableModel, NCDataStorageItemModel)
 		
 	NetSynchronize 是基于 AFNetWorking 的网络访问, 接口管理, 实现的网络同步工具.


##<a name="DataCache"/>二. DataCache
```Objective-C
int a=b;
```