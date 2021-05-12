// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here. Other Firebase libraries
// are not available in the service worker.
importScripts('https://www.gstatic.com/firebasejs/7.20.0/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/7.20.0/firebase-messaging.js');

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
firebase.initializeApp({
    apiKey: "AIzaSyDfguKpCEZhzUvJ8vnxthyXiV3gDzoDm6w",
    authDomain: "botoxdeals.firebaseapp.com",
    databaseURL: "https://botoxdeals.firebaseio.com",
    projectId: "botoxdeals",
    storageBucket: "botoxdeals.appspot.com",
    messagingSenderId: "1093899058446",
    //// prod
    // appId: "1:1093899058446:web:7125b19d685c55444c2b5f",
    // measurementId: "G-SJ1GYD0J0B"
    // dev
    appId: "1:1093899058446:web:9eb73dc90fb510824c2b5f",
    measurementId: "G-RQ8P9R2HXT"
});

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();