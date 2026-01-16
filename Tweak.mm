#import <UIKit/UIKit.h>
#include <fstream>
#include <string>

// --- C++ LOGIC FOR OPTIMIZATION ---
void applyRobloxTweaks() {
    // 1. Locate the Sandbox Path
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *settingsPath = [libraryPath stringByAppendingPathComponent:@"Application Support/ClientSettings"];
    NSString *fileLocation = [settingsPath stringByAppendingPathComponent:@"ClientAppSettings.json"];

    // 2. Create the Directory if it's missing
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:settingsPath withIntermediateDirectories:YES attributes:nil error:&error];

    // 3. Define Optimization Settings
    // DFIntTaskSchedulerTargetFps: Unlocks FPS (set to 120 or 999)
    // FIntRenderShadowIntensity: Set to 0 to remove shadows (huge lag fix)
    // FIntDebugTextureManagerSkipPBR: Disables heavy textures
    std::string configJson = "{"
        "\"DFIntTaskSchedulerTargetFps\": 120,"
        "\"FIntRenderShadowIntensity\": 0,"
        "\"FIntDebugTextureManagerSkipPBR\": 1"
    "}";

    // 4. Write to the file
    std::ofstream settingsFile([fileLocation UTF8String]);
    settingsFile << configJson;
    settingsFile.close();
}

// --- INITIALIZATION ---
__attribute__((constructor))
static void initialize() {
    // We wait 2 seconds after the app opens to ensure the file system is ready
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        applyRobloxTweaks();
        
        // Visual confirmation (Optional)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Optimizer" 
                                    message:@"FPS Unlocked & Lag Reduced!" 
                                    preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
