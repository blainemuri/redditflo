'use strict';

// requirements

var gulp = require('gulp'),
    browserify = require('gulp-browserify'),
    size = require('gulp-size'),
    clean = require('gulp-clean');
    stylus = require('gulp-stylus');

// include, if you want to work with sourcemaps
var sourcemaps = require('gulp-sourcemaps');

// tasks

// Get one .styl file and render
gulp.task('one', function () {
  gulp.src('./css/one.styl')
    .pipe(stylus())
    .pipe(gulp.dest('./css/build'));
});

// Options
// Options compress
gulp.task('compress', function () {
  gulp.src('./css/compressed.styl')
    .pipe(stylus({
      compress: true
    }))
    .pipe(gulp.dest('./css/build'));
});


// Set linenos
gulp.task('linenos', function () {
  gulp.src('./css/linenos.styl')
    .pipe(stylus({linenos: true}))
    .pipe(gulp.dest('./css/build'));
});

// Include css
// Stylus has an awkward and perplexing 'include css' option
gulp.task('include-css', function() {
  gulp.src('./css/*.styl')
    .pipe(stylus({
      'include css': true
    }))
    .pipe(gulp.dest('./'));

});

// Inline sourcemaps
gulp.task('sourcemaps-inline', function () {
  gulp.src('./css/sourcemaps-inline.styl')
    .pipe(sourcemaps.init())
    .pipe(stylus())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('./css/build'));
});

// External sourcemaps
gulp.task('sourcemaps-external', function () {
  gulp.src('./css/sourcemaps-external.styl')
    .pipe(sourcemaps.init())
    .pipe(stylus())
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('./css/build'));
});

gulp.task('transform', function () {
  return gulp.src('./project/static/scripts/jsx/main.js')
    .pipe(browserify({transform: ['reactify']}))
    .pipe(gulp.dest('./project/static/scripts/js'))
    .pipe(size());
});

gulp.task('clean', function () {
  return gulp.src(['./project/static/scripts/js'], {read: false})
    .pipe(clean());
});

gulp.task('default', ['clean', ], function () {
  gulp.start('transform');
  gulp.watch('./project/static/scripts/jsx/main.js', ['transform']);
});