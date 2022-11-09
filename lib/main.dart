//TO ADD FLUTTER TO PATH, PUT THIS IN THE TERMINAL
//export PATH=/Users/crich/Documents/flutter/bin:$PATH

import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaiter/cubit/cloud/amplify_cubit.dart';
import 'package:gaiter/cubit/cloud/auth_cubit.dart';
import 'package:gaiter/components/fancy_plasma.dart';
import 'package:gaiter/pages/pages.dart';

void main() {
  runApp(const Root());
}

//TODO Ios app store (payment)
//TODO TEST On IPAD

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
    //configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AmplifyCubit()..init(),
      child: BlocBuilder<AmplifyCubit, AmplifyState>(
        builder: (context, state) {
          if (state is AmplifyConfigured) {
            return Authenticator(
              child: BlocProvider(
                create: (context) => AuthCubit()..authUser(),
                child: BlocBuilder<AuthCubit, AuthState>(
                  bloc: AuthCubit()..authUser(),
                  builder: (context, state) {
                    return CupertinoApp(
                      color: CupertinoColors.systemBackground,
                      title: 'Gaiter',
                      builder: Authenticator.builder(),
                      routes: {
                        "/": (context) => const LandingPage(),
                        "/confirm": (context) => const ConfirmPage(),
                        "/settings": (context) => const SettingsPage(),
                      },
                      onGenerateRoute: (settings) {
                        if (settings.name == "/measurement") {
                          final useVideo = settings.arguments as bool;
                          return CupertinoPageRoute(
                              builder: (_) => useVideo
                                  ? const VideoPage()
                                  : const StopwatchPage());
                        }
                        return null;
                      },
                    );
                  },
                ),
              ),
            );
          } else {
            return CupertinoApp(
              color: CupertinoColors.systemBackground,
              title: 'Gaiter',
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
        FancyPlasmaWidget(color: CupertinoColors.systemBlue.withOpacity(0.4)),
        Container(
          alignment: Alignment.bottomCenter,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("gaiter-logo.png"),
            fit: BoxFit.fitWidth,
          )),
          child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: CupertinoActivityIndicator()),
        ),
      ],
    );
  }
}
