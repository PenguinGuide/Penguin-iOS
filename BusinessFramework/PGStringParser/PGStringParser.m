//
//  PGStringParser.m
//  Penguin
//
//  Created by Jing Dai on 7/25/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define HTML_Tag_Body @"body"
#define HTML_Tag_Div @"div"
#define HTML_Tag_Paragraph @"p"
#define HTML_Tag_Span @"span"
#define HTML_Attribute_Style @"style"
#define HTML_Tag_Strong @"strong"
#define HTML_Tag_Image @"img"
#define HTML_Tag_Video @"video"
#define HTML_Tag_Class @"class"
#define HTML_Tag_Hyper_Link @"a"
#define HTML_Tag_Newline @"br"

#define HTML_Attribute_Class @"class"
#define HTML_Attribute_Src @"src"
#define HTML_Attribute_Poster @"poster"
#define HTML_Attribute_Image_Ratio @"data-width-height-ratio"
#define HTML_Attribute_Hyper_Ref @"href"
#define HTML_Attribute_Single_Good @"data-product-id"
#define HTML_Attribute_Goods_Collection @"data-product-group-id"

#define CSS_Style_Color @"color"
#define CSS_Style_Text_Font @"text-font"

#define Paragraph_Class_Catalog_Title @"catalog-title"
#define Paragraph_Class_Video @"video"

#import "PGStringParser.h"
#import "NSString+PGStringParser.h"
#import "TFHpple.h"

@interface PGStringParser ()

@property (nonatomic, strong) NSString *htmlString;

@end

@implementation PGStringParser

+ (instancetype)htmlParserWithString:(NSString *)htmlString
{
    return [[self alloc] initWithHTMLString:htmlString];
}

- (instancetype)initWithHTMLString:(NSString *)htmlString
{
    if (self = [super init]) {
        self.htmlString = htmlString;
    }
    
    return self;
}

