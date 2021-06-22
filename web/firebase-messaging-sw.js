// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here. Other Firebase libraries
// are not available in the service worker.
importScripts('https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js');

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
firebase.initializeApp({
    apiKey: "AIzaSyC7ZsC6QyqRoxOzBqFIGRDA-7UYNZoDCVE",
    authDomain: "beautyspin-1a8a7.firebaseapp.com",
    projectId: "beautyspin-1a8a7",
    storageBucket: "beautyspin-1a8a7.appspot.com",
    messagingSenderId: "806775917217",
    // prod
    appId: "1:806775917217:web:d7b635fc21679e4469fee0",
    measurementId: "G-314FN44YJ7"
    // // dev
    // appId: "1:806775917217:web:1f2f42b8ddc9de7f69fee0",
    // measurementId: "G-ECZEJWMNW5"
});

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();