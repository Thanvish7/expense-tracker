import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/expenses.dart';

var kcolorScheme = ColorScheme.fromSeed(
  seedColor: Color.fromARGB(75, 25, 190, 180),
);
var kdcolorscheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Color.fromARGB(255, 5, 99, 125),
);
void main() {
  runApp(
    MaterialApp(
  
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kdcolorscheme,


        cardTheme: CardThemeData().copyWith(
          color: kdcolorscheme.secondaryContainer,
          margin: EdgeInsets.symmetric(vertical: 7, horizontal: 8),
        ),

       

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kdcolorscheme.primaryContainer,
          ),
        ),
      ),

      theme: ThemeData.light().copyWith(
        colorScheme: kcolorScheme,
        appBarTheme: AppBarTheme().copyWith(
          backgroundColor: kcolorScheme.errorContainer,
          foregroundColor: const Color.fromARGB(255, 3, 55, 98),
        ),
        cardTheme: CardThemeData().copyWith(
          color: kcolorScheme.secondaryContainer,
          margin: EdgeInsets.symmetric(vertical: 7, horizontal: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kcolorScheme.errorContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleSmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: Expenses(),
    ),
  );
}
