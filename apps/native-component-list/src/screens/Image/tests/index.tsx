import { ImageTestGroup } from '../types';
import AppearanceTests from './appearance';
import BorderTests from './borders';
import ShadowsTests from './shadows';
import SourcesTests from './sources';

const tests: ImageTestGroup = {
  name: 'Image',
  tests: [SourcesTests], //[AppearanceTests, BorderTests, ShadowsTests, SourcesTests],
};

export default tests;
