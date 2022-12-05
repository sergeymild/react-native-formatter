# React Native JSI date formatter
Format date on Native Side
## Installation

```sh
"react-native-formatter": "sergeymild/react-native-formatter#0.15.0"
```

## Usage

```js
import { formatter } from 'react-native-date-formatter';

// ...
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

// represents date like in telegram chats
// for example if date is today it will returns `time`
// for example if date in current week it will returns `name of week`
// or yyyy.mm.dd formatted for certain locale
// accepts date in mills or string `YYYY-MM-DDTHH:mm:ss.sssZ` format
formatter.date.chatLikeFormat(Date.now())
// return HH:mm of h:mm a if is 24 hours enabled on phone
// accepts date in mills or string `YYYY-MM-DDTHH:mm:ss.sssZ` format
formatter.date.hoursMinutes(Date.now())
// just format date with passed pattern
// accepts date in mills or string `YYYY-MM-DDTHH:mm:ss.sssZ` format
formatter.date.format(Date.now(), 'dd MMM yyyy HH:mm')
//Short will return "12/13/52"
formatter.date.simpleFormat(Date.now())
// formatting of a relative date or time, such as "in 2 weeks", "in 3 months"
// accepts date in mills or string `YYYY-MM-DDTHH:mm:ss.sssZ` format
formatter.date.fromNow(futureTime)
// returns date string formatted as ISO 8601 (YYYY-MM-DDTHH:mm:ss.sssZ)
formatter.date.toISO8601format(date: number): string
// change current locale true - if success false otherwise
formatter.locale.setNew(locale: string): boolean;
// get current locales
formatter.locale.getCurrent(): Locale;
// get all available locales (performance consuming operations might need to cache)
formatter.locale.allAvailable(): Locale[];

// format value to current locale currency
// for example 12934.4348943 will be formatted to $12,934.43
formatter.currency.format(12934.4348943, hideSymbol?: boolean)
```


### For android needs add to Proguard
`-keep class org.ocpsoft.prettytime.i18n.**`

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
