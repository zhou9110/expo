export UPDATES_PORT=4747
export UPDATES_HOST=$(ifconfig -l | xargs -n1 ipconfig getifaddr)
export ARTIFACTS_DEST=$TMPDIR/artifacts
export EXPO_REPO_ROOT=$(pwd)
export EXPO_UPDATES_ROOT=$EXPO_REPO_ROOT/packages/expo-updates
export WORKING_DIR=/Users/dlowder/iosProjects/e2e-working-dir

if [[ -d "$WORKING_DIR" ]]
then
  echo "Cleaning $WORKING_DIR"
  rm -rf $WORKING_DIR
else
  echo "Creating $WORKING_DIR"
  mkdir $WORKING_DIR
fi
cd $EXPO_UPDATES_ROOT; yarn build:cli; cd -
node packages/expo-updates/e2e/__tests__/setup/index.js
cd $EXPO_UPDATES_ROOT; yarn test --verbose --config e2e/jest.config.ios.js e2e/__tests__/Updates-e2e.test.ts; cd -
