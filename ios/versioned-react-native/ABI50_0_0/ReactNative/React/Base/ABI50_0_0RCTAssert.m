/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTAssert.h"
#import "ABI50_0_0RCTLog.h"

NSString *const ABI50_0_0RCTErrorDomain = @"ABI50_0_0RCTErrorDomain";
NSString *const ABI50_0_0RCTJSStackTraceKey = @"ABI50_0_0RCTJSStackTraceKey";
NSString *const ABI50_0_0RCTJSRawStackTraceKey = @"ABI50_0_0RCTJSRawStackTraceKey";
NSString *const ABI50_0_0RCTObjCStackTraceKey = @"ABI50_0_0RCTObjCStackTraceKey";
NSString *const ABI50_0_0RCTFatalExceptionName = @"ABI50_0_0RCTFatalException";
NSString *const ABI50_0_0RCTUntruncatedMessageKey = @"ABI50_0_0RCTUntruncatedMessageKey";
NSString *const ABI50_0_0RCTJSExtraDataKey = @"ABI50_0_0RCTJSExtraDataKey";

static NSString *const ABI50_0_0RCTAssertFunctionStack = @"ABI50_0_0RCTAssertFunctionStack";

ABI50_0_0RCTAssertFunction ABI50_0_0RCTCurrentAssertFunction = nil;
ABI50_0_0RCTFatalHandler ABI50_0_0RCTCurrentFatalHandler = nil;
ABI50_0_0RCTFatalExceptionHandler ABI50_0_0RCTCurrentFatalExceptionHandler = nil;

NSException *_ABI50_0_0RCTNotImplementedException(SEL, Class);
NSException *_ABI50_0_0RCTNotImplementedException(SEL cmd, Class cls)
{
  NSString *msg = [NSString stringWithFormat:
                                @"%s is not implemented "
                                 "for the class %@",
                                sel_getName(cmd),
                                cls];
  return [NSException exceptionWithName:@"ABI50_0_0RCTNotDesignatedInitializerException" reason:msg userInfo:nil];
}

void ABI50_0_0RCTSetAssertFunction(ABI50_0_0RCTAssertFunction assertFunction)
{
  ABI50_0_0RCTCurrentAssertFunction = assertFunction;
}

ABI50_0_0RCTAssertFunction ABI50_0_0RCTGetAssertFunction(void)
{
  return ABI50_0_0RCTCurrentAssertFunction;
}

void ABI50_0_0RCTAddAssertFunction(ABI50_0_0RCTAssertFunction assertFunction)
{
  ABI50_0_0RCTAssertFunction existing = ABI50_0_0RCTCurrentAssertFunction;
  if (existing) {
    ABI50_0_0RCTCurrentAssertFunction =
        ^(NSString *condition, NSString *fileName, NSNumber *lineNumber, NSString *function, NSString *message) {
          existing(condition, fileName, lineNumber, function, message);
          assertFunction(condition, fileName, lineNumber, function, message);
        };
  } else {
    ABI50_0_0RCTCurrentAssertFunction = assertFunction;
  }
}

/**
 * returns the topmost stacked assert function for the current thread, which
 * may not be the same as the current value of ABI50_0_0RCTCurrentAssertFunction.
 */
static ABI50_0_0RCTAssertFunction ABI50_0_0RCTGetLocalAssertFunction(void)
{
  NSMutableDictionary *threadDictionary = [NSThread currentThread].threadDictionary;
  NSArray<ABI50_0_0RCTAssertFunction> *functionStack = threadDictionary[ABI50_0_0RCTAssertFunctionStack];
  ABI50_0_0RCTAssertFunction assertFunction = functionStack.lastObject;
  if (assertFunction) {
    return assertFunction;
  }
  return ABI50_0_0RCTCurrentAssertFunction;
}

void ABI50_0_0RCTPerformBlockWithAssertFunction(void (^block)(void), ABI50_0_0RCTAssertFunction assertFunction)
{
  NSMutableDictionary *threadDictionary = [NSThread currentThread].threadDictionary;
  NSMutableArray<ABI50_0_0RCTAssertFunction> *functionStack = threadDictionary[ABI50_0_0RCTAssertFunctionStack];
  if (!functionStack) {
    functionStack = [NSMutableArray new];
    threadDictionary[ABI50_0_0RCTAssertFunctionStack] = functionStack;
  }
  [functionStack addObject:assertFunction];
  block();
  [functionStack removeLastObject];
}

NSString *ABI50_0_0RCTCurrentThreadName(void)
{
  NSThread *thread = [NSThread currentThread];
  NSString *threadName = ABI50_0_0RCTIsMainQueue() || thread.isMainThread ? @"main" : thread.name;
  if (threadName.length == 0) {
    const char *label = dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL);
    if (label && strlen(label) > 0) {
      threadName = @(label);
    } else {
      threadName = [NSString stringWithFormat:@"%p", thread];
    }
  }
  return threadName;
}

