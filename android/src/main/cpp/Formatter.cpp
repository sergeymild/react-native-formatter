//
// Created by Sergei Golishnikov on 06/03/2022.
//

#include "Formatter.h"
#include "Macros.h"

#include <utility>
#include "iostream"

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *) {
    return facebook::jni::initialize(vm, [] {
        jsiFormatter::Formatter::registerNatives();
    });
};

namespace jsiFormatter {

using namespace facebook;
using namespace facebook::jni;
using namespace facebook::jsi;


using TSelf = local_ref<HybridClass<Formatter>::jhybriddata>;

// JNI binding
void Formatter::registerNatives() {
    __android_log_print(ANDROID_LOG_ERROR, "Formatter", "🥸 registerNatives");
    registerHybrid({
       makeNativeMethod("initHybrid", Formatter::initHybrid),
       makeNativeMethod("installJSIBindings", Formatter::installJSIBindings),
   });
}

void Formatter::installJSIBindings() {
    auto exportModule = jsi::Object(*_runtime);

    auto chatLikeFormat = JSI_HOST_FUNCTION("chatLikeFormat", 1) {
        auto rawDate = args[0].asNumber();

        auto method = javaPart_->getClass()->getMethod<JString(double)>("chatLikeFormat");
        auto response = method(javaPart_.get(), rawDate);
        return jsi::String::createFromUtf8(runtime, response->toStdString());
    });

