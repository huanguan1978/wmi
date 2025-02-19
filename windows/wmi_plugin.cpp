#include "wmi_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>
#include <variant>

#include <iostream>
#include <string>

#include "wmi_utils.h"

namespace wmi
{

// static
void WmiPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar)
{
    auto channel =
        std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            registrar->messenger(), "wmi",
            &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<WmiPlugin>();

    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto &call, auto result) {
            plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    registrar->AddPlugin(std::move(plugin));
}

WmiPlugin::WmiPlugin()
{
}

WmiPlugin::~WmiPlugin()
{
}

void WmiPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{

    const auto *args =
        std::get_if<flutter::EncodableMap>(method_call.arguments());

    if (method_call.method_name().compare("getPlatformVersion") == 0)
    {
        bool wmic_optional = false;
        std::ostringstream version_stream;
        version_stream << "Windows ";
        if (IsWindowsVersionOrGreater(10, 0, 22572))
        {
            version_stream << "11";
        }
        else if (IsWindowsVersionOrGreater(10, 0, 22000))
        {
            version_stream << "11";
            wmic_optional = true;
        }
        else if (IsWindows10OrGreater())
        {
            version_stream << "10";
            wmic_optional = true;
        }
        else if (IsWindows8OrGreater())
        {
            version_stream << "8";
            wmic_optional = true;
        }
        else if (IsWindows7OrGreater())
        {
            version_stream << "7";
            wmic_optional = true;
        }
        version_stream << " (wmic installed " << (wmic_optional ? "yes" : "no") << ")";

        // Return the version information as a success result.
        result->Success(flutter::EncodableValue(version_stream.str()));
    }
    else if (method_call.method_name().compare("wmicPreInstalled") == 0)
    {
        bool wmicPreInstalled = false;
        try
        {
            wmicPreInstalled = WmiUtils::wmicPreInstalled();
        }
        catch (const std::exception &e)
        {
            result->Error("wmicPreInstalled Error", e.what());
            return;
        }

        result->Success(flutter::EncodableValue(wmicPreInstalled));
    }
    else if (method_call.method_name().compare("wmiRelease") == 0)
    {

        try
        {
            WmiUtils::wmiRelease();
        }
        catch (const std::exception &e)
        {
            result->Error("wmiRelease Error", e.what());
            return;
        }

        result->Success(flutter::EncodableValue());
    }
    else if (method_call.method_name().compare("wmiInit") == 0)
    {
        std::string servename;

        if (args)
        {
            auto servename_it = args->find(flutter::EncodableValue("servename"));
            if ((servename_it != args->end()))
            {
                servename = std::get<std::string>(servename_it->second);
            }
        }

        if (servename.empty())
        {
            result->Error("Invalid arguments", "Missing or empty arguments");
            return;
        }

        bool initialized = false;
        try
        {
            initialized = WmiUtils::wmiInit(servename);
        }
        catch (const std::exception &e)
        {
            result->Error("wmiInit Error", e.what());
            return;
        }

        result->Success(flutter::EncodableValue(initialized));
    }
    else if (method_call.method_name().compare("wmiValue") == 0)
    {
        std::string fieldname, tablename, condition, delimiter;

        if (args)
        {
            auto fieldname_it = args->find(flutter::EncodableValue("fieldname"));
            if ((fieldname_it != args->end()))
            {
                fieldname = std::get<std::string>(fieldname_it->second);
            }
            auto tablename_it = args->find(flutter::EncodableValue("tablename"));
            if ((tablename_it != args->end()))
            {
                tablename = std::get<std::string>(tablename_it->second);
            }
            auto condition_it = args->find(flutter::EncodableValue("condition"));
            if ((condition_it != args->end()))
            {
                condition = std::get<std::string>(condition_it->second);
            }
            auto delimiter_it = args->find(flutter::EncodableValue("delimiter"));
            if ((delimiter_it != args->end()))
            {
                delimiter = std::get<std::string>(delimiter_it->second);
            }
        }

        if (fieldname.empty() || tablename.empty() || fieldname.length() < 2)
        {
            result->Error("Invalid arguments", "Missing or empty arguments");
            return;
        }

        std::wstring value = L"";
        try
        {
            value = WmiUtils::wmiValue(tablename, fieldname, condition, delimiter);
        }
        catch (const std::exception &e)
        {
            result->Error("wmiValue Error", e.what());
            return;
        }

        std::ostringstream wmi_stream;
        // wmi_stream << "wmi " << tablename << " " << fieldname;
        wmi_stream << WmiUtils::wstring_to_string(value);
        result->Success(flutter::EncodableValue(wmi_stream.str()));
    }
    else if (method_call.method_name().compare("wmiValues") == 0)
    {
        std::string fieldname, tablename, condition, delimiter;

        if (args)
        {
            auto fieldname_it = args->find(flutter::EncodableValue("fieldname"));
            if ((fieldname_it != args->end()))
            {
                fieldname = std::get<std::string>(fieldname_it->second);
            }
            auto tablename_it = args->find(flutter::EncodableValue("tablename"));
            if ((tablename_it != args->end()))
            {
                tablename = std::get<std::string>(tablename_it->second);
            }
            auto condition_it = args->find(flutter::EncodableValue("condition"));
            if ((condition_it != args->end()))
            {
                condition = std::get<std::string>(condition_it->second);
            }
            auto delimiter_it = args->find(flutter::EncodableValue("delimiter"));
            if ((delimiter_it != args->end()))
            {
                delimiter = std::get<std::string>(delimiter_it->second);
            }
        }

        if (fieldname.empty() || tablename.empty())
        {
            result->Error("Invalid arguments", "Missing or empty arguments");
            return;
        }

        std::wstring value = L"";
        try
        {
            value = WmiUtils::wmiValues(tablename, fieldname, condition, delimiter);
        }
        catch (const std::exception &e)
        {
            result->Error("wmiValues Error", e.what());
            return;
        }

        std::ostringstream wmi_stream;
        // wmi_stream << "wmi " << tablename << " " << fieldname;
        wmi_stream << WmiUtils::wstring_to_string(value);
        result->Success(flutter::EncodableValue(wmi_stream.str()));
    }
    else
    {
        result->NotImplemented();
    }
}

} // namespace wmi