void _ABI50_0_0RCTAssertFormat(
    const char *condition,
    const char *fileName,
    int lineNumber,
    const char *function,
    NSString *format,
    ...)
{
  ABI50_0_0RCTAssertFunction assertFunction = ABI50_0_0RCTGetLocalAssertFunction();
  if (assertFunction) {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    assertFunction(@(condition), @(fileName), @(lineNumber), @(function), message);
  }
}

void ABI50_0_0RCTFatal(NSError *error)
{
  _ABI50_0_0RCTLogNativeInternal(ABI50_0_0RCTLogLevelFatal, NULL, 0, @"%@", error.localizedDescription);

  ABI50_0_0RCTFatalHandler fatalHandler = ABI50_0_0RCTGetFatalHandler();
  if (fatalHandler) {
    fatalHandler(error);
  } else {
#if DEBUG
    @try {
#endif
      NSString *name = [NSString stringWithFormat:@"%@: %@", ABI50_0_0RCTFatalExceptionName, error.localizedDescription];

      // Truncate the localized description to 175 characters to avoid wild screen overflows
      NSString *message = ABI50_0_0RCTFormatError(error.localizedDescription, error.userInfo[ABI50_0_0RCTJSStackTraceKey], 175);

      // Attach an untruncated copy of the description to the userInfo, in case it is needed
      NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
      [userInfo setObject:ABI50_0_0RCTFormatError(error.localizedDescription, error.userInfo[ABI50_0_0RCTJSStackTraceKey], -1)
                   forKey:ABI50_0_0RCTUntruncatedMessageKey];

      // Expected resulting exception information:
      // name: ABI50_0_0RCTFatalException: <underlying error description>
      // reason: <underlying error description plus JS stack trace, truncated to 175 characters>
      // userInfo: <underlying error userinfo, plus untruncated description plus JS stack trace>
      @throw [[NSException alloc] initWithName:name reason:message userInfo:userInfo];
#if DEBUG
    } @catch (NSException *e) {
    }
#endif
  }
}

void ABI50_0_0RCTSetFatalHandler(ABI50_0_0RCTFatalHandler fatalHandler)
{
  ABI50_0_0RCTCurrentFatalHandler = fatalHandler;
}

ABI50_0_0RCTFatalHandler ABI50_0_0RCTGetFatalHandler(void)
{
  return ABI50_0_0RCTCurrentFatalHandler;
}

NSString *
ABI50_0_0RCTFormatError(NSString *message, NSArray<NSDictionary<NSString *, id> *> *stackTrace, NSUInteger maxMessageLength)
{
  if (maxMessageLength > 0 && message.length > maxMessageLength) {
    message = [[message substringToIndex:maxMessageLength] stringByAppendingString:@"..."];
  }

  NSString *prettyStack = ABI50_0_0RCTFormatStackTrace(stackTrace);

  return [NSString
      stringWithFormat:@"%@%@%@", message, prettyStack ? @", stack:\n" : @"", prettyStack ? prettyStack : @""];
}

NSString *ABI50_0_0RCTFormatStackTrace(NSArray<NSDictionary<NSString *, id> *> *stackTrace)
{
  if (stackTrace) {
    NSMutableString *prettyStack = [NSMutableString string];

    NSRegularExpression *regex =
        [NSRegularExpression regularExpressionWithPattern:@"\\b((?:seg-\\d+(?:_\\d+)?|\\d+)\\.js)"
                                                  options:NSRegularExpressionCaseInsensitive
                                                    error:NULL];
    for (NSDictionary<NSString *, id> *frame in stackTrace) {
      NSString *fileName = [frame[@"file"] lastPathComponent];
      NSTextCheckingResult *match =
          fileName != nil ? [regex firstMatchInString:fileName options:0 range:NSMakeRange(0, fileName.length)] : nil;
      if (match) {
        fileName = [NSString stringWithFormat:@"%@:", [fileName substringWithRange:match.range]];
      } else {
        fileName = @"";
      }

      [prettyStack
          appendFormat:@"%@@%@%@:%@\n", frame[@"methodName"], fileName, frame[@"lineNumber"], frame[@"column"]];
    }

    return prettyStack;
  }
  return nil;
}

void ABI50_0_0RCTFatalException(NSException *exception)
{
  _ABI50_0_0RCTLogNativeInternal(ABI50_0_0RCTLogLevelFatal, NULL, 0, @"%@: %@", exception.name, exception.reason);

  ABI50_0_0RCTFatalExceptionHandler fatalExceptionHandler = ABI50_0_0RCTGetFatalExceptionHandler();
  if (fatalExceptionHandler) {
    fatalExceptionHandler(exception);
  } else {
#if DEBUG
    @try {
#endif
      @throw exception;
#if DEBUG
    } @catch (NSException *e) {
    }
#endif
  }
}

