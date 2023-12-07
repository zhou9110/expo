#ifdef __cplusplus
#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>

inline NSArray<NSDictionary *> *convertColorFilters(std::vector<ABI50_0_0facebook::ABI50_0_0React::LottieAnimationViewColorFiltersStruct> colorFilterStructArr)
{
    NSMutableArray *filters = [NSMutableArray arrayWithCapacity:colorFilterStructArr.size()];
    
    for (auto colorFilter : colorFilterStructArr) {
        [filters addObject:@{
            @"color": ABI50_0_0RCTUIColorFromSharedColor(colorFilter.color),
            @"keypath": ABI50_0_0RCTNSStringFromString(colorFilter.keypath),
        }];
    }
    return filters;
}

inline NSArray<NSDictionary *> *convertTextFilters(std::vector<ABI50_0_0facebook::ABI50_0_0React::LottieAnimationViewTextFiltersIOSStruct> textFilterStructArr)
{
    NSMutableArray *filters = [NSMutableArray arrayWithCapacity:textFilterStructArr.size()];
    
    for (auto textFilter : textFilterStructArr) {
        [filters addObject:@{
            @"text": ABI50_0_0RCTNSStringFromString(textFilter.text),
            @"keypath": ABI50_0_0RCTNSStringFromString(textFilter.keypath),
        }];
    }
    return filters;
}
#endif
