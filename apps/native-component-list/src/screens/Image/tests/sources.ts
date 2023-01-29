import { images } from '../images';
import { ImageTestGroup } from '../types';

const imageTests: ImageTestGroup = {
  name: 'Sources',
  tests: [
    // {
    //   name: `uri:.webp`,
    //   props: {
    //     source: images.require_webp,
    //   },
    // },
    // {
    //   name: `uri:.webp (animated)`,
    //   props: {
    //     source: images.require_webp_anim,
    //   },
    // },
    // {
    //   name: `uri:.jpg (redirecting)`,
    //   props: {
    //     source: images.uri_random_unsplash,
    //   },
    // },
    // {
    //   name: `require(1.jpg)`,
    //   props: {
    //     source: images.require_jpg1,
    //   },
    // },
    // {
    //   name: `require(2.jpg)`,
    //   props: {
    //     source: images.require_jpg2,
    //   },
    // },
    // {
    //   name: `require(.png)`,
    //   props: {
    //     source: images.require_png,
    //   },
    // },
    {
      name: `require(expo.svg)`,
      props: {
        source: images.require_svg,
        // resizeMode: 'contain',
      },
    },
    {
      name: `uri: react-native.svg`,
      props: {
        source:
          'https://d33wubrfki0l68.cloudfront.net/554c3b0e09cf167f0281fda839a5433f2040b349/ecfc9/img/header_logo.svg',
      },
    },
    // {
    //   name: `uri:.png`,
    //   props: {
    //     source: images.uri_png,
    //   },
    // },
    // {
    //   name: `uri:.jpg`,
    //   props: {
    //     source: images.uri_jpg,
    //   },
    // },
    // {
    //   name: `uri:.gif`,
    //   props: {
    //     source: images.uri_gif,
    //   },
    // },
    // {
    //   name: `uri:.ico`,
    //   props: {
    //     source: images.uri_ico,
    //   },
    // },
    // {
    //   name: `uri:.ico and intrinsic content size`,
    //   props: {
    //     source: images.uri_ico,
    //   },
    // },
    // {
    //   name: `uri:.svg`,
    //   props: {
    //     source: images.uri_rn_svg,
    //     resizeMode: 'contain',
    //   },
    // },
  ],
};

export default imageTests;
