import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-formatter' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const Formatter = NativeModules.Formatter
  ? NativeModules.Formatter
  : new Proxy(
    {},
    {
      get() {
        throw new Error(LINKING_ERROR);
      },
    }
  );

Formatter.install();

export interface Locale {
  // language code of locale
  code: string;
  // translated on original locale name
  displayName: string;
  // translated on current locale name
  name: string;
  // need pass to native for change locale
  changeCode: string;
}

declare global {
  var __formatter: {
    chatLikeFormat(date: number): string;
    hoursMinutes(date: number): string;
    format(date: number, format: string): string;
    simpleFormat(date: number): string;
    is24HourClock(): boolean;
    timeAgo(date: number, style: 'full' | 'spellOut'): string;
    fromNow(date: number): string;
    setLocale(locale: string): boolean;
    getLocale(): Locale;
    availableLocales(): Locale[];
    formatCurrency(value: number, symbol?: string): string;
  };
}

function toMills(date: number | string): number {
  if (typeof date === 'number') return date;
  if (!isIsoDate(date)) {
    throw new Error(`[dateIsNotISO8601Standard] ${date}`);
  }
  return new Date(date).getTime();
}

const ISO_REG = /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2,3}(.\d{3,6})?Z/;
function isIsoDate(date: string) {
  return ISO_REG.test(date);
}

export const formatter = {
  date: {
    chatLikeFormat(date: number | string): string {
      return __formatter.chatLikeFormat(toMills(date));
    },

    hoursMinutes(date: number | string): string {
      return __formatter.hoursMinutes(toMills(date));
    },

    format(date: number | string, format: string): string {
      return __formatter.format(toMills(date), format);
    },

    // full = 0, // "2 months ago"
    // spellOut, // "two months ago"
    timeAgo(date: number | string, style?: 'full' | 'spellOut'): string {
      return __formatter.timeAgo(toMills(date), style ?? 'full');
    },

    fromNow(date: number | string): string {
      return __formatter.timeAgo(toMills(date), 'full');
    },

    simpleFormat(date: number | string): string {
      return __formatter.simpleFormat(toMills(date));
    },

    isSameDay(left: number | string, right: number | string): boolean {
      left = toMills(left);
      right = toMills(right);
      return (
        __formatter.date.format(left, 'MM.dd.yyyy') ===
        __formatter.date.format(right, 'MM.dd.yyyy')
      );
    },

    get is24HourClock(): boolean {
      return __formatter.is24HourClock();
    },

    toISO8601format(date: number): string {
      return __formatter.format(date, "yyyy-MM-dd'T'HH:mm:ssZ");
    },
  },

  locale: {
    setNew(locale: string): boolean {
      return __formatter.setLocale(locale);
    },

    getCurrent(): Locale {
      return __formatter.getLocale();
    },

    allAvailable(): Locale[] {
      return __formatter.availableLocales();
    },
  },

  currency: {
    format(value: number, symbol?: string): string {
      return __formatter.formatCurrency(value, symbol)
    }
  }
}
