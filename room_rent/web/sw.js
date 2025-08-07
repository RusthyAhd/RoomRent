// Service Worker for Village Guest House PWA - Optimized Version
const CACHE_NAME = 'village-guest-house-v2';
const CRITICAL_CACHE = 'critical-resources-v1';
const IMAGE_CACHE = 'image-cache-v1';

// Critical resources to cache immediately
const criticalResources = [
  '/',
  '/main.dart.js',
  '/favicon.png',
  '/icons/Icon-192.png',
  '/icons/Icon-512.png',
  '/manifest.json'
];

// Resources to cache on demand
const urlsToCache = [
  'https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap',
  'https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu4mxKKTU1Kg.woff2'
];

// Install event - cache critical resources first
self.addEventListener('install', function(event) {
  event.waitUntil(
    Promise.all([
      // Cache critical resources
      caches.open(CRITICAL_CACHE).then(function(cache) {
        console.log('Caching critical resources');
        return cache.addAll(criticalResources);
      }),
      // Cache other resources
      caches.open(CACHE_NAME).then(function(cache) {
        console.log('Caching additional resources');
        return cache.addAll(urlsToCache);
      })
    ])
  );
  // Force activate immediately
  self.skipWaiting();
});

// Fetch event - optimized caching strategy
self.addEventListener('fetch', function(event) {
  const request = event.request;
  const url = new URL(request.url);
  
  // Handle different types of requests
  if (request.destination === 'image') {
    event.respondWith(handleImageRequest(request));
  } else if (criticalResources.some(resource => request.url.includes(resource))) {
    event.respondWith(handleCriticalRequest(request));
  } else {
    event.respondWith(handleGeneralRequest(request));
  }
});

// Optimized image caching strategy
async function handleImageRequest(request) {
  try {
    const cache = await caches.open(IMAGE_CACHE);
    const cachedResponse = await cache.match(request);
    
    if (cachedResponse) {
      return cachedResponse;
    }
    
    const networkResponse = await fetch(request);
    if (networkResponse.ok) {
      // Only cache successful responses
      cache.put(request, networkResponse.clone());
    }
    return networkResponse;
  } catch (error) {
    console.log('Image fetch failed:', error);
    // Return a placeholder or cached version if available
    return caches.match('/icons/Icon-192.png');
  }
}

// Critical resources - cache first, then network
async function handleCriticalRequest(request) {
  try {
    const cache = await caches.open(CRITICAL_CACHE);
    const cachedResponse = await cache.match(request);
    
    if (cachedResponse) {
      return cachedResponse;
    }
    
    const networkResponse = await fetch(request);
    if (networkResponse.ok) {
      cache.put(request, networkResponse.clone());
    }
    return networkResponse;
  } catch (error) {
    console.log('Critical resource fetch failed:', error);
    return caches.match(request);
  }
}

// General requests - network first, fallback to cache
async function handleGeneralRequest(request) {
  try {
    const networkResponse = await fetch(request);
    
    if (networkResponse.ok) {
      const cache = await caches.open(CACHE_NAME);
      cache.put(request, networkResponse.clone());
    }
    
    return networkResponse;
  } catch (error) {
    console.log('Network fetch failed, trying cache:', error);
    return caches.match(request);
  }
}

// Activate event - cleanup old caches
self.addEventListener('activate', function(event) {
  event.waitUntil(
    caches.keys().then(function(cacheNames) {
      return Promise.all(
        cacheNames.map(function(cacheName) {
          if (cacheName !== CACHE_NAME && 
              cacheName !== CRITICAL_CACHE && 
              cacheName !== IMAGE_CACHE) {
            console.log('Deleting old cache:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
  // Claim all clients immediately
  return self.clients.claim();
});

// Background sync for offline functionality
self.addEventListener('sync', function(event) {
  if (event.tag === 'background-sync') {
    event.waitUntil(doBackgroundSync());
  }
});

async function doBackgroundSync() {
  console.log('Performing background sync');
  // Implement background sync logic here
}
