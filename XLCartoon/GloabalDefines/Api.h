//
//  Api.h
//  XLGame
//
//  Created by yuchutian on 2017/9/29.
//  Copyright © 2017年 In.于楚天. All rights reserved.
//

#ifndef Api_h
#define Api_h

#define Msg(responseObject)  [responseObject objectForKey:@"msg"]
#define IS_SUCCESS(responseObject) (REQ_ERROR(responseObject) != 500 && REQ_ERROR(responseObject) != 404 )
#define PAGE_INDEX(responseObject) [[responseObject objectForKey:@"nowpage"] intValue]
#define PAGE_TOTAL(responseObject) [[responseObject objectForKey:@"totalpage"] intValue]
#define REQ_ERROR(responseObject) [[responseObject objectForKey:@"error"] intValue]
#define OBJ(responseObject) [responseObject objectForKey:@"obj"]



#define BASE_URL    @"http://www.kakamanhua.com/Comic/"
//#define BASE_URL    @"http://192.168.1.39:8080/Comic/"
//#define BASE_URL    @"http://distributor.kakamanhua.com/Comic/"
/***平台分享回调***/
#define URL_SHARE_BACK BASE_URL @"app/back/share.do"
/***漫画分享回调***/
#define URL_SHARE_CARTOON_BACK BASE_URL @"app/comic/back/share.do"


// 注册验证码/send/register/code
#define URL_SMS BASE_URL @"send/register/code.do"
// 忘记密码验证码
#define URL_SMS_FIND_PSD BASE_URL @"app/send/register/code/byupdatepwd.do"
//登录
#define URL_LOGIN BASE_URL @"app/user/login/bypwd.do"
//第三方登录
#define URL_LOGIN_OTHER BASE_URL @"app/user/login/bythree.do"
//注册
#define URL_REGISTER BASE_URL @"app/user/register.do"
//找回密码
#define URL_FIND_PASSWORD BASE_URL @"app/forget/user/pwd.do"
/***头像保存***/
#define URL_SAVE_HEAD BASE_URL @"app/user/perfect/info/update/headportrait.do"
/***其他资料保存***/
#define URL_SAVE_USER_INFO BASE_URL @"app/user/perfect/info.do"
/***用户信息***/
#define URL_GET_USER_INFO BASE_URL @"qpp/user/get/userinfo/byuserid.do"
/***绑定手机***/
#define URL_SAVE_PHONG BASE_URL @"app/user/bond/phoneandpwd.do"


/***每日更新***/
#define URL_EVERYDAY_UPDATA BASE_URL @"ios/qpp/comic/get/cartoon/byfollow/news.do"
//获取banner图
#define URL_GETBANNER BASE_URL @"ios/qpp/comic/get/banner.do"
//最新漫画列表
#define URL_NEW_CARTOON BASE_URL @"ios/qpp/comic/get/allcartoon/new.do"
//首页
#define URL_HOME_CARTOON_LIST BASE_URL @"ios/qpp/comic/get/allcartoon.do"
/***关注榜***/
#define URL_CARTOON_TOP_BY_FOLLOW BASE_URL @"ios/qpp/comic/get/more/cartoon/hotshow/rankinglist.do"
/***人气榜***/
#define URL_CARTOON_TOP BASE_URL @"ios/qpp/comic/get/more/cartoon/rankinglist.do"
//热门漫画
#define URL_HOT_CARTOON BASE_URL @"ios/qpp/comic/get/hot/cartoon.do"
//猜你喜欢
#define URL_LIKE_CARTOON BASE_URL @"ios/qpp/comic/get/cartoon/love.do"

/***热门搜索***/
#define URL_HOT_SEARCH BASE_URL @"ios/app/search/initialization.do"
/***搜索***/
#define URL_SEARCH BASE_URL @"ios/app/search.do"

/***书架历史***/
#define URL_BOOKSHELF_HISTORY BASE_URL @"ios/qpp/comic/get/myhistoryRecord.do"
/***书架关注***/
#define URL_BOOKSHELF_FOLLOW BASE_URL @"ios/qpp/comic/get/cartoon/byfollow.do"

/***漫画类型***/
#define URL_TYPE BASE_URL @"qpp/comic/get/cartoon/type.do"
/***漫画类型***/
#define URL_CARTOON_LIST_BY_TYPE BASE_URL @"ios/qpp/comic/get/more/cartoon.do"


//漫画详情
#define URL_CARTOON BASE_URL @"qpp/comic/get/cartoon/head.do"
/***继续阅读***/
#define URL_CARTOON_HiSTORY BASE_URL @"qpp/comic/get/goon/myhistoryRecord.do"

/***漫画集列表***/
#define URL_EPISODE_CARTOON BASE_URL @"qpp/comic/get/cartoon/byid.do"
/***关注漫画***/
#define URL_FOLLOW_CARTOON BASE_URL @"qpp/comic/follow/cartoon.do"
/***点赞***/
#define URL_PRAISE BASE_URL @"qpp/comic/add/okcount.do"


