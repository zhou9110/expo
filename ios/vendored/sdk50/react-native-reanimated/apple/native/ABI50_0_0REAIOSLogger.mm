#import <Foundation/Foundation.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAIOSLogger.h>

namespace ABI50_0_0reanimated {

std::unique_ptr<LoggerInterface> Logger::instance = std::make_unique<ABI50_0_0REAIOSLogger>();

void ABI50_0_0REAIOSLogger::log(const char *str)
{
  NSLog(@"%@", [NSString stringWithCString:str encoding:[NSString defaultCStringEncoding]]);
}

void ABI50_0_0REAIOSLogger::log(const std::string &str)
{
  log(str.c_str());
}

void ABI50_0_0REAIOSLogger::log(double d)
{
  NSLog(@"%lf", d);
}

void ABI50_0_0REAIOSLogger::log(int i)
{
  NSLog(@"%i", i);
}

void ABI50_0_0REAIOSLogger::log(bool b)
{
  log(b ? "true" : "false");
}

} // namespace reanimated
