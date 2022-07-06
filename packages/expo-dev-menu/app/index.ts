console.log("dupa");
global.setImmediate = () => {console.trace();};

require("react-native/Libraries/ReactPrivate/ReactNativePrivateInitializeCore");
console.log("dupa");

import { AppRegistry } from 'react-native';
import { enableScreens } from 'react-native-screens';

import { App } from './App';

enableScreens(false);

AppRegistry.registerComponent('main', () => App);
