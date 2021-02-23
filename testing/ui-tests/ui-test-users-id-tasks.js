import puppeteer from 'puppeteer';

(async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto('https://nscstrdevusw2tuecommon.z5.web.core.windows.net/index.html');
    await page.screenshot({path: '/user/1/tasks'});

    await browser.close();

})();

/* Not tested just trying out code, unsure of goto link
local host or static site? 
using https://itnext.io/getting-started-using-puppeteer-headless-chrome-for-end-to-end-testing-8487718e4d97
*/