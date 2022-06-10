const path = require('path');

const { buildAsync: buildAndroidAsync } = require('./build-android');
const { buildAsync: buildIosAsync } = require('./build-ios');
const { setupAsync } = require('./project');

const repoRoot = process.env.EXPO_REPO_ROOT;
const artifactsDest = process.env.ARTIFACTS_DEST;

const workingDir = process.env.WORKING_DIR || path.resolve(repoRoot, '..');
const runtimeVersion = '1.0.0';

(async function () {
  const projectRoot = await setupAsync(workingDir, repoRoot, runtimeVersion);
  await buildIosAsync(projectRoot, artifactsDest);
  await buildAndroidAsync(projectRoot, artifactsDest);
})();
