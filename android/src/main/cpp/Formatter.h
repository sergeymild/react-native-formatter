#include <fbjni/fbjni.h>
#include <jsi/jsi.h>
#include <ReactCommon/CallInvokerHolder.h>
#include <fbjni/detail/References.h>
#import "map"

namespace jsiFormatter {

    using namespace facebook::jsi;

    class Formatter : public facebook::jni::HybridClass<Formatter> {
    public:
        static constexpr auto kJavaDescriptor = "Lcom/reactnativeformatter/Formatter;";

        static facebook::jni::local_ref<jhybriddata> initHybrid(
                facebook::jni::alias_ref<jhybridobject> jThis,
                jlong jsContext
        );

        static void registerNatives();

        void installJSIBindings();

    private:
        friend HybridBase;
        facebook::jni::global_ref<Formatter::javaobject> javaPart_;
        facebook::jsi::Runtime *_runtime;

        explicit Formatter(
                facebook::jni::alias_ref<Formatter::jhybridobject> jThis,
                facebook::jsi::Runtime *rt
        );
    };

}
