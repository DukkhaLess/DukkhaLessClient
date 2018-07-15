const gulp = require("gulp");
const purescript = require("gulp-purescript");
const run = require("gulp-run");
const rev = require("gulp-rev");
const filter = require('gulp-filter');
const revRewrite = require('gulp-rev-rewrite');
const del = require("del");
const minify = require('gulp-minify');
const gzip = require('gulp-gzip');
const replace = require('gulp-replace');
const browserSync = require('browser-sync').create();
const reload      = browserSync.reload;

const sources = [
  "src/**/*.purs",
  "bower_components/purescript-*/src/**/*.purs",];

gulp.task("cleanIntermediate", function() {
  return del([
    "intermediate/**/**",
  ]);
});

gulp.task("cleanDist", function() {
  return del([
    "dist/**/**",
  ]);
});

gulp.task("make", ["cleanIntermediate"], function () {
  return purescript.compile({ src: sources });
});

gulp.task("bundle", ["make"], function () {
  return purescript
    .bundle({ src: "output/**/*.js", output: "intermediate/app.js", module: "Main", main: "Main" });
});

gulp.task("minify", ["bundle"], function() {
  return gulp.src('intermediate/app.js')
    .pipe(minify({
      mangle: false,
    }))
    .pipe(gulp.dest('intermediate'));
});

function revisionFn(fileName) {
  return () => {
    const assetFilter = filter(['**/*', '!**/index.html'], { restore: true });
    gulp.src(`index.html`)
      .pipe(replace("static/app.js", `static/${fileName}`))
      .pipe(gulp.dest('intermediate'));
    return gulp.src(`intermediate/${fileName}`)
      .pipe(assetFilter)
      .pipe(rev())
      .pipe(gulp.dest('dist/static'))
      .pipe(rev.manifest())
      .pipe(gulp.dest('intermediate'));
  };
}

gulp.task("revisionProd", ["minify", "cleanDist"], revisionFn("app-min.js"));
gulp.task("revision", ["bundle", "cleanDist"], revisionFn("app.js"));

function revisionRewriteFn() {
  const manifest = gulp.src('intermediate/rev-manifest.json');

  return gulp.src('intermediate/index.html')
    .pipe(revRewrite({manifest}))
    .pipe(gulp.dest('dist'));
}

gulp.task("revisionRewrite", ['revision'], revisionRewriteFn);

gulp.task("revisionRewriteProd", ['revisionProd'], revisionRewriteFn);

gulp.task("buildToProd", ['revisionRewriteProd'], function() {
  return gulp.src('dist/static/*.js')
    .pipe(gzip({
      gzipOptions: {
        level: 9
      },
    }))
    .pipe(gulp.dest('dist/static'));
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
