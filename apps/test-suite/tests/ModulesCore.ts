import { EventEmitter } from 'expo-modules-core';

type EventsMap = {
  testSimple();
};

export const name = 'ModulesCore';

export function test({ describe, expect, it, beforeAll, beforeEach, afterEach, ...t }) {
  describe('EventEmitter', () => {
    it('addListener returns a subscription', () => {
      const emitter = new EventEmitter<EventsMap>();
      const subscription = emitter.addListener('testSimple', () => {});

      expect(subscription).toBeTruthy();
      // @ts-expect-error
      expect(typeof subscription.remove).toEqual('function');
    });

    it('adds and removes a listener', () => {
      const emitter = new EventEmitter<EventsMap>();
      const listener = () => {};

      emitter.addListener('testSimple', listener);
      emitter.removeListener('testSimple', listener);
    });

    it('removes a listener from subscription', () => {
      const emitter = new EventEmitter<EventsMap>();
      const subscription = emitter.addListener('testSimple', () => {});

      // @ts-expect-error
      subscription.remove();
    });
  });
}
