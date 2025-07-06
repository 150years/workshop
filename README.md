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

Если рассчитанное значение не делися нацело на min_quantity → устанавливаем quantity = ближайшее большее число которое делится нацело

* Отправка писем без вложения
```
MailgunService.send_email(
  to: 'client@example.com',
  subject: 'Welcome to TGT',
  html_body: '<p>Thank you for contacting us!</p>'
)
```

* Отправка писем с вложением
```
MailgunService.send_email(
  to: 'supplier@example.com',
  subject: 'Order',
  html_body: '<p>Order details attached</p>',
  pdf_data: pdf,
  filename: 'order.pdf'
)
```

* Пример метода в контролллере для отправки письма
```
def send_email_to_supplier
  order = Order.find(params[:order_id])
  version = order.final_or_latest_version
  supplier = Supplier.find(params[:supplier_id])

  pdf = ComponentOrderPdf.new(order, version).render

  MailgunService.send_component_email(
    to: supplier.email,
    subject: "Component Order - #{order.name} #{version.full_quotation_number}",
    html_body: render_to_string(template: 'component_order_mailer/send_component_order', layout: false),
    pdf_data: pdf,
    filename: "#{version.full_quotation_number}_#{order.name.parameterize}.pdf"
  )

  redirect_to order_components_orders_path(order), notice: 'Email was sent successfully.', status: :see_other
end
```

* Подключение JS/CSS в проекте
В проекте используется прямое подключение JS/CSS без fingerprint через стандартные Rails-теги:
```
<%= javascript_include_tag "application", "data-turbo-track": "reload", type: "module" %>
<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
```
Файлы собираются с помощью Bun в app/assets/builds