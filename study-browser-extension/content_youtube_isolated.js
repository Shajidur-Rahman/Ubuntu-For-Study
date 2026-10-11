// StudyBrowser: YouTube Isolated World Purifier & DOM Guard

(function() {
  'use strict';

  // Fallback injection of main-world script
  try {
    const s = document.createElement('script');
    s.src = chrome.runtime.getURL('content_youtube_main.js');
    (document.head || document.documentElement).appendChild(s);
    s.onload = () => s.remove();
  } catch (e) {}

  const purgeSelectors = [
    'ytd-reel-shelf-renderer',
    'ytd-rich-shelf-renderer[is-shorts]',
    'ytd-rich-section-renderer:has(ytd-reel-shelf-renderer)',
    'ytd-rich-section-renderer:has(ytd-rich-shelf-renderer[is-shorts])',
    'ytd-reel-item-renderer',
    'ytd-rich-item-renderer:has(a[href*="/shorts/"])',
    'ytd-video-renderer:has(a[href*="/shorts/"])',
    'a[title="Shorts"]',
    'a[href*="/shorts/"]',
    'ytd-mini-guide-entry-renderer[aria-label="Shorts"]',
    'ytd-guide-entry-renderer:has(a[title="Shorts"])',
    'tp-yt-paper-item:has(a[title="Shorts"])',
    'yt-chip-cloud-chip-renderer:has(yt-formatted-string[title="Shorts"])',
    'grid-subheader-renderer:has(yt-formatted-string[title="Shorts"])',
    'ytd-engagement-panel-section-list-renderer[target-id="engagement-panel-shorts-comments"]'
  ];

  function purgeShortsDOM() {
    for (const selector of purgeSelectors) {
      try {
        const elements = document.querySelectorAll(selector);
        for (const el of elements) {
          el.remove();
        }
      } catch (e) {}
    }
  }

  function enforceLectureMode() {
    const path = window.location.pathname;

    // 1. YouTube Shorts: Zero Tolerance Redirect
    if (path.startsWith('/shorts/')) {
      const videos = document.querySelectorAll('video');
      videos.forEach(v => {
        try {
          v.pause();
          v.muted = true;
          v.src = '';
          v.load();
        } catch (e) {}
      });
      try { window.stop(); } catch(e) {}
      window.location.replace('https://www.youtube.com/');
      return;
    }

    // 2. YouTube Homepage: Remove feed recommendations
    if (path === '/' || path === '' || path === '/feed/explore' || path === '/feed/trending') {
      const grid = document.querySelector('ytd-rich-grid-renderer');
      if (grid) {
        grid.style.setProperty('display', 'none', 'important');
        grid.remove();
      }
      const chips = document.querySelector('ytd-feed-filter-chip-bar-renderer') || document.getElementById('chips');
      if (chips) {
        chips.style.setProperty('display', 'none', 'important');
        chips.remove();
      }
      document.querySelectorAll('ytd-rich-section-renderer, ytd-rich-item-renderer, ytd-rich-grid-row').forEach(el => el.remove());
    }

    // 3. YouTube Watch Page: Erase side recommendations
    if (path.startsWith('/watch')) {
      const secondary = document.getElementById('secondary');
      if (secondary) {
        secondary.style.setProperty('display', 'none', 'important');
        secondary.remove();
      }
      const related = document.getElementById('related');
      if (related) {
        related.style.setProperty('display', 'none', 'important');
        related.remove();
      }
    }
  }

  enforceLectureMode();
  purgeShortsDOM();

  setInterval(() => {
    enforceLectureMode();
    purgeShortsDOM();
  }, 40);

  const observer = new MutationObserver(() => {
    purgeShortsDOM();
    enforceLectureMode();
  });

  if (document.body) {
    observer.observe(document.body, { childList: true, subtree: true });
  } else {
    document.addEventListener('DOMContentLoaded', () => {
      if (document.body) {
        observer.observe(document.body, { childList: true, subtree: true });
      }
    });
  }
})();
