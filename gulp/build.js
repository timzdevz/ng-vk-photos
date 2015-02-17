'use strict';

var gulp = require('gulp');

var paths = gulp.paths;

var $ = require('gulp-load-plugins')({
  pattern: ['gulp-*', 'main-bower-files', 'del']
});

var webpackConfig = require('../webpack.config')

gulp.task('images', function () {
  return gulp.src(paths.src + '/assets/images/**/*')
    .pipe(gulp.dest(paths.dist + '/assets/images/'));
});

gulp.task("vendor", function() {
  return gulp.src($.mainBowerFiles())
    .pipe($.filter('**/*.js'))
    .pipe($.debug())
    .pipe($.concat('vendor.js'))
    .pipe($.ngAnnotate())
    //.pipe($.uglify())
    .pipe($.size())
    .pipe(gulp.dest(paths.dist + '/'));
});

gulp.task('webpack', function() {
  return gulp.src(paths.src + '/app/index.js')
    .pipe($.webpack(webpackConfig) )
    .pipe(gulp.dest(paths.dist + '/'))
});

gulp.task('copyIndex', function() {
  return gulp.src(paths.src +  '/index.html')
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
