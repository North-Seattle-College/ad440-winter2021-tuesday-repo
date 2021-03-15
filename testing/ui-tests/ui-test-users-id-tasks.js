const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://nscstrdevusw2tuecommon.z5.web.core.windows.net/users/1/tasks');
    
  let date = new Date();
  let stringDate = date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate() + '-' + date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds();

  /*Temporarily saved to uitestfolder until it is connected to a Github Action*/
  await page.screenshot({ path: 'capture-users-id-tasks-'+ stringDate +'.png' });

  await browser.close();

})();