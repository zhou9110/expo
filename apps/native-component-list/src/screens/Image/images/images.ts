const images = {
  require_jpg1: require('../../../../assets/images/example1.jpg'),
  require_jpg2: require('../../../../assets/images/example2.jpg'),
  require_jpg3: require('../../../../assets/images/example3.jpg'),
  require_png: require('../../../../assets/images/chapeau.png'),
  require_webp: require('../../../../assets/images/example4.webp'),
  require_webp_anim: require('../../../../assets/videos/ace.webp'),
  require_svg: require('../../../../assets/images/expo.svg'),
  require_highres: require('../../../../assets/images/highres.jpeg'),
  require_monochrome: require('../../../../assets/images/yellowwall.jpeg'),
  uri_random_unsplash: {
    uri: `https://source.unsplash.com/random?${Math.floor(Math.random() * 1000)}`,
  },
  uri_png: { uri: 'https://docs.expo.dev/static/images/header-logo.png' },
  uri_jpg: { uri: 'https://docs.expo.dev/static/images/notification-sound-ios.jpg' },
  uri_gif: { uri: 'https://docs.expo.dev/static/images/blur-opacity-example.gif' },
  uri_ico: { uri: 'https://docs.expo.dev/static/images/favicon.ico' },
  uri_rn_svg: {
    uri: 'https://d33wubrfki0l68.cloudfront.net/554c3b0e09cf167f0281fda839a5433f2040b349/ecfc9/img/header_logo.svg',
  },
};

export default images;
