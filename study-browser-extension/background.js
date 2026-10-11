// StudyBrowser Guardian Service Worker
// Enforces strict YouTube No-Shorts, Facebook 4-Group Policy, and Total Adult Eradication

const ALLOWED_GROUPS = [
  'fabzoology27',
  'fabbotany27',
  '1612120089807832',
  'saikatvaisengineeringchemistryhsc26'
];

// Whitelist of educational and essential study domains to prevent false positives
const SAFE_DOMAINS = [
  'google.com',
  'youtube.com',
  'youtu.be',
  'wikipedia.org',
  'wikimedia.org',
  'facebook.com',
  'fbcdn.net',
  'fbsbx.com',
  'whatsapp.com',
  'github.com',
  'githubusercontent.com',
  'stackoverflow.com',
  'khanacademy.org',
  '10minuteschool.com',
  'coursera.org',
  'edx.org',
  'mit.edu',
  'harvard.edu',
  'zoom.us',
  'microsoft.com',
  'apple.com',
  'cloudflare.com',
  'mozilla.org',
  'w3schools.com',
  'geeksforgeeks.org',
  'arxiv.org',
  'udemy.com',
  'quora.com',
  'physicswallah.live',
  'buet.ac.bd',
  'du.ac.bd'
];

const ADULT_PATTERNS = [
  /mmsgram/i,
  /choti/i,
  /desimms/i,
  /banglasex/i,
  /desisex/i,
  /bhabhi/i,
  /mmsleak/i,
  /mmsbee/i,
  /antarchoti/i,
  /porn/i,
  /xxx/i,
  /xnxx/i,
  /xvideos/i,
  /xhamster/i,
  /redtube/i,
  /youporn/i,
  /pornhub/i,
  /spankbang/i,
  /beeg/i,
  /tnaflix/i,
  /eporner/i,
  /tube8/i,
  /stripchat/i,
  /chaturbate/i,
  /bongacams/i,
  /cam4/i,
  /camsoda/i,
  /livejasmin/i,
  /myfreecams/i,
  /streamate/i,
  /onlyfans/i,
  /fansly/i,
  /manyvids/i,
  /fapello/i,
  /erome/i,
  /coomer/i,
  /kemono/i,
  /thothub/i,
  /motherless/i,
  /rule34/i,
  /hentai/i,
  /brazzers/i,
  /bangbros/i,
  /naughtyamerica/i,
  /realitykings/i,
  /vixen/i,
  /blacked/i,
  /tushy/i
];

function isAdultSite(urlStr) {
  try {
    const url = new URL(urlStr);
    const host = url.hostname.toLowerCase();

    // Check safe whitelist first
    for (const s of SAFE_DOMAINS) {
      if (host === s || host.endsWith('.' + s)) {
        return false;
      }
    }

    // Match against adult heuristics
    for (const pattern of ADULT_PATTERNS) {
      if (pattern.test(host)) {
        return true;
      }
    }

    return false;
  } catch (e) {
    return false;
  }
}

function isFacebookAllowed(urlStr) {
  try {
    const url = new URL(urlStr);
    if (!url.hostname.includes('facebook.com')) {
      return true; // Non-facebook URL
    }

    const path = url.pathname.toLowerCase();

    // 1. Allow Login, Authentication, Account Recovery & Checkpoints
    const authEndpoints = [
      '/login',
      '/checkpoint',
      '/two_factor',
      '/recover',
      '/security',
      '/auth',
      '/logout',
      '/cookie'
    ];
    for (const ep of authEndpoints) {
      if (path.startsWith(ep)) {
        return true;
      }
    }

    // 2. Allow essential internal API calls required for loading group posts & videos
    const apiEndpoints = [
      '/api/',
      '/ajax/',
      '/graphql',
      '/async/',
      '/privacy/'
    ];
    for (const ep of apiEndpoints) {
      if (path.startsWith(ep)) {
        return true;
      }
    }

    // 3. Strictly allow ONLY the 4 authorized groups
    for (const g of ALLOWED_GROUPS) {
      if (path.startsWith('/groups/' + g.toLowerCase())) {
        return true;
      }
    }

    // Everything else on Facebook (Home feed, Reels, Watch, other groups, profiles) is FORBIDDEN
    return false;
  } catch (e) {
    return false;
  }
}

// 1. Intercept navigations before network requests leave
chrome.webNavigation.onBeforeNavigate.addListener((details) => {
  if (details.frameId !== 0) return; // Only process main window navigation

  const url = details.url;
  if (!url || url.startsWith('chrome://') || url.startsWith('chrome-extension://')) {
    return;
  }

  // Intercept Adult & Explicit Sites
  if (isAdultSite(url)) {
    chrome.tabs.update(details.tabId, {
      url: chrome.runtime.getURL('blocked_adult.html?site=' + encodeURIComponent(url))
    });
    return;
  }

  // Intercept YouTube Shorts
  if (url.includes('youtube.com/shorts/') || url.includes('youtu.be/shorts/')) {
    chrome.tabs.update(details.tabId, {
      url: chrome.runtime.getURL('blocked_shorts.html')
    });
    return;
  }

  // Intercept Facebook Navigations
  if (url.includes('facebook.com')) {
    if (!isFacebookAllowed(url)) {
      chrome.tabs.update(details.tabId, {
        url: chrome.runtime.getURL('blocked_fb.html?attempt=' + encodeURIComponent(url))
      });
      return;
    }
  }
});

// 2. Listen for messages from content scripts
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === 'redirect_blocked_fb') {
    if (sender.tab && sender.tab.id) {
      chrome.tabs.update(sender.tab.id, {
        url: chrome.runtime.getURL('blocked_fb.html?attempt=' + encodeURIComponent(message.url || ''))
      });
    }
  } else if (message.action === 'redirect_blocked_shorts') {
    if (sender.tab && sender.tab.id) {
      chrome.tabs.update(sender.tab.id, {
        url: chrome.runtime.getURL('blocked_shorts.html')
      });
    }
  } else if (message.action === 'redirect_blocked_adult') {
    if (sender.tab && sender.tab.id) {
      chrome.tabs.update(sender.tab.id, {
        url: chrome.runtime.getURL('blocked_adult.html?site=' + encodeURIComponent(message.url || ''))
      });
    }
  }
  return true;
});

// 3. On install or startup, make sure the dashboard is accessible
chrome.runtime.onInstalled.addListener(() => {
  console.log('StudyBrowser Guardian Engine 1.2.0 loaded successfully.');
});
