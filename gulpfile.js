var gulp         = require('gulp'),
    browserSync  = require('browser-sync'), // Asynchronous browser loading on .scss file changes
    reload       = browserSync.reload,
    autoprefixer = require('gulp-autoprefixer'), // Autoprefixing magic
    minifycss    = require('gulp-uglifycss'),
    uglify       = require('gulp-uglify'),
    concat       = require('gulp-concat'),
    notify       = require('gulp-notify'),
    imagemin     = require('gulp-imagemin'),
    newer        = require('gulp-newer'),
    rimraf       = require('gulp-rimraf'),
    sass         = require('gulp-sass'),
    plumber      = require('gulp-plumber'), // Helps prevent stream crashing on errors
    ignore       = require('gulp-ignore'), // Helps with ignoring files and directories in our run tasks
    sourcemaps   = require('gulp-sourcemaps');


gulp.task('sass', function () {
    return      gulp.src('vendor/assets/styles/**/*.scss')
        .pipe(plumber({
            errorHandler: function (error) {
                console.log(error.message);
                this.emit('end');
            }
        }))
        .pipe(sass({
            indentedSyntax: false
        }))
        .pipe(autoprefixer())
        .pipe(gulp.dest('./vendor/dist/css'))
});

gulp.task('js_libs', function() {
    return      gulp.src('./vendor/assets/scripts/libs/**/*.js')
        .pipe(concat('libs.js'))
        .pipe(gulp.dest('./vendor/dist/scripts'))
        .pipe(uglify())
        .pipe(gulp.dest('./vendor/dist/scripts'))
        .pipe(notify({ message: 'Vendor scripts task complete', onLast: true }));
});

gulp.task('js_app', function() {
    return      gulp.src('./vendor/assets/scripts/custom/*.js')
        .pipe(concat('custom.js'))
        .pipe(uglify())
        .pipe(gulp.dest('./vendor/dist/scripts'))
        .pipe(notify({ message: 'Custom scripts task complete', onLast: true }));
});

gulp.task('images', function() {

// Add the newer pipe to pass through newer images only
    return  gulp.src(['./vendor/assets/images/raw/**/*.{png,jpg,gif}'])
        .pipe(newer('./vendor/assets/images/'))
        .pipe(rimraf({ force: true }))
        .pipe(imagemin({ optimizationLevel: 7, progressive: true, interlaced: true }))
        .pipe(gulp.dest('./images/'))
        .pipe( notify( { message: 'Images task complete', onLast: true } ) );
});


// Watch Task
gulp.task('default', ['sass', 'js_libs', 'js_app'], function () {

    var files = [
        '**/*.php',
        '**/*.{png,jpg,gif}'
    ];
    browserSync.init(files, {

        // Read here http://www.browsersync.io/docs/options/
        proxy: 'localhost:3000',

        // port: 8080,

        // Tunnel the Browsersync server through a random Public URL
        // tunnel: true,

        // Attempt to use the URL "http://my-private-site.localtunnel.me"
        // tunnel: "ppress",

        // Inject CSS changes
        injectChanges: true

    });

    gulp.watch('./vendor/assets/images/**/*', ['images']);
    gulp.watch('./vendor/assets/styles/**/*.scss', ['sass', browserSync.reload]);
    gulp.watch('./vendor/assets/scripts/**/*.js', ['js_app', browserSync.reload]);
});