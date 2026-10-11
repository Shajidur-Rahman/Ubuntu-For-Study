// StudyBrowser: YouTube Shorts Eradication Engine
(function() {
  'use strict';

  // 1. Immediate URL Verification
  function sanitizeCurrentUrl() {
    if (window.location.pathname.startsWith('/shorts/')) {
      const vid = document.querySelector('video');
      if (vid) {
        vid.pause();
        vid.src = '';
      }
      window.stop();
      window.location.replace('https://www.youtube.com/');
    }
  }

  sanitizeCurrentUrl();

  // 2. Hook YouTube Single Page App (Polymer) Navigation Events
  window.addEventListener('yt-navigate-start', (e) => {
    const url = (e && e.detail && e.detail.url) || window.location.pathname;
    if (url.includes('/shorts/')) {
      sanitizeCurrentUrl();
    }
  }, true);

  window.addEventListener('yt-navigate-finish', sanitizeCurrentUrl, true);
  window.addEventListener('yt-page-data-updated', sanitizeCurrentUrl, true);
  window.addEventListener('popstate', sanitizeCurrentUrl, true);

  // 3. Hook History API
  const origPushState = history.pushState;
  history.pushState = function(state, title, url) {
    if (url && typeof url === 'string' && url.includes('/shorts/')) {
      window.location.replace('https://www.youtube.com/');
      return;
    }
    return origPushState.apply(this, arguments);
  };

  const origReplaceState = history.replaceState;
  history.replaceState = function(state, title, url) {
    if (url && typeof url === 'string' && url.includes('/shorts/')) {
      window.location.replace('https://www.youtube.com/');
      return;
    }
    return origReplaceState.apply(this, arguments);
  };

  // 4. Intercept Clicks on any Shorts links
  document.addEventListener('click', (e) => {
    const link = e.target.closest('a');
    if (link && link.href && link.href.includes('/shorts/')) {
      e.preventDefault();
      e.stopPropagation();
      e.stopImmediatePropagation();
      console.warn('StudyBrowser: Blocked click on Shorts link:', link.href);
      return false;
    }
  }, true);

  // 5. DOM Mutation Observer: Purge Shorts elements as YouTube streams them
  const purgeSelectors = [
    'ytd-reel-shelf-renderer',
    'ytd-rich-shelf-renderer[is-shorts]',
    'ytd-reel-item-renderer',
    'a[title="Shorts"]',
    'a[href*="/shorts/"]',
    'ytd-mini-guide-entry-renderer[aria-label="Shorts"]',
    'ytd-guide-entry-renderer:has(a[title="Shorts"])',
    'yt-chip-cloud-chip-renderer:has(yt-formatted-string[title="Shorts"])',
    'ytd-engagement-panel-section-list-renderer[target-id="engagement-panel-shorts-comments"]'
  ];

  function purgeShortsElements() {
    sanitizeCurrentUrl();
    for (const selector of purgeSelectors) {
      const elements = document.querySelectorAll(selector);
      for (const el of elements) {
        el.remove();
      }
    }
  }

  const observer = new MutationObserver(() => {
    purgeShortsElements();
  });

  if (document.body) {
    observer.observe(document.body, { childList: true, subtree: true });
  } else {
    document.addEventListener('DOMContentLoaded', () => {
      observer.observe(document.body, { childList: true, subtree: true });
    });
  }

  setInterval(sanitizeCurrentUrl, 300);
})();
