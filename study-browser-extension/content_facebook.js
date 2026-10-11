// StudyBrowser: Super Strict Facebook 4-Group Enforcer
(function() {
  'use strict';

  const ALLOWED_GROUPS = [
    'fabzoology27',
    'fabbotany27',
    '1612120089807832',
    'saikatvaisengineeringchemistryhsc26'
  ];

  function isUrlPermitted(testUrl) {
    try {
      const u = new URL(testUrl, window.location.origin);
      if (!u.hostname.includes('facebook.com')) {
        return true; // Non-Facebook asset
      }

      const path = u.pathname.toLowerCase();

      // 1. Allow Login, Checkpoint, and Two-Factor
      if (
        path.startsWith('/login') ||
        path.startsWith('/checkpoint') ||
        path.startsWith('/two_factor') ||
        path.startsWith('/recover') ||
        path.startsWith('/security') ||
        path.startsWith('/auth') ||
        path.startsWith('/logout') ||
        path.startsWith('/cookie')
      ) {
        return true;
      }

      // 2. Allow internal API endpoints required for fetching group posts & streaming videos
      if (
        path.startsWith('/api/') ||
        path.startsWith('/ajax/') ||
        path.startsWith('/graphql') ||
        path.startsWith('/async/')
      ) {
        return true;
      }

      // 3. Allow ONLY the 4 authorized HSC study groups (including posts, permalinks, videos inside them)
      for (const grp of ALLOWED_GROUPS) {
        if (path.startsWith('/groups/' + grp.toLowerCase())) {
          return true;
        }
      }

      // Any other path (Home feed, Watch, Reels, other groups, profiles) is forbidden
      return false;
    } catch (e) {
      return false;
    }
  }

  // 1. Immediate Page Verification
  function enforceCurrentUrl() {
    if (!isUrlPermitted(window.location.href)) {
      window.stop();
      // Inform service worker or redirect directly
      try {
        chrome.runtime.sendMessage({
          action: 'redirect_blocked_fb',
          url: window.location.href
        });
      } catch (e) {
        window.location.replace(chrome.runtime.getURL('blocked_fb.html?attempt=' + encodeURIComponent(window.location.href)));
      }
    }
  }

  enforceCurrentUrl();

  // 2. Hook Single Page App (React/Relay) History Transitions
  const origPushState = history.pushState;
  history.pushState = function(state, title, url) {
    if (url && typeof url === 'string') {
      const fullUrl = new URL(url, window.location.origin).href;
      if (!isUrlPermitted(fullUrl)) {
        console.warn('StudyBrowser: Blocked React pushState navigation to:', fullUrl);
        window.location.replace(chrome.runtime.getURL('blocked_fb.html?attempt=' + encodeURIComponent(fullUrl)));
        return;
      }
    }
    return origPushState.apply(this, arguments);
  };

  const origReplaceState = history.replaceState;
  history.replaceState = function(state, title, url) {
    if (url && typeof url === 'string') {
      const fullUrl = new URL(url, window.location.origin).href;
      if (!isUrlPermitted(fullUrl)) {
        console.warn('StudyBrowser: Blocked React replaceState navigation to:', fullUrl);
        window.location.replace(chrome.runtime.getURL('blocked_fb.html?attempt=' + encodeURIComponent(fullUrl)));
        return;
      }
    }
    return origReplaceState.apply(this, arguments);
  };

  window.addEventListener('popstate', enforceCurrentUrl, true);

  // 3. Capture-Phase Link Click Interceptor
  document.addEventListener('click', (e) => {
    const link = e.target.closest('a');
    if (link && link.href) {
      // Check if clicked link leads outside the allowed 4 groups
      if (!isUrlPermitted(link.href)) {
        e.preventDefault();
        e.stopPropagation();
        e.stopImmediatePropagation();
        alert('⛔ ACCESS FORBIDDEN:\nStudyBrowser is restricted exclusively to your 4 authorized HSC groups.\nFeeds, Reels, and external links are permanently disabled.');
        return false;
      }
    }
  }, true);

  // 4. Periodic safety verification
  setInterval(enforceCurrentUrl, 500);

  // 5. Clean up any distracting Reels or Home elements from DOM
  const removeDistractions = () => {
    // Hide left sidebar feeds
    const selectors = [
      'div[role="navigation"] a[aria-label="Home"]',
      'div[role="navigation"] a[aria-label="Video"]',
      'div[role="navigation"] a[aria-label="Watch"]',
      'div[role="navigation"] a[aria-label="Marketplace"]',
      'div[role="navigation"] a[aria-label="Gaming"]',
      'div[aria-label="Reels"]',
      'div[aria-label="Stories"]',
      'a[href*="/reel/"]',
      'a[href*="/watch/"]'
    ];
    for (const sel of selectors) {
      const matches = document.querySelectorAll(sel);
      for (const m of matches) {
        m.style.setProperty('display', 'none', 'important');
      }
    }
  };

  const observer = new MutationObserver(removeDistractions);
  if (document.body) {
    observer.observe(document.body, { childList: true, subtree: true });
  } else {
    document.addEventListener('DOMContentLoaded', () => {
      observer.observe(document.body, { childList: true, subtree: true });
    });
  }
})();
