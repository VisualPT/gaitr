//export PATH=/Users/crich/Documents/flutter/bin:$PATH

import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaitr/cubit/auth/auth_cubit.dart';
import 'package:gaitr/cubit/backend/backend_cubit.dart';
import 'package:gaitr/pages/pages.dart';

void main() {
  runApp(const Root());
}
//TODO add 10 feet option

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BackendCubit()..init()),
          BlocProvider(create: (context) => AuthCubit()..authUser()),
        ],
        child:
            BlocBuilder<BackendCubit, BackendState>(builder: (context, state) {
          if (state is BackendConnected) {
            return Authenticator(child:
                BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
              return CupertinoApp(
                  debugShowCheckedModeBanner: false,
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
                          builder: (_) => useVideo
                              ? const VideoPage()
                              : const StopwatchPage());
                    }
                    return null;
                  });
            }));
          } else if (state is BackendError) {
            return CupertinoApp(
              color: CupertinoColors.systemBackground,
              title: 'gaitr',
              home: LoadingPage(
                message: state.message,
                isLoading: false,
              ),
            );
          }
          return const CupertinoApp(
            color: CupertinoColors.systemBackground,
            title: 'gaitr',
            home: LoadingPage(
              message: "Loading",
              isLoading: true,
            ),
          );
        }));
  }
}
