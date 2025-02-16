#ifndef FLUTTER_PLUGIN_WMI_PLUGIN_H_
#define FLUTTER_PLUGIN_WMI_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace wmi {

class WmiPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  WmiPlugin();

  virtual ~WmiPlugin();

  // Disallow copy and assign.
  WmiPlugin(const WmiPlugin&) = delete;
  WmiPlugin& operator=(const WmiPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace wmi

#endif  // FLUTTER_PLUGIN_WMI_PLUGIN_H_
