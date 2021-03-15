const puppeteer = require('puppeteer');
    (async () => {
      const browser = await puppeteer.launch({headless: true});
      const page = await browser.newPage();
      await page.goto('https://nscstrdevusw2tuecommon.z5.web.core.windows.net/users/46');
      let date = new Date();
      let stringDate = date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate() + '-' + date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds();
      await page.screenshot({path: '../results/ad440-users-46-screenshot' + stringDate + '.png'});
      await browser.close();
    })();
