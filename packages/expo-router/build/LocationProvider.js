import { stripBaseUrl } from './fork/getStateFromPath';
export function getRouteInfoFromState(getPathFromState, state, baseUrl) {
    const { path } = getPathFromState(state, false);
    const qualified = getPathFromState(state, true);
    return {
        // TODO: This may have a predefined origin attached in the future.
        unstable_globalHref: path,
        pathname: stripBaseUrl(path, baseUrl).split('?')['0'],
        isIndex: isIndexPath(state),
        ...getNormalizedStatePath(qualified, baseUrl),
    };
}
function isIndexPath(state) {
    const route = state.routes[state.index ?? state.routes.length - 1];
    if (route.state) {
        return isIndexPath(route.state);
    }
    // router.params is typed as 'object', so this usual syntax is to please TypeScript
    if (route.params && 'screen' in route.params) {
        return route.params.screen === 'index';
    }
    return false;
}
// TODO: Split up getPathFromState to return all this info at once.
export function getNormalizedStatePath({ path: statePath, params, }, baseUrl) {
    const [pathname] = statePath.split('?');
    return {
        // Strip empty path at the start
        segments: stripBaseUrl(pathname, baseUrl).split('/').filter(Boolean).map(decodeURIComponent),
        // TODO: This is not efficient, we should generate based on the state instead
        // of converting to string then back to object
        params: Object.entries(params).reduce((prev, [key, value]) => {
            if (Array.isArray(value)) {
                prev[key] = value.map((v) => {
                    try {
                        return decodeURIComponent(v);
                    }
                    catch {
                        return v;
                    }
                });
            }
            else {
                try {
                    prev[key] = decodeURIComponent(value);
                }
                catch {
                    prev[key] = value;
                }
            }
            return prev;
        }, {}),
    };
}
//# sourceMappingURL=LocationProvider.js.map