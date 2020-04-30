#import "InfinityUiPlugin.h"
#if __has_include(<infinity_ui/infinity_ui-Swift.h>)
#import <infinity_ui/infinity_ui-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "infinity_ui-Swift.h"
#endif

@implementation InfinityUiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftInfinityUiPlugin registerWithRegistrar:registrar];
}
@end
