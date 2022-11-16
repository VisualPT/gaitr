//export PATH=/Users/crich/Documents/flutter/bin:$PATH

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

//TODO Ios app store (payment)
//TODO test time recording on PDF
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
                      title: 'gaitr',
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
        FancyPlasmaWidget(color: CupertinoColors.systemBlue.withOpacity(0.4)),
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
}
