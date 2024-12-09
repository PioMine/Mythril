import SwiftUI
import Cocoa

@main
struct BrowserApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    // State to control the presentation of SettingsView
    @State private var showingSettings = false

    var body: some Scene {
        WindowGroup {
            Group { // Wrap conditional views in a Group
                if hasCompletedOnboarding {
                    ContentView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    OnboardingContainerView()
                }
            }
            // Attach the sheet presentation modifier to the Group
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            // Add Preferences command to the app menu
            CommandGroup(replacing: .appSettings) {
                Button("Preferences…") {
                    showingSettings = true
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            // Set the window style
            window.styleMask.insert(.fullSizeContentView)
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Perform any necessary cleanup here
    }
}
