package com.reactnativeformatter;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;

@ReactModule(name = FormatterModule.NAME)
public class FormatterModule extends ReactContextBaseJavaModule {
    public static final String NAME = "Formatter";
  private Formatter formatter;

    public FormatterModule(ReactApplicationContext reactContext) {
        super(reactContext);
      formatter = new Formatter(reactContext);
    }

    @Override
    @NonNull
    public String getName() {
        return NAME;
    }


  @ReactMethod(isBlockingSynchronousMethod = true)
  public void install() {
    formatter.install(getReactApplicationContext());
  }

}
