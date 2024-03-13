"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.getDevServer = void 0;
const getDevServer = () => {
  // Disable for SSR
  if (typeof window === 'undefined') {
    return {
      bundleLoadedFromServer: true,
      fullBundleUrl: '',
      url: ''
    };
  }
  return {
    // The bundle is always loaded from a server in the browser.
    bundleLoadedFromServer: true,
    /** URL but ensures that platform query param is added. */
    get fullBundleUrl() {
      if (document?.currentScript && 'src' in document.currentScript) {
        return document.currentScript.src;
      }
      const bundleUrl = new URL(location.href);
      bundleUrl.searchParams.set('platform', 'web');
      return bundleUrl.toString();
    },
    url: location.origin + '/'
  };
};
exports.getDevServer = getDevServer;
//# sourceMappingURL=index.js.map