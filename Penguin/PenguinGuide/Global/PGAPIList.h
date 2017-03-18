//
//  PGAPIList.h
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#ifndef PGAPIList_h
#define PGAPIList_h

#define PG_Home_Recommends              @"/v2/recommends/home"
#define PG_Explore_Recommends           @"/article/featured"
#define PG_Store_Recommends             @"/recommends/store"
#define PG_City_Guide_Cities            @"/city_guide/cities"

#define PG_Home_Feeds                   @"/feeds/home"
#define PG_Explore_Feeds                @"/feeds/explore"
#define PG_Store_Feeds                  @"/feeds/store"

#define PG_City_Guide_City_Articles     @"/city_guide"

#define PG_Channel                      @"/channel/:channelId"
#define PG_Channel_Category_Articles    @"/channel/:channelId/articles"

#define PG_Search_Recommends            @"/search/hot_keywords"
#define PG_Search                       @"/search"

#define PG_Scenarios                    @"/scenario"
#define PG_Scenario                     @"/scenario/:scenarioId"
#define PG_Scenario_Feeds               @"/feeds/scenario/:scenarioId"
#define PG_Scenario_Goods               @"/scenario/:scenarioId/products"

#define PG_Good                         @"/goods/:goodId"
#define PG_Goods_Collection             @"/goods_collection/:collectionId"
#define PG_Related_Goods                @"/goods/related/:goodId"
#define PG_Store_Category_Goods         @"/category/:categoryId/goods"

#define PG_Topic                        @"/topic/:topicId"

#define PG_Article                      @"/article/:articleId"
#define PG_Article_Like                 @"/article_favor/:articleId"
#define PG_Article_Collect              @"/article_store/:articleId"
#define PG_Article_Comments             @"/article/:articleId/comments"
#define PG_Article_Hot_Comments         @"/article/:articleId/hot_comments"
#define PG_Article_Comment              @"/article_comment/:commentId"
#define PG_Article_Comment_Reply        @"/article_comment/:commentId/reply"
#define PG_Article_Comment_Like         @"/comment_favor/:commentId"
#define PG_Report                       @"/report"

#define PG_Comments                     @"/comments/:articleId"

#define PG_Me                           @"/user/:userId"
#define PG_Me_Info                      @"/user/info_page"
#define PG_User                         @"/user/:userId"
#define PG_User_Bind_Weixin             @"/bind_wechat"
#define PG_User_Bind_Weibo              @"/bind_weibo"
#define PG_Message                      @"/message"
#define PG_Message_Has_New              @"/message/has_new"
#define PG_Message_Read                 @"/message/reset_status"
#define PG_Message_Counts               @"/message/count_unread_group_by_type"
#define PG_Channel_Collections          @"/article_store/count_group_by_channel"
#define PG_Collection_Articles          @"/article_store"
#define PG_History                      @"/foot_print/:userId"

#define PG_Tag                          @"/tag/:tagId"

#define PG_Phone_Register               @"/register"
#define PG_Phone_Login                  @"/login"
#define PG_Wechat_Login                 @"/wechat_login"
#define PG_Weibo_Login                  @"/weibo_login"
#define PG_Send_SMS_Code                @"/auth_validation_code"
#define PG_Send_Reset_Pwd_SMS_Code      @"/reset_password_validation_code"
#define PG_Reset_Pwd                    @"/reset_password"

#define PG_Upload_Image                 @"/upload_avatar"

#define PG_Register_APNS_Token          @"/push/device_token"
#define PG_Qiniu_Token                  @"/qiniu_uptoken/avatar"

#endif /* PGAPIList_h */
