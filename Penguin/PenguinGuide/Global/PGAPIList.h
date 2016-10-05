//
//  PGAPIList.h
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#ifndef PGAPIList_h
#define PGAPIList_h

#define PG_Home_Recommends              @"/api/v1/home/recommends"

#define PG_Channel                      @"/api/v1/channel/:channelId"

#define PG_Channel_Category_Articles    @"/api/v1/article/channel/:channelId/category/:categoryId"

#define PG_Search_Articles              @"/api/v1/search/articles"
#define PG_Search_Goods                 @"/api/v1/search/goods"

#define PG_Scenario                     @"/api/v1/scenario/:scenarioId"
#define PG_Scenario_Feeds               @"/api/v1/scenario/feeds/scenario/:scenarioId/category/:categoryId"

#define PG_Good                         @"/api/v1/good/:goodId"
#define PG_Store_Category_Goods         @"/api/v1/goods/category/:categoryId"

#define PG_Topic                        @"/api/v1/topic/:topicId"

#define PG_Article                      @"/api/v1/article/:articleId"

#define PG_Comments                     @"/api/v1/comments/:articleId"

#define PG_Me                           @"/api/v1/user/:userId"

#define PG_Home_Feeds                   @"/api/v1/feeds/home"

#endif /* PGAPIList_h */
