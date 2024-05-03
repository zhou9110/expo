const path = require('path');

const baseConfig = require('../bare-expo/metro.config');

baseConfig.watchFolders.unshift(__dirname, path.join(__dirname, '../bare-expo'));

module.exports = baseConfig;
