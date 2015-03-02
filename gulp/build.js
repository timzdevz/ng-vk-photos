'use strict';

var gulp = require('gulp');

var paths = gulp.paths;

var webpack = require('webpack');

var ngAnnotatePlugin = require('ng-annotate-webpack-plugin');

var $ = require('gulp-load-plugins')({
  pattern: ['gulp-*', 'main-bower-files', 'del']
});

var webpackConfig = require('../webpack.config');

gulp.task('images', function () {
  return gulp.src(paths.src + '/assets/images/**/*')
    .pipe(gulp.dest(paths.dist + '/assets/images/'));
});

gulp.task("vendor", function() {
  return gulp.src($.mainBowerFiles())
    .pipe($.filter('**/*.js'))
    .pipe($.concat('vendor.js'))
    .pipe($.ngAnnotate())
    .pipe($.uglify())
    .pipe($.size())
    .pipe(gulp.dest(paths.dist + '/'));
});

gulp.task('webpack', function() {
  return gulp.src(paths.src + '/app/index.js')
    .pipe($.webpack(webpackConfig) )
    .pipe(gulp.dest(paths.dist + '/'))
});

gulp.task('webpack:dist', function() {
  var distConfig = Object.create(webpackConfig);
  distConfig.debug = false;
  distConfig.plugins = distConfig.plugins.concat(
    new ngAnnotatePlugin(),
    new webpack.optimize.UglifyJsPlugin());

  return gulp.src(paths.src + '/app/index.js')
    .pipe($.webpack(distConfig))
    .pipe(gulp.dest(paths.dist + '/'))
});

gulp.task('copyIndex', function() {
  return gulp.src(paths.src +  '/index.html')
    .pipe($.minifyHtml())
    .pipe(gulp.dest(paths.dist + '/'));
});

gulp.task('watch', function () {
  gulp.watch(paths.src + '/{app,components}/**/*', ['webpack']);
  gulp.watch(paths.src + '/app/index.html', ['copyIndex']);
});

gulp.task('clean', function (done) {
  $.del([paths.dist + '/'], done);
});

gulp.task('build', ['webpack', 'vendor', 'copyIndex', 'images']);
gulp.task('build:dist', ['webpack:dist', 'vendor', 'copyIndex', 'images']);
