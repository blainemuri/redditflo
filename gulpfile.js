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
  return gulp.src('./project/static/scripts/coffeescript/*.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('./project/static/scripts/js'))
});

gulp.task('styl', function () {
  gulp.src('./project/static/css/*.styl')
    .pipe(stylus({compress: true}))
    .pipe(gulp.dest('./project/static/css/build'));
});

gulp.task('default', ['coffee', 'styl'], function () {
  gulp.watch('./project/static/scripts/coffeescript/*.coffee', ['coffee']);
  gulp.watch('./project/static/css/*.styl', ['styl']);
});

var onError = function (err) {
  console.log(err);
};