void ABI50_0_0RCTSetFatalExceptionHandler(ABI50_0_0RCTFatalExceptionHandler fatalExceptionHandler)
{
  ABI50_0_0RCTCurrentFatalExceptionHandler = fatalExceptionHandler;
}

ABI50_0_0RCTFatalExceptionHandler ABI50_0_0RCTGetFatalExceptionHandler(void)
{
  return ABI50_0_0RCTCurrentFatalExceptionHandler;
}

// MARK: - New Architecture Validation - Enable Reporting

#if ABI50_0_0RCT_ONLY_NEW_ARCHITECTURE
static ABI50_0_0RCTNotAllowedValidation minValidationLevel = ABI50_0_0RCTNotAllowedInBridgeless;
#else
static ABI50_0_0RCTNotAllowedValidation minValidationLevel = ABI50_0_0RCTNotAllowedValidationDisabled;
#endif

__attribute__((used)) ABI50_0_0RCT_EXTERN void ABI50_0_0RCTNewArchitectureSetMinValidationLevel(ABI50_0_0RCTNotAllowedValidation level)
{
#if ABI50_0_0RCT_ONLY_NEW_ARCHITECTURE
  // Cannot disable the reporting in this mode.
#else
  minValidationLevel = level;
#endif
}

// MARK: - New Architecture Validation - Private

static BOOL shouldEnforceValidation(ABI50_0_0RCTNotAllowedValidation type)
{
  return type >= minValidationLevel;
}

static NSString *stringDescribingContext(id context)
{
  if ([context isKindOfClass:NSString.class]) {
    return context;
  } else if (context) {
    Class klass = [context class];
    if (klass) {
      return NSStringFromClass(klass);
    }
  }
  return @"uncategorized";
}

static NSString *validationMessage(ABI50_0_0RCTNotAllowedValidation type, id context, NSString *extra)
{
  NSString *notAllowedType;
  switch (type) {
    case ABI50_0_0RCTNotAllowedValidationDisabled:
      ABI50_0_0RCTAssert(0, @"ABI50_0_0RCTNotAllowedValidationDisabled not a validation type.");
      return nil;
    case ABI50_0_0RCTNotAllowedInFabricWithoutLegacy:
      notAllowedType = @"Fabric";
      break;
    case ABI50_0_0RCTNotAllowedInBridgeless:
      notAllowedType = @"Bridgeless";
      break;
  }

  return
      [NSString stringWithFormat:@"[ABI50_0_0ReactNative Architecture][NotAllowedIn%@] Unexpectedly reached code path in %@. %@",
                                 notAllowedType,
                                 stringDescribingContext(context),
                                 extra ?: @""];
}

static void
newArchitectureValidationInternal(ABI50_0_0RCTLogLevel level, ABI50_0_0RCTNotAllowedValidation type, id context, NSString *extra)
{
  if (!shouldEnforceValidation(type)) {
    return;
  }

  NSString *msg = validationMessage(type, context, extra);
  if (msg) {
    switch (level) {
      case ABI50_0_0RCTLogLevelInfo:
        ABI50_0_0RCTLogInfo(@"%@", msg);
        break;
      case ABI50_0_0RCTLogLevelError:
        ABI50_0_0RCTLogError(@"%@", msg);
        break;
      case ABI50_0_0RCTLogLevelFatal:
        ABI50_0_0RCTAssert(0, @"%@", msg);
        break;
      default:
        ABI50_0_0RCTAssert(0, @"New architecture validation is only for info, error, and fatal levels.");
    }
  }
}

// MARK: - New Architecture Validation - Public

void ABI50_0_0RCTEnforceNewArchitectureValidation(ABI50_0_0RCTNotAllowedValidation type, id context, NSString *extra)
{
  newArchitectureValidationInternal(ABI50_0_0RCTLogLevelFatal, type, context, extra);
}

void ABI50_0_0RCTErrorNewArchitectureValidation(ABI50_0_0RCTNotAllowedValidation type, id context, NSString *extra)
{
#if ABI50_0_0RCT_ONLY_NEW_ARCHITECTURE
  newArchitectureValidationInternal(ABI50_0_0RCTLogLevelFatal, type, context, extra);
#else
  newArchitectureValidationInternal(ABI50_0_0RCTLogLevelError, type, context, extra);
#endif
}

void ABI50_0_0RCTLogNewArchitectureValidation(ABI50_0_0RCTNotAllowedValidation type, id context, NSString *extra)
{
  newArchitectureValidationInternal(ABI50_0_0RCTLogLevelInfo, type, context, extra);
}

void ABI50_0_0RCTNewArchitectureValidationPlaceholder(ABI50_0_0RCTNotAllowedValidation type, id context, NSString *extra)
{
#if ABI50_0_0RCT_ONLY_NEW_ARCHITECTURE
  newArchitectureValidationInternal(ABI50_0_0RCTLogLevelInfo, type, context, extra);
#endif
}
