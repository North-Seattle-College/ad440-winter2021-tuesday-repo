const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://nscstrdevusw2tuecommon.z5.web.core.windows.net/users');
    
  let date = new Date();
  let theDate = date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate() + '-' + date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds();

  await page.screenshot({ path: './results/capture-users'+ theDate +'.png' });

  await browser.close();

})();