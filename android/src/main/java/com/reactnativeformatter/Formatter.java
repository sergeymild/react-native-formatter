package com.reactnativeformatter;

import android.content.Context;
import android.icu.text.DecimalFormat;
import android.icu.text.DecimalFormatSymbols;
import android.icu.text.NumberFormat;
import android.icu.util.Currency;
import android.text.format.DateUtils;

import com.facebook.jni.HybridData;
import com.facebook.proguard.annotations.DoNotStrip;
import com.facebook.react.bridge.JavaScriptContextHolder;
import com.facebook.react.bridge.ReactApplicationContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.ocpsoft.prettytime.PrettyTime;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.MissingResourceException;
import java.util.Objects;

import javax.annotation.Nullable;

@DoNotStrip
public class Formatter {
  @DoNotStrip
  private HybridData mHybridData;

  public Formatter(Context context) {
    this.context = context.getApplicationContext();
  }

  @SuppressWarnings("JavaJniMissingFunction")
  public native HybridData initHybrid(long jsContext);

  @SuppressWarnings("JavaJniMissingFunction")
  public native void installJSIBindings();

  private Context context;
  private boolean is24hoursFormat = false;
  private Locale currentLocale;
  private Locale[] availableLocales;
  private Map<String, Locale> availableLocalesMap;
  private NumberFormat currencyFormatter;
  private NumberFormat numberFormatter;
  private String currencySymbol;

  boolean install(ReactApplicationContext context) {
    System.loadLibrary("react-native-formatter");
    JavaScriptContextHolder jsContext = context.getJavaScriptContextHolder();
    mHybridData = initHybrid(jsContext.get());
    installJSIBindings();
    is24hoursFormat = android.text.format.DateFormat.is24HourFormat(context);
    currentLocale = Locale.getDefault();
    setCurrencyFormatter();
    return true;
  }

  private void setCurrencyFormatter() {
    currencyFormatter = NumberFormat.getCurrencyInstance();
    currencyFormatter.setCurrency(Currency.getInstance(currentLocale));
    currencySymbol = currencyFormatter.getCurrency().getSymbol();

    numberFormatter = NumberFormat.getNumberInstance();
  }

  private boolean isDateInCurrentWeek(Date date) {
    Calendar currentCalendar = Calendar.getInstance();
    int week = currentCalendar.get(Calendar.WEEK_OF_YEAR);
    int year = currentCalendar.get(Calendar.YEAR);
    Calendar targetCalendar = Calendar.getInstance();
    targetCalendar.setTime(date);
    int targetWeek = targetCalendar.get(Calendar.WEEK_OF_YEAR);
    int targetYear = targetCalendar.get(Calendar.YEAR);
    return week == targetWeek && year == targetYear;
  }

  private DateFormat getHoursMinutesFormatter() {
    return DateFormat.getTimeInstance(SimpleDateFormat.SHORT);
  }

  private SimpleDateFormat getShortWeekNameFormatter() {
    return new SimpleDateFormat("EEE", currentLocale);
  }

  private DateFormat getShortDateFormatter() {
    return DateFormat.getDateInstance(SimpleDateFormat.SHORT, currentLocale);
  }

  private boolean isValid(Locale locale) {
    try {
      return !locale.getISO3Language().isEmpty();
    } catch (MissingResourceException e) {
      return false;
    }
  }

  private void fillAvailableLocales() {
    if (availableLocales != null) return;
    availableLocales = Locale.getAvailableLocales();
    availableLocalesMap = new HashMap<>(availableLocales.length);
    for (Locale locale : availableLocales) {
      availableLocalesMap.put(locale.toString(), locale);
    }
  }

  @Nullable
  private Locale findLocale(String raw) {
    fillAvailableLocales();
    return availableLocalesMap.get(raw);
  }

  @DoNotStrip
  public String chatLikeFormat(double rawDate) {
    Date date = new Date((long) rawDate);
    if (DateUtils.isToday((long) rawDate)) {
      return getHoursMinutesFormatter().format(date);
    }
    if (isDateInCurrentWeek(date)) {
      return getShortWeekNameFormatter().format(date);
    }
    return getShortDateFormatter().format(date);
  }

  @DoNotStrip
  public String hoursMinutes(double rawDate) {
    Date date = new Date((long) rawDate);
    return getHoursMinutesFormatter().format(date);
  }

  @DoNotStrip
  public String formatElapsedTime(double rawDate) {
    return DateUtils.formatElapsedTime((long) rawDate);
  }


  @DoNotStrip
  public String format(double rawDate, String format) {
    Date date = new Date((long) rawDate);
    SimpleDateFormat format1 = new SimpleDateFormat(format, currentLocale);
    return format1.format(date);
  }

  @DoNotStrip
  public String simpleFormat(double rawDate) {
    Date date = new Date((long) rawDate);
    return SimpleDateFormat.getDateInstance(SimpleDateFormat.SHORT, currentLocale).format(date);
  }

  @DoNotStrip
  public String timeAgo(double rawDate, String style) {
    Date date = new Date((long) rawDate);
    PrettyTime prettyTime = new PrettyTime(currentLocale);
    return prettyTime.format(date);
  }

  @DoNotStrip
  public String fromNow(double rawDate) {
    Date date = new Date((long) rawDate);
    PrettyTime prettyTime = new PrettyTime(currentLocale);
    return prettyTime.format(date);
  }

  @DoNotStrip
  public boolean is24HourClock() {
    return is24hoursFormat;
  }

  @DoNotStrip
  public String availableLocales() {
    fillAvailableLocales();
    JSONArray array = new JSONArray();
    for (int i = 0; i < availableLocales.length; i++) {
      try {
        JSONObject object = new JSONObject();
        Locale locale = availableLocales[i];
        object.put("displayName", locale.getDisplayLanguage(locale));
        object.put("name", locale.getDisplayLanguage(currentLocale));
        object.put("code", locale.getLanguage());
        object.put("changeCode", locale.toString());
        array.put(i, object);
      } catch (JSONException e) {
        e.printStackTrace();
      }
    }
    return array.toString();
  }

  @DoNotStrip
  public boolean setLocale(String locale) {
    Locale newLocale = findLocale(locale);
    if (newLocale == null) return false;
    currentLocale = newLocale;
    setCurrencyFormatter();
    return true;
  }

  @DoNotStrip
  public String getLocale() {
    try {
      JSONObject object = new JSONObject();
      Locale locale = currentLocale;
      object.put("displayName", locale.getDisplayLanguage(locale));
      object.put("name", locale.getDisplayLanguage(currentLocale));
      object.put("code", locale.getLanguage());
      object.put("changeCode", locale.toString());
      return object.toString();
    } catch (JSONException e) {
      throw new RuntimeException(e);
    }
  }


  @DoNotStrip
  public String formatCurrency(double value, String symbol) {
    DecimalFormatSymbols decimalFormatSymbols = ((DecimalFormat) currencyFormatter).getDecimalFormatSymbols();
    decimalFormatSymbols.setCurrencySymbol(Objects.equals(symbol, "current") ? currencySymbol : symbol);
    ((DecimalFormat)currencyFormatter).setDecimalFormatSymbols(decimalFormatSymbols);
    return currencyFormatter.format(value);
  }

  @DoNotStrip
  public String formatCurrency(double value, boolean isFloat) {
    return numberFormatter.format(value);
  }
}
