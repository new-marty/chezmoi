// A floating window that shows one cheat sheet and stays above other apps.
// Run by scripts/cheatsheet.sh:  osascript -l JavaScript cheatsheet-window.js FILE
// JavaScript for Automation ships with macOS, so no extra app is needed.
// The window's level is "floating": it stays in front of every normal window,
// even while another app is in use. Closing it (or the toggle key) ends it.
ObjC.import("Cocoa");
ObjC.import("WebKit");

function run(argv) {
  const file = argv[0];
  const app = $.NSApplication.sharedApplication;
  app.setActivationPolicy($.NSApplicationActivationPolicyAccessory);

  const screen = $.NSScreen.mainScreen.visibleFrame;
  const w = Math.min(1100, screen.size.width * 0.6);
  const h = screen.size.height * 0.85;
  const rect = $.NSMakeRect(
    screen.origin.x + screen.size.width - w - 24,
    screen.origin.y + (screen.size.height - h) / 2,
    w, h);

  // titled | closable | miniaturizable | resizable
  const win = $.NSWindow.alloc.initWithContentRectStyleMaskBackingDefer(
    rect, 1 | 2 | 4 | 8, $.NSBackingStoreBuffered, false);
  win.title = file.split("/").pop().replace(".html", "") + " cheat sheet";
  win.level = $.NSFloatingWindowLevel;
  win.releasedWhenClosed = false;
  // Keep the size and place the window was left at.
  win.setFrameAutosaveName("dotfiles-cheatsheet");

  const web = $.WKWebView.alloc.initWithFrameConfiguration(rect, $.WKWebViewConfiguration.alloc.init);
  const url = $.NSURL.fileURLWithPath(file);
  web.loadFileURLAllowingReadAccessToURL(url, url.URLByDeletingLastPathComponent);
  win.contentView = web;

  win.makeKeyAndOrderFront(null);
  app.activateIgnoringOtherApps(true);

  // Run until the window is closed.
  app.finishLaunching;
  while (win.isVisible) {
    const ev = app.nextEventMatchingMaskUntilDateInModeDequeue(
      $.NSEventMaskAny, $.NSDate.dateWithTimeIntervalSinceNow(0.2), $.NSDefaultRunLoopMode, true);
    if (!ev.isNil()) app.sendEvent(ev);
  }
}
