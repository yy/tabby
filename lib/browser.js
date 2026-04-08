ObjC.import("Foundation");
ObjC.import("stdlib");

function fail(message) {
    const data = $(message + "\n").dataUsingEncoding($.NSUTF8StringEncoding);
    $.NSFileHandle.fileHandleWithStandardError.writeData(data);
    $.exit(1);
}

function getBrowser() {
    const env = $.NSProcessInfo.processInfo.environment;
    const val = env.objectForKey("TABBY_BROWSER");
    const name = val ? val.js : "chrome";

    if (name === "safari") {
        const app = Application("Safari");
        return {
            app,
            windows: () => app.windows(),
            tabs: (win) => win.tabs(),
            tabTitle: (tab) => tab.name(),
            tabUrl: (tab) => tab.url(),
            activeTab: (win) => win.currentTab(),
        };
    }

    const app = Application("Google Chrome");
    return {
        app,
        windows: () => app.windows(),
        tabs: (win) => win.tabs(),
        tabTitle: (tab) => tab.title(),
        tabUrl: (tab) => tab.url(),
        activeTab: (win) => win.activeTab(),
    };
}
