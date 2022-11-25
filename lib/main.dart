//export PATH=/Users/crich/Documents/flutter/bin:$PATH

import 'dart:developer';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaitr/cubit/cloud/amplify_cubit.dart';
import 'package:gaitr/cubit/cloud/auth_cubit.dart';
import 'package:gaitr/components/fancy_plasma.dart';
import 'package:gaitr/pages/pages.dart';

void main() {
  runApp(const Root());
}

//TODO TEST On IPAD
//TODO indexer on editor page
//TODO offline case
//TODO add 10 feet option
//TODO update email template

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AmplifyCubit()..init(),
      child: BlocBuilder<AmplifyCubit, AmplifyState>(
        builder: (context, state) {
          if (state is AmplifyConfigured) {
            return Authenticator(
              onException: (p0) {
                if (p0.toString().contains(
                    "Unexpected error occurred with message: An unknown error occurred")) {
                  log("Likely offline");
                }
              },
              child: BlocProvider(
                create: (context) => AuthCubit()..authUser(),
                child: BlocBuilder<AuthCubit, AuthState>(
                  bloc: AuthCubit()..authUser(),
                  builder: (context, state) {
                    return buildApp(context);
                  },
                ),
              ),
            );
          } else {
            return CupertinoApp(
              color: CupertinoColors.systemBackground,
              title: 'gaitr',
              home: loadingView(),
            );
          }
        },
      ),
    );
  }

  Widget loadingView() {
    return Stack(
      children: [
        const FancyPlasmaWidget(color: Color(0xFF71C5E8)),
        Container(
          alignment: Alignment.bottomCenter,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("gaitr-logo.png"),
            fit: BoxFit.fitWidth,
          )),
          child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: CupertinoActivityIndicator()),
        ),
      ],
    );
  }

  Widget buildApp(BuildContext context) {
    return CupertinoApp(
      color: CupertinoColors.systemBackground,
      title: 'gaitr',
      builder: Authenticator.builder(),
      routes: {
        "/": (context) => const LandingPage(),
        "/pdf": (context) => const PdfPage(),
        "/settings": (context) => const SettingsPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/measurement") {
          final useVideo = settings.arguments as bool;
          return CupertinoPageRoute(
              builder: (_) =>
                  useVideo ? const VideoPage() : const StopwatchPage());
        }
        return null;
      },
    );
  }
}
