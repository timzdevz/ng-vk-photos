'use strict';

var gulp = require('gulp');

var paths = gulp.paths;

var util = require('util');

var browserSync = require('browser-sync');

var modRewrite  = require('connect-modrewrite');

function browserSyncInit(baseDir, files, browser) {
  browser = browser === undefined ? 'default' : browser;

  var routes = null;
  if(baseDir === paths.src || (util.isArray(baseDir) && baseDir.indexOf(paths.src) !== -1)) {
    routes = {
      '/bower_components': 'bower_components'
    };
  }

  browserSync.instance = browserSync.init(files, {
    startPath: '/',
    server: {
      baseDir: baseDir,
      routes: routes,
      middleware: [
          modRewrite([
              '!\\.\\w+$ /index.html [L]'
          ])
      ]
    },
    browser: browser
  });
}

gulp.task('serve', ['build', 'watch'], function () {
  browserSyncInit([
    paths.dist
  ], [
    paths.dist + '/**/*'
  ]);
});

gulp.task('serve:dist', ['build:dist'], function () {
  browserSyncInit(paths.dist);
});
