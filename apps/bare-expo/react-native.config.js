// Explicitly turn off react-native autolinking for bare-expo
module.exports = {
  dependency: {
    platforms: {
      ios: null,
      android: null,
    },
  },
};
