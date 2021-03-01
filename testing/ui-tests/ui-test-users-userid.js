const puppeteer = require('puppeteer');
    (async () => {
      const browser = await puppeteer.launch({headless: true});
      const page = await browser.newPage();
      await page.goto('https://nscstrdevusw2tuecommon.z5.web.core.windows.net/users/46');
      await page.screenshot({path: 'ad440-users-46-screenshot.png'});
      await browser.close();
    })();
