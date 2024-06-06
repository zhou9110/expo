import { vol } from 'memfs';

import { resolveProjectTransitiveDependency } from '../resolvePackage';

jest.mock('fs');
jest.mock('resolve-from');

describe(resolveProjectTransitiveDependency, () => {
  afterEach(() => {
    vol.reset();
  });

  it('should return null if dependency is not found', () => {
    const depPath = resolveProjectTransitiveDependency('/app', 'not-found');
    expect(depPath).toBe(null);
  });

  it('should support direct dependency', () => {
    vol.fromJSON({
      '/app/package.json': '{}',
      '/app/node_modules/expo/package.json': '{}',
    });
    const depPath = resolveProjectTransitiveDependency('/app', 'expo');
    expect(depPath).toBe('/app/node_modules/expo');
  });

  it('should support transitive dependency', () => {
    // Since the mocked resolve-from does not support package hoisting, we need to put package nested in node_modules.
    vol.fromJSON({
      '/app/package.json': '{}',
      '/app/node_modules/react-native/package.json': '{}',
      '/app/node_modules/react-native/node_modules/@react-native/community-cli-plugin/package.json':
        '{}',
      '/app/node_modules/react-native/node_modules/@react-native/community-cli-plugin/node_modules/@react-native/dev-middleware/package.json':
        '{}',
    });
    const depPath = resolveProjectTransitiveDependency(
      '/app',
      'react-native',
      '@react-native/community-cli-plugin',
      '@react-native/dev-middleware'
    );
    expect(depPath).toBe(
      '/app/node_modules/react-native/node_modules/@react-native/community-cli-plugin/node_modules/@react-native/dev-middleware'
    );
  });
});
