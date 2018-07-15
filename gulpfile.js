const gulp = require("gulp");
const purescript = require("gulp-purescript");
const run = require("gulp-run");
const rev = require("gulp-rev");
const filter = require('gulp-filter');
const revRewrite = require('gulp-rev-rewrite');
const del = require("del");
const gzip = require('gulp-gzip');
const replace = require('gulp-replace');
const closureCompiler = require('google-closure-compiler').gulp();
const browserSync = require('browser-sync').create();
const sass = require('gulp-sass');
const cleanCss = require('gulp-clean-css');
const rename = require('gulp-rename');
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

gulp.task("make", ["cleanIntermediate", "sass"], function () {
  return purescript.compile({ src: sources });
});

gulp.task("bundle", ["make"], function () {
  return purescript
    .bundle({ src: "output/**/*.js", output: "intermediate/app.js", module: "Main", main: "Main" });
});

gulp.task("minifyCss", function() {
  return gulp.src('intermediate/styles.css')
    .pipe(cleanCss({compatibility: 'ie10'}))
    .pipe(rename("styles-min.css"))
    .pipe(gulp.dest('intermediate'));
});

gulp.task("minify", ["bundle"], function() {
  return gulp.src('intermediate/app.js')
    .pipe(closureCompiler({
      compilation_level: 'SIMPLE',
      warning_level: 'QUIET',
      language_in: 'ECMASCRIPT6_STRICT',
      language_out: 'ECMASCRIPT5_STRICT',
      js_output_file: 'app-min.js',
    }))
    .pipe(gulp.dest('intermediate'));
});

function revisionFn(isMinified) {
  return () => {
    const assetFilter = filter(['**/*', '!**/index.html'], { restore: true });
    const appFile = isMinified ? "app-min.js" : "app.js";
    const styleFile = isMinified ? "styles-min.css" :  "styles.css";
    gulp.src(`index.html`)
      .pipe(replace("static/app.js", `static/${appFile}`))
      .pipe(replace("static/styles.css", `static/${styleFile}`))
      .pipe(gulp.dest('intermediate'));
    return gulp.src([`intermediate/${appFile}`, `intermediate/${styleFile}`])
      .pipe(assetFilter)
      .pipe(rev())
      .pipe(gulp.dest('dist/static'))
      .pipe(rev.manifest())
      .pipe(gulp.dest('intermediate'));
  };
}

gulp.task("sass", function(){
  return gulp.src('styles/**/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('intermediate'));
});

gulp.task("revisionProd", ["minify", "cleanDist", "minifyCss"], revisionFn(true));
gulp.task("revision", ["bundle", "cleanDist"], revisionFn(false));

function revisionRewriteFn() {
  const manifest = gulp.src('intermediate/rev-manifest.json');

  return gulp.src(['intermediate/*.html'])
    .pipe(revRewrite({manifest}))
    .pipe(gulp.dest('dist'));
}

gulp.task("designPage", ["revision"], function(){
  return gulp.src("styles/designPage.html")
    .pipe(gulp.dest("intermediate"));
});

gulp.task("revisionRewrite", ['designPage'], revisionRewriteFn);

gulp.task("revisionRewriteProd", ['revisionProd'], revisionRewriteFn);

gulp.task("buildToProd", ['revisionRewriteProd'], function() {
  return gulp.src(['dist/static/*.js', 'dist/static/*.css'])
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
  gulp.watch('./styles/**/*.scss', DEV_TASK);
  gulp.watch('./styles/**/*.html', DEV_TASK);
  gulp.watch('dist/**/*').on("change", reload);
});

gulp.task("default", ["bundle", "docs", "test"]);
