const puppeteer = require('puppeteer');

    (async () => {
      const browser = await puppeteer.launch({headless: true});
      const page = await browser.newPage();
    
      await page.goto('https://nscstrdevusw2tuecommon.z5.web.core.windows.net/user/5/tasks/6');
      
      let date = new Date();
      let stringDate = date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate() + '-' + date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds();
       
      /*Temporarily saved to uitestfolder until it is connected to a Github Action*/
      await page.screenshot({ path: '../results/capture-users-id-tasks-id-'+ stringDate +'.png' });
        
      console.log('Screenshot was just taken...');
      await browser.close();
    })();
