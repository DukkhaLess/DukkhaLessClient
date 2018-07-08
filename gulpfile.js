const gulp = require("gulp");
const purescript = require("gulp-purescript");
const run = require("gulp-run");
const rev = require("gulp-rev");
const filter = require('gulp-filter');
const revRewrite = require('gulp-rev-rewrite');
const del = require("del");
const minify = require('gulp-minify');
var browserSync = require('browser-sync').create();
var reload      = browserSync.reload;

const sources = [
  "src/**/*.purs",
  "bower_components/purescript-*/src/**/*.purs",
];

gulp.task("make", function () {
  return purescript.compile({ src: sources });
});

gulp.task("bundle", ["make"], function () {
  return purescript
    .bundle({ src: "output/**/*.js", output: "intermediate/app.js", module: "Main", main: "Main" });
});

gulp.task("minify", ["bundle"], function() {
  return gulp.src('intermediate/app.js')
    .pipe(minify())
    .pipe(gulp.dest('intermediate'));
});

gulp.task("cleanAndMinify", ["minify"], function() {
  return del([
    "dist/**/*"
  ]);
});

gulp.task("revision", ["cleanAndMinify"], function() {
  const assetFilter = filter(['**/*', '!**/index.html'], { restore: true });
  return gulp.src('intermediate/app-min.js')
    .pipe(assetFilter)
    .pipe(rev())
    .pipe(gulp.dest('dist'))
    .pipe(rev.manifest())
    .pipe(gulp.dest('intermediate'));
});

gulp.task("revisionRewrite", ['revision'], function() {
  const manifest = gulp.src('intermediate/rev-manifest.json');

  return gulp.src('index.html')
    .pipe(revRewrite({manifest}))
    .pipe(gulp.dest('dist'));
});

gulp.task('devServer', function() {
  // Serve files from the root of this project
  browserSync.init({
    server: {
      baseDir: "./dist"
    }
  });
  gulp.watch("dist/**/*").on("change", reload);
});

gulp.task("docs", function () {
  return purescript.docs({
    src: sources,
    docgen: {
    }
  });
});

gulp.task("dotpsci", function () {
  return purescript.psci({ src: sources })
    .pipe(gulp.dest("."));
});

gulp.task("test", ["make"], function() {
  return purescript.bundle({ src: "output/**/*.js", main: "Test.Main" })
    .pipe(run("node"));
});

const DEV_TASK = ["revisionRewrite"];
gulp.task("dev", ['devServer'], function() {
  gulp.watch('./src/**/*.purs', DEV_TASK);
  gulp.watch('./src/**/*.js', DEV_TASK);
  gulp.watch('./index.html', DEV_TASK);
  gulp.watch('dist/**/*').on("change", reload);
});

gulp.task("default", ["bundle", "docs", "test"]);
