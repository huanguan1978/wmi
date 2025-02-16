#include "include/wmi/wmi_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "wmi_plugin.h"

void WmiPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  wmi::WmiPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
