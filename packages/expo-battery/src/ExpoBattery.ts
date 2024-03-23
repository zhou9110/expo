import { requireNativeModule } from 'expo-modules-core';

import type { BatteryModule } from './Battery.types';

export default requireNativeModule<BatteryModule>('ExpoBattery');
