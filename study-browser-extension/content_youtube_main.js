// StudyBrowser: YouTube Main-World Interceptor
// Runs directly in YouTube's page context (MAIN world)

(function() {
  'use strict';

  function blockIfShorts() {
    if (window.location.pathname.startsWith('/shorts/')) {
      // Immediately silence and stop all video players
      const videos = document.querySelectorAll('video');
      videos.forEach(v => {
        try {
          v.pause();
          v.muted = true;
          v.src = '';
          v.load();
        } catch(e) {}
      });

      try {
        window.stop();
      } catch(e) {}

      window.location.replace('https://www.youtube.com/');
    }
  }

  // 1. Initial check
  blockIfShorts();

  // 2. Hook YouTube Single Page App (Polymer) Navigation
  window.addEventListener('yt-navigate-start', function(e) {
    const url = (e && e.detail && e.detail.url) || window.location.pathname;
    if (url.includes('/shorts/')) {
      if (e.preventDefault) e.preventDefault();
      if (e.stopImmediatePropagation) e.stopImmediatePropagation();
      blockIfShorts();
    }
  }, true);

  window.addEventListener('yt-page-data-updated', blockIfShorts, true);
  window.addEventListener('yt-navigate-finish', blockIfShorts, true);
  window.addEventListener('popstate', blockIfShorts, true);

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

  // 4. Capture-phase click listener
  document.addEventListener('click', function(e) {
    const a = e.target.closest('a');
    if (a && a.href && a.href.includes('/shorts/')) {
      e.preventDefault();
      e.stopPropagation();
      e.stopImmediatePropagation();
      return false;
    }
  }, true);

  // 5. Fast watchdog interval (runs every 50ms to catch any bypass immediately)
  setInterval(blockIfShorts, 50);
})();
