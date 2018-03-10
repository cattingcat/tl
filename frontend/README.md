# LIST

### HOW TO RUN:
```
  pub upgrade --no-precompile
  pub run build_runner serve
```

### BUILD
[Examples](https://github.com/dart-lang/angular/tree/master/examples)
```
    pub run build_runner build --config=release --fail-on-severe --output build
    pub run build_runner build --config=debug --fail-on-severe --output build
```

### DEPLOY TO HEROKU
1. Checkout to deploy branch
``` 
    git checkout heroku-deploy 
```

2. Pull changes from master-branch
```
    git pull origin master
```
3. Check **index.php** in root of repo
4. Build app; See **BUILD** section
5. Add build artifacts and push them to **heroku-deploy** branch
``` 
    git add ./build/web -f
    git add ./build/packages/browser -f
    git commit -m '...'
    git push origin heroku-deploy
```
6. Run deploy on heroku dashboard
7. Open [herokuapp](https://notes-for-poor.herokuapp.com)


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
    google-chrome --disable-web-security
```
