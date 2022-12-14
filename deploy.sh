#!/usr/bin/env sh
# abort on errors
set -e
# build
yarn run build
# navigate into the build output directory
cd dist

cp index.html 404.html
git init
git add -A
git commit -m 'deploy'
git push -f git@github.com:alitokmakci/SudokuVue.git master:gh-pages
cd -

