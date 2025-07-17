export default {
  defaultBrowser: "Safari",
  options: {
    checkForUpdates: true,
    logRequests: false,
  },
  handlers: [
    {
      match: [
        ( {_opener} ) => _opener?.bundleId === "com.microsoft.teams2",
        (url) => url.pathname.toLowerCase().includes("evio"),
      ],
      browser: "Google Chrome",
    },
  ],
};