- (NSArray *)articleParsedStorages
{
    if (!self.htmlString || self.htmlString.length == 0) {
        return nil;
    }
    
    TFHpple *document = [TFHpple hppleWithHTMLData:[self.htmlString dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *paragraphs = [document searchWithXPathQuery:@"//p"];
    
    __block NSMutableArray *storages = [NSMutableArray new];
    [paragraphs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[TFHppleElement class]]) {
            TFHppleElement *element = obj;
            
            if (![element hasChildren]) {
                if ([element attributes].count == 0) {
                    if (element.text && element.text.length > 0) {
                        // <p></p>
                        PGParserTextStorage *textStorage = [PGParserTextStorage new];
                        NSAttributedString *attrS = [element.text paragraphAttributedString];
                        if (attrS) {
                            textStorage.text = attrS;
                            [storages addObject:textStorage];
                        }
                    } else {
                        
                    }
                } else {
                    if ([element objectForKey:HTML_Tag_Class]) {
                        if ([[element objectForKey:HTML_Tag_Class] isEqualToString:Paragraph_Class_Catalog_Title]) {
                            // <p class=catalog-title></p>
                            if (element.text && element.text.length > 0) {
                                PGParserTextStorage *textStorage = [PGParserTextStorage new];
                                NSAttributedString *attrS = [element.text catalogTitleAttributedString];
                                if (attrS) {
                                    textStorage.text = attrS;
                                    [storages addObject:textStorage];
                                }
                            }
                        }
                    }
                }
            } else {
                __block PGParserTextStorage *textStorage = nil;
                __block NSDictionary *textAlignCSSStyle = nil;
                if ([element.attributes objectForKey:HTML_Attribute_Style]) {
                    textAlignCSSStyle = [[element.attributes objectForKey:HTML_Attribute_Style] CSSStyles];
                }
                
                [element.children enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[TFHppleElement class]]) {
                        TFHppleElement *childElement = obj;
                        
                        if ([childElement.tagName isEqualToString:HTML_Tag_Video]) {
                            // <p><video poster="xxx"><source src="xxx"></source></video></p>
                            PGParserVideoStorage *videoStorage = [PGParserVideoStorage new];
                            if ([childElement objectForKey:HTML_Attribute_Poster]) {
                                videoStorage.image = [childElement objectForKey:HTML_Attribute_Poster];
                                videoStorage.ratio = 16.f/9.f;
                            }
                            TFHppleElement *videoSrcElement = childElement.firstChild;
                            if (videoSrcElement) {
                                if ([videoSrcElement objectForKey:HTML_Attribute_Src]) {
                                    NSString *videoSrc = [videoSrcElement objectForKey:HTML_Attribute_Src];
                                    videoStorage.link = videoSrc;
                                    
                                    [storages addObject:videoStorage];
                                    *stop = YES;
                                }
                            }
                        } else if ([childElement.tagName isEqualToString:HTML_Tag_Image]) {
                            // <p><img class="xxx" /></p>
                            if ([childElement objectForKey:HTML_Attribute_Src]) {
                                if ([[childElement objectForKey:HTML_Attribute_Class] isEqualToString:@"pg-image-content"]) {
                                    if ([childElement objectForKey:HTML_Attribute_Single_Good]) {
                                        // <p><img data-product-id="137" class="pg-image-content" /></p>
                                        PGParserSingleGoodStorage *singleGoodStorage = [PGParserSingleGoodStorage new];
                                        singleGoodStorage.image = [childElement objectForKey:HTML_Attribute_Src];
                                        singleGoodStorage.goodId = [childElement objectForKey:HTML_Attribute_Single_Good];
                                        [storages addObject:singleGoodStorage];
                                    } else if ([childElement objectForKey:HTML_Attribute_Goods_Collection]) {
                                        // <p><img data-product-group-id="64" class="pg-image-content" /></p>
                                        PGParserGoodsCollectionStorage *goodsCollectionStorage = [PGParserGoodsCollectionStorage new];
                                        goodsCollectionStorage.collectionId = [childElement objectForKey:HTML_Attribute_Goods_Collection];
                                        [storages addObject:goodsCollectionStorage];
                                    } else {
                                        // <p><img class="pg-image-content" /></p>
                                        PGParserImageStorage *imageStorage = [PGParserImageStorage new];
                                        imageStorage.isGIF = NO;
                                        imageStorage.image = [childElement objectForKey:HTML_Attribute_Src];
                                        if ([childElement objectForKey:HTML_Attribute_Image_Ratio]) {
                                            imageStorage.ratio = [[childElement objectForKey:HTML_Attribute_Image_Ratio] floatValue];
                                        }
                                        [storages addObject:imageStorage];
                                    }
                                } else if ([[childElement objectForKey:HTML_Attribute_Class] isEqualToString:@"pg-image-gif"]) {
                                    // <p><img class="pg-image-gif" /></p>
                                    PGParserImageStorage *imageStorage = [PGParserImageStorage new];
                                    imageStorage.isGIF = YES;
                                    imageStorage.image = [childElement objectForKey:HTML_Attribute_Src];
                                    if ([childElement objectForKey:HTML_Attribute_Image_Ratio]) {
                                        imageStorage.ratio = [[childElement objectForKey:HTML_Attribute_Image_Ratio] floatValue];
                                    }
                                    [storages addObject:imageStorage];
                                } else if ([[childElement objectForKey:HTML_Attribute_Class] isEqualToString:@"pg-image-catalog"]) {
                                    // <p><img class="pg-image-catalog" /></p>
                                    PGParserCatalogImageStorage *imageStorage = [PGParserCatalogImageStorage new];
                                    imageStorage.image = [childElement objectForKey:HTML_Attribute_Src];
                                    if ([childElement objectForKey:HTML_Attribute_Image_Ratio]) {
                                        imageStorage.ratio = [[childElement objectForKey:HTML_Attribute_Image_Ratio] floatValue];
                                    }
                                    [storages addObject:imageStorage];
                                }
                            }
                            *stop = YES;
                        } else if ([childElement.tagName isEqualToString:HTML_Tag_Newline]) {
                            PGParserNewlineStorage *newlineStorage = [PGParserNewlineStorage new];
                            [storages addObject:newlineStorage];
                            *stop = YES;
                        } else {
                            // <p>xxx</p>
                            if ([childElement.tagName isEqualToString:HTML_Tag_Span]) {
                                NSMutableArray *styles = [NSMutableArray new];
                                NSString *paragraphStr = childElement.text;
                                if (paragraphStr.length > 0) {
                                    if ([childElement objectForKey:HTML_Attribute_Style]) {
                                        NSDictionary *cssStyles = [[childElement objectForKey:HTML_Attribute_Style] CSSStyles];
                                        NSAttributedString *attrS = nil;
                                        if (textAlignCSSStyle && textAlignCSSStyle.allKeys.count > 0) {
                                            NSMutableDictionary *centerAlignedCSSStyles = [NSMutableDictionary dictionaryWithDictionary:cssStyles];
                                            [centerAlignedCSSStyles addEntriesFromDictionary:textAlignCSSStyle];
                                            attrS = [paragraphStr styledParagraphAttributedString:[NSDictionary dictionaryWithDictionary:centerAlignedCSSStyles]];
                                        } else {
                                            attrS = [paragraphStr styledParagraphAttributedString:cssStyles];
                                        }
                                        if (!textStorage) {
                                            textStorage = [PGParserTextStorage new];
                                            textStorage.text = attrS;
                                        } else {
                                            if (textStorage.text) {
                                                NSMutableAttributedString *originalAttrS = [[NSMutableAttributedString alloc] initWithAttributedString:textStorage.text];
                                                [originalAttrS appendAttributedString:attrS];
                                                textStorage.text = [[NSAttributedString alloc] initWithAttributedString:originalAttrS];
                                            } else {
                                                textStorage.text = attrS;
                                            }
                                        }
                                    }
                                } else {
                                    if (childElement.children.count > 0) {
                                        [childElement.children enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                            if ([obj isKindOfClass:[TFHppleElement class]]) {
                                                TFHppleElement *childElement = (TFHppleElement *)obj;
                                                if ([childElement.tagName isEqualToString:HTML_Tag_Image]) {
                                                    // <p><img class="xxx" /></p>
                                                    if ([childElement objectForKey:HTML_Attribute_Src]) {
                                                        if ([[childElement objectForKey:HTML_Attribute_Class] isEqualToString:@"pg-image-content"]) {
                                                            if ([childElement objectForKey:HTML_Attribute_Single_Good]) {
                                                                // <p><img data-product-id="137" class="pg-image-content" /></p>
                                                                PGParserSingleGoodStorage *singleGoodStorage = [PGParserSingleGoodStorage new];
                                                                singleGoodStorage.image = [childElement objectForKey:HTML_Attribute_Src];
                                                                singleGoodStorage.goodId = [childElement objectForKey:HTML_Attribute_Single_Good];
                                                                [storages addObject:singleGoodStorage];
                                                            } else if ([childElement objectForKey:HTML_Attribute_Goods_Collection]) {
                                                                // <p><img data-product-group-id="64" class="pg-image-content" /></p>
                                                                PGParserGoodsCollectionStorage *goodsCollectionStorage = [PGParserGoodsCollectionStorage new];
                                                                goodsCollectionStorage.collectionId = [childElement objectForKey:HTML_Attribute_Goods_Collection];
                                                                [storages addObject:goodsCollectionStorage];
                                                            }else {
                                                                // <p><img class="pg-image-content" /></p>
                                                                PGParserImageStorage *imageStorage = [PGParserImageStorage new];
                                                                imageStorage.isGIF = NO;
                                                                imageStorage.image = [childElement objectForKey:HTML_Attribute_Src];
                                                                if ([childElement objectForKey:HTML_Attribute_Image_Ratio]) {
                                                                    imageStorage.ratio = [[childElement objectForKey:HTML_Attribute_Image_Ratio] floatValue];
                                                                }
                                                                [storages addObject:imageStorage];
                                                            }
                                                        } else if ([[childElement objectForKey:HTML_Attribute_Class] isEqualToString:@"pg-image-gif"]) {
                                                            // <p><img class="pg-image-gif" /></p>
                                                            PGParserImageStorage *imageStorage = [PGParserImageStorage new];
                                                            imageStorage.isGIF = YES;
                                                            imageStorage.image = [childElement objectForKey:HTML_Attribute_Src];
                                                            if ([childElement objectForKey:HTML_Attribute_Image_Ratio]) {
                                                                imageStorage.ratio = [[childElement objectForKey:HTML_Attribute_Image_Ratio] floatValue];
                                                            }
                                                            [storages addObject:imageStorage];
                                                        } else if ([[childElement objectForKey:HTML_Attribute_Class] isEqualToString:@"pg-image-catalog"]) {
                                                            // <p><img class="pg-image-catalog" /></p>
                                                            PGParserCatalogImageStorage *imageStorage = [PGParserCatalogImageStorage new];
                                                            imageStorage.image = [childElement objectForKey:HTML_Attribute_Src];
                                                            if ([childElement objectForKey:HTML_Attribute_Image_Ratio]) {
                                                                imageStorage.ratio = [[childElement objectForKey:HTML_Attribute_Image_Ratio] floatValue];
                                                            }
                                                            [storages addObject:imageStorage];
                                                        }
                                                    }
                                                    *stop = YES;
                                                }
                                            }
                                        }];
                                        *stop = YES;
                                    }
                                }
                            } else if ([childElement.tagName isEqualToString:HTML_Tag_Strong]) {
                                NSString *paragraphStr = childElement.text;
                                NSAttributedString *attrS = nil;
                                if (paragraphStr.length > 0) {
                                    if ([childElement objectForKey:HTML_Attribute_Style]) {
                                        NSDictionary *cssStyles = [[childElement objectForKey:HTML_Attribute_Style] CSSStyles];
                                        if (textAlignCSSStyle && textAlignCSSStyle.allKeys.count > 0) {
                                            NSMutableDictionary *centerAlignedCSSStyles = [NSMutableDictionary dictionaryWithDictionary:cssStyles];
                                            [centerAlignedCSSStyles addEntriesFromDictionary:textAlignCSSStyle];
                                            [centerAlignedCSSStyles addEntriesFromDictionary:@{@"strong":@"strong"}];
                                            attrS = [paragraphStr styledParagraphAttributedString:[NSDictionary dictionaryWithDictionary:centerAlignedCSSStyles]];
                                        } else {
                                            NSMutableDictionary *centerAlignedCSSStyles = [NSMutableDictionary dictionaryWithDictionary:cssStyles];
                                            [centerAlignedCSSStyles addEntriesFromDictionary:@{@"strong":@"strong"}];
                                            attrS = [paragraphStr styledParagraphAttributedString:[NSDictionary dictionaryWithDictionary:centerAlignedCSSStyles]];
                                        }
                                    } else {
                                        if (textAlignCSSStyle && textAlignCSSStyle.allKeys.count > 0) {
                                            NSMutableDictionary *centerAlignedCSSStyles = [NSMutableDictionary dictionaryWithDictionary:@{@"strong":@"strong"}];
                                            [centerAlignedCSSStyles addEntriesFromDictionary:textAlignCSSStyle];
                                            attrS = [paragraphStr styledParagraphAttributedString:[NSDictionary dictionaryWithDictionary:centerAlignedCSSStyles]];
                                        } else {
                                            attrS = [paragraphStr styledParagraphAttributedString:@{@"strong":@"strong"}];
                                        }
                                    }
                                    if (!textStorage) {
                                        textStorage = [PGParserTextStorage new];
                                        textStorage.text = attrS;
                                    } else {
                                        if (textStorage.text) {
                                            NSMutableAttributedString *originalAttrS = [[NSMutableAttributedString alloc] initWithAttributedString:textStorage.text];
                                            [originalAttrS appendAttributedString:attrS];
                                            textStorage.text = [[NSAttributedString alloc] initWithAttributedString:originalAttrS];
                                        } else {
                                            textStorage.text = attrS;
                                        }
                                    }
                                }
                            } else if ([childElement isTextNode]) {
                                if (childElement.content.length > 0) {
                                    NSAttributedString *attrS = nil;
                                    if (textAlignCSSStyle) {
                                        attrS = [childElement.content styledParagraphAttributedString:textAlignCSSStyle];
                                    } else {
                                        attrS = [childElement.content paragraphAttributedString];
                                    }
                                    if (!textStorage) {
                                        textStorage = [PGParserTextStorage new];
                                        textStorage.text = attrS;
                                    } else {
                                        if (textStorage.text) {
                                            NSMutableAttributedString *originalAttrS = [[NSMutableAttributedString alloc] initWithAttributedString:textStorage.text];
                                            [originalAttrS appendAttributedString:attrS];
                                            textStorage.text = [[NSAttributedString alloc] initWithAttributedString:originalAttrS];
                                        } else {
                                            textStorage.text = attrS;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }];
                if (textStorage && textStorage.text) {
                    [storages addObject:textStorage];
                }
            }
        }
    }];
    
    return storages;
}

@end
