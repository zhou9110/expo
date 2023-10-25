/**
 A protocol for classes that can emit events to JavaScript. Can be used with ``Module``, ``SharedObject`` and ``SharedRef`` classes.
 When the conformance is declared on these classes, the associated JavaScript objects will use the `EventEmitter` class prototype
 that implement the `addListener` and `removeListener` functions.
 */
public protocol EventEmitter: AnyObject {}
