//
//  PGAPIList.h
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#ifndef PGAPIList_h
#define PGAPIList_h

#define PG_Home_Recommends              @"/api/v1/recommends/home"
#define PG_Explore_Recommends           @"/api/v1/recommends/explore"
#define PG_Store_Recommends             @"/api/v1/recommends/store"

#define PG_Home_Feeds                   @"/api/v1/feeds/home"
#define PG_Store_Feeds                  @"/api/v1/feeds/store"

#define PG_Channel                      @"/api/v1/channel/:channelId"

#define PG_Channel_Category_Articles    @"/api/v1/article/channel/:channelId/category/:categoryId"

#define PG_Search_Articles              @"/api/v1/search/articles"
#define PG_Search_Goods                 @"/api/v1/search/goods"

#define PG_Scenario                     @"/api/v1/scenario/:scenarioId"
#define PG_Scenario_Feeds               @"/api/v1/scenario/feeds/scenario/:scenarioId/category/:categoryId"

#define PG_Good                         @"/api/v1/goods/:goodId"
#define PG_Related_Goods                @"/api/v1/goods/related/:goodId"
#define PG_Store_Category_Goods         @"/api/v1/goods/category/:categoryId"

#define PG_Topic                        @"/api/v1/topic/:topicId"

#define PG_Article                      @"/api/v1/article/:articleId"
#define PG_Article_Comments             @"/api/v1/article/:articleId/comments"
#define PG_Article_Hot_Comments         @"/api/v1/article/:articleId/hot_comments"
#define PG_Article_Comment_Reply        @"/api/v1/article_comment/:commentId/reply"

#define PG_Comments                     @"/api/v1/comments/:articleId"

#define PG_Me                           @"/api/v1/user/:userId"
#define PG_User                         @"/api/v1/user/:userId";

#define PG_Tag                          @"/api/v1/tag/:tagId"

#define PG_Phone_Register               @"/api/v1/register"
#define PG_Phone_Login                  @"/api/v1/login"
#define PG_Wechat_Login                 @"/api/v1/wechat_login"
#define PG_Weibo_Login                  @"/api/v1/weibo_login"
#define PG_Send_SMS_Code                @"/api/v1/auth_validation_code"
#define PG_Send_Reset_Pwd_SMS_Code      @"/api/v1/reset_password_validation_code"
#define PG_Reset_Pwd                    @"/api/v1/reset_password"

#define PG_Upload_Image                 @"/api/v1/upload_avatar"

#endif /* PGAPIList_h */
