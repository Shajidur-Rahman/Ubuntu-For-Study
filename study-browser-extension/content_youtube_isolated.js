// StudyBrowser: YouTube Isolated World Purifier & DOM Guard

(function() {
  'use strict';

  // Inject main-world script as fallback if browser didn't support world: MAIN directly
  try {
    const s = document.createElement('script');
    s.src = chrome.runtime.getURL('content_youtube_main.js');
    (document.head || document.documentElement).appendChild(s);
    s.onload = () => s.remove();
  } catch (e) {}

  // Function to purge Shorts and Feed elements from the DOM
  const purgeSelectors = [
    'ytd-reel-shelf-renderer',
    'ytd-rich-shelf-renderer[is-shorts]',
    'ytd-reel-item-renderer',
    'ytd-rich-item-renderer:has(a[href*="/shorts/"])',
    'ytd-video-renderer:has(a[href*="/shorts/"])',
    'a[title="Shorts"]',
    'a[href*="/shorts/"]',
    'ytd-mini-guide-entry-renderer[aria-label="Shorts"]',
    'ytd-guide-entry-renderer:has(a[title="Shorts"])',
    'yt-chip-cloud-chip-renderer:has(yt-formatted-string[title="Shorts"])',
    'ytd-engagement-panel-section-list-renderer[target-id="engagement-panel-shorts-comments"]'
  ];

  function purgeShortsDOM() {
    for (const selector of purgeSelectors) {
      const elements = document.querySelectorAll(selector);
      for (const el of elements) {
        el.remove();
      }
    }
  }

  // Double check URL in isolated world too
  function checkUrl() {
    if (window.location.pathname.startsWith('/shorts/')) {
      window.location.replace('https://www.youtube.com/');
    }
  }

  checkUrl();
  setInterval(checkUrl, 100);

  const observer = new MutationObserver(() => {
    purgeShortsDOM();
    checkUrl();
  });

  if (document.body) {
    observer.observe(document.body, { childList: true, subtree: true });
  } else {
    document.addEventListener('DOMContentLoaded', () => {
      observer.observe(document.body, { childList: true, subtree: true });
    });
  }
})();