    auto hoursMinutes = JSI_HOST_FUNCTION("hoursMinutes", 1) {
        auto rawDate = args[0].asNumber();

        auto method = javaPart_->getClass()->getMethod<JString(double)>("hoursMinutes");
        auto response = method(javaPart_.get(), rawDate);
        return jsi::String::createFromUtf8(runtime, response->toStdString());
    });

    auto formatElapsedTime = JSI_HOST_FUNCTION("formatElapsedTime", 1) {
        auto rawDate = args[0].asNumber();

        auto method = javaPart_->getClass()->getMethod<JString(double)>("formatElapsedTime");
        auto response = method(javaPart_.get(), rawDate);
        return jsi::String::createFromUtf8(runtime, response->toStdString());
    });

    auto format = JSI_HOST_FUNCTION("format", 2) {
        auto rawDate = args[0].asNumber();
        auto rawFormat = args[1].asString(runtime).utf8(runtime);

        auto localFormat = jni::make_jstring(rawFormat);
        auto method = javaPart_->getClass()->getMethod<JString(double, jni::local_ref<JString>)>("format");
        auto response = method(javaPart_.get(), rawDate, localFormat);
        return jsi::String::createFromUtf8(runtime, response->toStdString());
    });

    auto simpleFormat = JSI_HOST_FUNCTION("simpleFormat", 1) {
        auto rawDate = args[0].asNumber();
        auto method = javaPart_->getClass()->getMethod<JString(double)>("simpleFormat");
        auto response = method(javaPart_.get(), rawDate);
        return jsi::String::createFromUtf8(runtime, response->toStdString());
    });

    auto timeAgo = JSI_HOST_FUNCTION("timeAgo", 2) {
        auto rawDate = args[0].asNumber();
        auto style = args[1].asString(runtime).utf8(runtime);

        auto localStyle = jni::make_jstring(style);
        auto method = javaPart_->getClass()->getMethod<JString(double, jni::local_ref<JString>)>("timeAgo");
        auto response = method(javaPart_.get(), rawDate, localStyle);
        return jsi::String::createFromUtf8(runtime, response->toStdString());
    });

    auto fromNow = JSI_HOST_FUNCTION("fromNow", 1) {
        auto rawDate = args[0].asNumber();
        auto method = javaPart_->getClass()->getMethod<JString(double)>("fromNow");
        auto response = method(javaPart_.get(), rawDate);
        return jsi::String::createFromUtf8(runtime, response->toStdString());
    });

    auto formatCurrency = JSI_HOST_FUNCTION("formatCurrency", 1) {
       auto rawValue = args[0].asNumber();
         std::string rawSymbol = "current";
         if (!args[1].isNull() && !args[1].isUndefined() && args[1].isString()) {
             rawSymbol = args[1].asString(runtime).utf8(runtime);
         }
     auto symbol = jni::make_jstring(rawSymbol);
       auto method = javaPart_->getClass()->getMethod<JString(double, jni::local_ref<JString>)>("formatCurrency");
       auto response = method(javaPart_.get(), rawValue, symbol);
       return jsi::String::createFromUtf8(runtime, response->toStdString());
    });

    auto localizeNumbers = JSI_HOST_FUNCTION("formatCurrency", 2) {
        auto rawValue = args[0].asNumber();
        auto rawIsFloat = args[1].getBool();

         auto method = javaPart_->getClass()->getMethod<JString(double, bool)>("formatCurrency");
         auto response = method(javaPart_.get(), rawValue, rawIsFloat);
         return jsi::String::createFromUtf8(runtime, response->toStdString());
    });

    auto setLocale = JSI_HOST_FUNCTION("setLocale", 1) {
        auto rawLocale = args[0].asString(runtime).utf8(runtime);
        auto locale = jni::make_jstring(rawLocale);
        auto method = javaPart_->getClass()->getMethod<jboolean(jni::local_ref<JString>)>("setLocale");
        auto response = method(javaPart_.get(), locale);
        return {response == 1};
    });

    auto getLocale = JSI_HOST_FUNCTION("getLocale", 0) {
        auto method = javaPart_->getClass()->getMethod<JString()>("getLocale");
        auto response = method(javaPart_.get());
       auto str = response->toStdString();
       return jsi::Value::createFromJsonUtf8(runtime, reinterpret_cast<const uint8_t *>(str.c_str()), str.size());
    });

    auto availableLocales = JSI_HOST_FUNCTION("availableLocales", 0) {
        auto method = javaPart_->getClass()->getMethod<JString()>("availableLocales");
        auto response = method(javaPart_.get());

        auto str = response->toStdString();
        return jsi::Value::createFromJsonUtf8(runtime, reinterpret_cast<const uint8_t *>(str.c_str()), str.size());
    });

    auto is24HourClock = JSI_HOST_FUNCTION("is24HourClock", 0) {
       auto method = javaPart_->getClass()->getMethod<jboolean()>("is24HourClock");
       auto response = method(javaPart_.get());
       return {response == 1};
    });

    exportModule.setProperty(*_runtime, "chatLikeFormat", std::move(chatLikeFormat));
    exportModule.setProperty(*_runtime, "hoursMinutes", std::move(hoursMinutes));
    exportModule.setProperty(*_runtime, "formatElapsedTime", std::move(formatElapsedTime));
    exportModule.setProperty(*_runtime, "format", std::move(format));
    exportModule.setProperty(*_runtime, "simpleFormat", std::move(simpleFormat));
    exportModule.setProperty(*_runtime, "timeAgo", std::move(timeAgo));
    exportModule.setProperty(*_runtime, "fromNow", std::move(fromNow));
    exportModule.setProperty(*_runtime, "setLocale", std::move(setLocale));
    exportModule.setProperty(*_runtime, "getLocale", std::move(getLocale));
    exportModule.setProperty(*_runtime, "availableLocales", std::move(availableLocales));
    exportModule.setProperty(*_runtime, "formatCurrency", std::move(formatCurrency));
    exportModule.setProperty(*_runtime, "localizeNumbers", std::move(localizeNumbers));
    exportModule.setProperty(*_runtime, "is24HourClock", std::move(is24HourClock));
    _runtime->global().setProperty(*_runtime, "__formatter", exportModule);
}


Formatter::Formatter(jni::alias_ref<Formatter::javaobject> jThis,jsi::Runtime *rt)
        : javaPart_(jni::make_global(jThis)),
          _runtime(rt)
          {}

// JNI init
TSelf Formatter::initHybrid(alias_ref<jhybridobject> jThis,jlong jsContext) {
    __android_log_print(ANDROID_LOG_ERROR, "Formatter", "🥸 initHybrid");
    return makeCxxInstance(jThis,(jsi::Runtime *) jsContext);
}

}
