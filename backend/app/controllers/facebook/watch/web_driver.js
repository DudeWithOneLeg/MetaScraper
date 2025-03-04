const { Builder } = require("selenium-webdriver");
const chrome = require("selenium-webdriver/chrome");

async function interceptRequests(url) {
  let driver = await new Builder()
    .forBrowser("chrome")
    .setChromeOptions(new chrome.Options().headless()) // Run in headless mode
    .build();

  try {
    const devTools = await driver.getDevToolsSession();
    await devTools.send("Network.enable");

    // Listen for request interception
    await devTools.send("Network.setRequestInterception", {
      patterns: [{ urlPattern: "*" }], // Intercept all requests
    });

    devTools.on("Network.requestIntercepted", async (event) => {
      console.log("Intercepted request:", event.request.url);

      // Continue request without modification
      await devTools.send("Network.continueInterceptedRequest", {
        interceptionId: event.interceptionId,
      });
    });

    // Navigate to a website
    await driver.get(url);

  } catch (err) {
    console.error(err);
  } finally {
    await driver.quit();
  }
}

module.exports = interceptRequests