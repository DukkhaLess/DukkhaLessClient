const gulp = require("gulp");
const purescript = require("gulp-purescript");
const run = require("gulp-run");
const rev = require("gulp-rev");
const filter = require('gulp-filter');
const del = require("del");

const sources = [
    "src/**/*.purs",
    "bower_components/purescript-*/src/**/*.purs",
];

gulp.task("clean", function() {
    return del([
        "dist/**/*"
    ]);
});

gulp.task("make", function () {
    return purescript.compile({ src: sources });
});

gulp.task("bundle", ["make"], function () {
    return purescript
        .bundle({ src: "output/**/*.js", output: "intermediate/app.js", module: "Main" });
});

gulp.task("version", ["clean", "bundle"], function() {
    const assetFilter = filter(['**/*', '!**/index.html'], { restore: true });
    return gulp.src('intermediate/app.js')
        .pipe(assetFilter)
        .pipe(rev())
        .pipe(gulp.dest('dist'));
});

const DEV_TASK = ["version"];
gulp.task("dev", function() {
    gulp.watch('./src/**/*.purs', DEV_TASK);
    gulp.watch('./src/**/*.js', DEV_TASK);
    gulp.watch('./index.html', DEV_TASK);
});

gulp.task("docs", function () {
    return purescript.docs({
        src: sources,
        docgen: {
            "Name.Of.Module1": "docs/Name/Of/Module1.md",
            "Name.Of.Module2": "docs/Name/Of/Module2.md"
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

gulp.task("default", ["bundle", "docs", "test"]);
