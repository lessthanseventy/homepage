/*
 |--------------------------------------------------------------------------
 | Browser-sync config file
 |--------------------------------------------------------------------------
 |
 | For up-to-date information about the options:
 |   http://www.browsersync.io/docs/options/
 |
 | There are more options than you see here, these are just the ones that are
 | set internally. See the website for more info.
 |
 |
 */
module.exports = {
  ui: {
    port: 3001,
  },
  files: ["./priv/static/**/*.*", "./lib/**/*"],
  server: false,
  proxy: "localhost:4000",
  port: 4001,
  open: false,
  reloadOnRestart: true,
  notify: false,
  ghostMode: false,
  logFileChanges: true,
  logLevel: "info",
  logPrefix: "browser-sync",
  watchEvents: ["change"],
  tunnel: true,
};
