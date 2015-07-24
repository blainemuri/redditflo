'use strict';

// requirements

var gulp = require('gulp'),
    browserify = require('gulp-browserify'),
    size = require('gulp-size'),
    clean = require('gulp-clean'),
    stylus = require('gulp-stylus'),
    coffee  = require('gulp-coffee'),
    concat  = require('gulp-concat'),
    gutil   = require('gulp-util');

// tasks

// Options
// Options compress
gulp.task('homepage', function () {
  gulp.src('./project/static/css/homepage.styl')
    .pipe(stylus({
      compress: true
    }))
    .pipe(gulp.dest('./project/static/css/build'));
});


gulp.task('transform', function () {
  return gulp.src('./project/static/scripts/jsx/main.js')
    .pipe(browserify({transform: ['reactify']}))
    .pipe(gulp.dest('./project/static/scripts/js/react'))
    .pipe(size());
});

gulp.task('coffee', function () {
  return gulp.src('./project/static/scripts/coffeescript/*.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('./project/static/scripts/js'))
});

gulp.task('clean', function () {
  return gulp.src(['./project/static/scripts/js'], {read: false})
    .pipe(clean());
});

gulp.task('default', ['clean', 'homepage', 'coffee'], function () {
  gulp.start('transform');
  gulp.watch('./project/static/scripts/jsx/main.js', ['transform']);
  gulp.watch('./project/static/css/homepage.styl', ['homepage']);
});