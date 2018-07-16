# LIST

### HOW TO RUN DEV:
```
  ./build-dev.sh
```

### BUILD MINIFIED JS
[Examples](https://github.com/dart-lang/angular/tree/master/examples)
```
    ./build.sh
```

### DEPLOY TO HEROKU
1. Build app; See **BUILD** section
2. Move build artifacts to [backend repo](https://github.com/stupidnerd/TaskManager) to **wwwroot** directory
``` 
    git commit -m '...'
    git push origin heroku-deploy
```
7. Open [herokuapp](https://task-manager-for-poor.herokuapp.com)


### OTHER COMMENTS
[Dart2 + Angular5 example](https://github.com/dart-lang/angular_components_example)

[Dart builder info](https://github.com/dart-lang/build)

[Solution for windows angular](https://github.com/dart-lang/angular/issues/766)

[Material icons](https://material.io/icons)

[Color schemes](https://www.canva.com/learn/website-color-schemes)

Multiple SDK on same machine
```
    sudo ln -sTf ~/dart2/ /usr/lib/dart
```

Bypass CORS for chrome
```
    google-chrome --disable-web-security --user-data-dir
```
