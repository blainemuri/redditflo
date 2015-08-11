'use strict';

// requirements

var gulp = require('gulp'),
    size = require('gulp-size'),
    clean = require('gulp-clean'),
    stylus = require('gulp-stylus'),
    coffee  = require('gulp-coffee'),
    concat  = require('gulp-concat'),
    gutil   = require('gulp-util');

gulp.task('coffee', function () {
  return gulp.src('./static/scripts/coffeescript/*.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('./node_modules/redditflo'))
});

gulp.task('styl', function () {
  gulp.src('./static/css/*.styl')
    .pipe(stylus({compress: true}))
    .pipe(gulp.dest('./static/css/build'));
});

gulp.task('default', ['coffee', 'styl'], function () {
  gulp.watch('./static/scripts/coffeescript/*.coffee', ['coffee']);
  gulp.watch('./static/css/*.styl', ['styl']);
});

var onError = function (err) {
  console.log(err);
};
