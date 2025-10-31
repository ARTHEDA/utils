import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utils/api/types.dart';
import 'package:utils/extensions.dart';
import 'package:utils/widgets/buttons/custom_button.dart';
import 'package:utils/widgets/wrappers/intl_default_locale_wrapper.dart';
import 'package:utils/widgets/wrappers/state_processing_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: colorScheme,
        visualDensity: VisualDensity.standard,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 24),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.fromLTRB(25, 17, 25, 17),
          fillColor: Colors.grey,
          hintStyle: TextStyle(fontSize: 24),
          labelStyle: TextStyle(fontSize: 24),
          floatingLabelStyle: TextStyle(fontSize: 24),
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((s) {
              return s.contains(WidgetState.disabled) ? colorScheme.secondary : colorScheme.primary;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((s) {
              return s.contains(WidgetState.disabled)
                  ? colorScheme.onSecondary
                  : colorScheme.onPrimary;
            }),
            overlayColor: WidgetStatePropertyAll(colorScheme.onPrimary.withOpacity(0.05)),
            shadowColor: WidgetStatePropertyAll(colorScheme.shadow),
            elevation: const WidgetStatePropertyAll(0),
            side: const WidgetStatePropertyAll(BorderSide.none),
            minimumSize: const WidgetStatePropertyAll(Size.zero),
            iconSize: 20.0.let(WidgetStatePropertyAll.new),
            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            visualDensity: VisualDensity.standard,
          ),
        ),
      ),
      builder: IntlDefaultLocalizationWrapper.builder,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final state = RxV([false]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextFormField(
              initialValue: 'Bob',
              decoration: InputDecoration(
                labelText: 'Bob',
              ),
            ),
            const CustomButton(
              text: 'Test',
            ),
            Obx(
              () => CustomButton(
                text: 'Test',
                onPressed: () {
                  state.execute(
                    () => safeMock(state.data.let((d) => d.isEmpty ? [false] : [])),
                  );
                },
                isLoading: state.isPending,
              ),
            ),
            SizedBox(
              height: 500,
              child: StateProcessingWidget(
                builder: (context, state) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.red,
                        height: 40,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 10),
                      );
                    },
                    itemCount: 10,
                  );
                },
                rxv: state,
                defaultEmptyText: 'Empty',
              ),
            ),
          ].joinWidget(const SizedBox(height: 10)),
        ),
      ),
    );
  }
}
