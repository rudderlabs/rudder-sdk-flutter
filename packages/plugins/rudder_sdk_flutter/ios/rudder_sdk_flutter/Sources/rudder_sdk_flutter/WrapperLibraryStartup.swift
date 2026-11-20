@_spi(RudderStackWrapper) import RudderStackAnalytics

let wrapperLibraryName = "rudder-sdk-flutter"

/// Marks every event as Flutter traffic. The `+load` of the startup target calls it, so it needs a public symbol.
@_cdecl("rudder_sdk_flutter_set_wrapper_library")
@_spi(RudderSdkFlutterStartup) public func setWrapperLibrary() {
    WrapperLibrary.set(name: wrapperLibraryName, version: packageVersion)
}