/***获取漫画评论***/
#define URL_COMMENT_CARTOON BASE_URL @"qpp/comic/get/allcomment.do"
/***获取漫画评论的子评论***/
#define URL_COMMENT_BY_COMMENT BASE_URL @"qpp/comic/get/comment/allcomment.do"
/***漫画加评论***/
#define URL_CARTOON_ADD_COMMENT BASE_URL @"qpp/comic/add/allcomment.do"
/***评论加评论***/
#define URL_COMMENT_ADD_COMMENT BASE_URL @"qpp/comic/add/comment/comment.do"

/***获取漫画评论***/
#define URL_COMMENT_CARTOON BASE_URL @"qpp/comic/get/allcomment.do"
/***获取漫画评论的子评论***/
#define URL_COMMENT_BY_COMMENT BASE_URL @"qpp/comic/get/comment/allcomment.do"
/***漫画加评论***/
#define URL_CARTOON_ADD_COMMENT BASE_URL @"qpp/comic/add/allcomment.do"
/***漫画评论加评论***/
#define URL_COMMENT_ADD_COMMENT BASE_URL @"qpp/comic/add/comment/comment.do"

/***获取某集评论***/
#define URL_GET_COMMENT_Episode BASE_URL @"qpp/comic/get/allcomment/son.do"
/***获取某集评论的子评论***/
#define URL_GET_COMMENT_Episode_SON BASE_URL @"qpp/comic/get/comment/allcomment/son.do"
/***评论某集***/
#define URL_COMMENT_Episode BASE_URL @"qpp/comic/add/allcomment/son.do"
/***某集评论加评论***/
#define URL_ADD_COMMENT_Episode_COMMENT BASE_URL @"qpp/comic/add/comment/comment/son.do"

/***朋友圈点赞***/
#define URL_FRIEND_PRAISE BASE_URL @"qpp/comic/add/friendscomment/veryOk.do"
/***朋友圈列表***/
#define URL_FRIEND_ALL BASE_URL @"qpp/comic/get/allfriendcircle.do"
/***我的朋友圈列表***/
#define URL_FRIEND_MY BASE_URL @"qpp/comic/get/my/allfriendcircle.do"
/***朋友圈发布***/
#define URL_FRIEND_SEND_NEW BASE_URL @"qpp/comic/release/friendcircle.do"
/***朋友圈详情***/
#define URL_FRIEND_COMMENT_BY_ID BASE_URL @"qpp/comic/get/this/comments.do"
/***朋友圈回复***/
#define URL_FRIEND_COMMENT_SEND BASE_URL @"qpp/comic/release/friendscomment.do"
/***上传图片***/
#define URL_UPLOAD_IMG BASE_URL @"app/uplodUpdate/multipartFile.do"
/***朋友圈删除***/
#define URL_FRIEND_DELETE BASE_URL @"qpp/comic/delete/friendcircle/byid.do"



/***漫画图片***/
#define URL_CARTOON_PIC BASE_URL @"qpp/app/comic/cartoonphoto/up/down.do"
/***每一集点赞***/
#define URL_PRAISE_Episode BASE_URL @"qpp/comic/bysetid/okcount.do"
/***添加弹幕***/
#define URL_BARRAGE_ADD BASE_URL @"qpp/app/add/comic/barrage.do"
/***获取弹幕***/
#define URL_BARRAGE_GET BASE_URL @"qpp/app/get/comic/allbarrage.do"

/***签到***/
#define URL_SIGN BASE_URL @"qpp/comic/get/cartoon/sign/award.do"
/***我的任务***///#define URL_MY_TASK BASE_URL @"qpp/comic/get/cartoon/task/byuserid.do"
#define URL_MY_TASK BASE_URL @"qpp/app/comic/add/cartoon/task.do"
/***完成任务***/
#define URL_MY_TASK_FINISH BASE_URL @"qpp/comic/get/cartoon/task/award/byuserid.do"
/***购买解锁漫画***/
#define URL_CARTOON_UNLOCK BASE_URL @"qpp/app/comic/buy/this/cartoonset.do" //userId id
/***我的消息***/
#define URL_MY_MESSAGE BASE_URL @"qpp/comic/get/allNews232.do" //userId

//意见反馈
#define URL_FEEDBACK    BASE_URL @"/qpp/comic/add/my/feedback.do"
//商品信息
#define URL_PAY_PRODUCTS BASE_URL @"app/qpp/get/product.do"
//获取订单
#define URL_PAY_ORDER BASE_URL @"app/ios/qpp/generateOrder.do"
//支付成功 验签
#define URL_PAY_SUCCESS BASE_URL @"app/ios/qpp/payProduct.do"
//支付成功 验签
#define URL_PAY_HISTORY BASE_URL @"qpp/comic/get/allorder232.do"

#endif /* Api_h */








