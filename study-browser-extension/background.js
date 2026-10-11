// StudyBrowser Guardian Service Worker
// Enforces strict YouTube No-Shorts and Facebook 4-Group Policy

const ALLOWED_GROUPS = [
  'fabzoology27',
  'fabbotany27',
  '1612120089807832',
  'saikatvaisengineeringchemistryhsc26'
];

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
  }
  return true;
});

// 3. On install or startup, make sure the dashboard is accessible
chrome.runtime.onInstalled.addListener(() => {
  console.log('StudyBrowser Guardian Engine loaded successfully.');
});
