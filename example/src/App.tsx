import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { formatter } from 'react-native-formatter';

export default function App() {
  formatter.locale.setNew('en_US')

  return (
    <View style={styles.container}>
      <Text>currency: {formatter.currency.format(12934.4348943)}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
