import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { formatter } from 'react-native-formatter';

export default function App() {
  formatter.locale.setNew('en_EN')

  return (
    <View style={styles.container}>
      <Text>currency: {formatter.currency.format(12934.4348943, '$')}</Text>
      <Text>numbers: {formatter.numbers.format(12934.4348943, true)}</Text>
      <Text>simple: {formatter.date.simpleFormat(Date.now())}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor:'white'
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
