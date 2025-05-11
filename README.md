# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:
* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Deployment instructions

* START WITH GIT
```
git fetch origin
git fetch --all -p
git checkout main
git pull
git reset --hard origin/main
bundle install
```

* PUSH
```
bundle exec rubocop -A
bundle exec rspec
git add -A
git commit -m xxx
git push -u origin [branch-name]
```

* UI
- https://csszero.lazaronixon.com/

* UI -> 2
- https://polarisviewcomponents.org/lookbook/pages/overview

* Логика для расчета quantity по продукту

Если формулы нет → quantity = 1

Если формула есть → рассчитываем quantity через evaluate_quantity

Если min_quantity больше, чем рассчитанное значение → устанавливаем quantity = min_quantity

Если unit == 'lines' → округляем quantity вверх
