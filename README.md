# Expense Tracker

A Flutter app for tracking personal expenses across multiple categories, with a pie chart summary and swipe-to-delete support.

---

## Features

- Add expenses with a title, amount, date, and category
- Pie chart breakdown of spending by category
- Swipe to delete expenses, with an undo option via snackbar
- Light and dark theme support based on system preference
- Form validation with an alert dialog for invalid inputs

---

## Project Structure

```
lib/
├── main.dart
├── model/
│   └── expense.dart
└── widgets/
    ├── expenses.dart
    ├── newexpense.dart
    └── expenses_list/
        ├── expenses_list.dart
        └── expense_item.dart
```

- **main.dart** — App entry point and theme configuration
- **model/expense.dart** — Expense model, Category enum, and expensebucket helper class
- **widgets/expenses.dart** — Main screen combining the pie chart and expense list
- **widgets/newexpense.dart** — Modal bottom sheet form for adding a new expense
- **widgets/expenses_list/expenses_list.dart** — Dismissible list of expense entries
- **widgets/expenses_list/expense_item.dart** — Individual expense card widget

---

## Categories

`place`, `food`, `travel`, `entertainment`, `study`

---

## Getting Started

Prerequisites: Flutter SDK 3.0+

```bash
git clone https://github.com/your-username/expense_tracker.git
cd expense_tracker
flutter pub get
flutter run
```

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  fl_chart: ^0.68.0
  intl: ^0.19.0
  uuid: ^4.0.0
```

---

## License

MIT