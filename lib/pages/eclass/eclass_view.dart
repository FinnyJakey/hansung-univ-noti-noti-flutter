import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/models/shared_pref_model.dart';
import 'package:hansungunivnotinoti/pages/eclass/eclass_board_view.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:hansungunivnotinoti/widgets/spinkit_fading_circle.dart';
import 'package:provider/provider.dart';

class EclassView extends StatefulWidget {
  const EclassView({Key? key}) : super(key: key);

  @override
  State<EclassView> createState() => _EclassViewState();
}

class _EclassViewState extends State<EclassView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<EclassProvider>().clearEclass();
      context.read<LoginState>().loginStatus
          ? context.read<EclassProvider>().getEclass()
          : await context
                  .read<LoginProvider>()
                  .loginAll(SharedPrefModel.id, SharedPrefModel.pw)
              ? context.read<EclassProvider>().getEclass()
              : {if (mounted) Navigator.pushNamed(context, '/login')};
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeState>();
    final eclassState = context.watch<EclassState>();
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: themeState.systemUiOverlayStyle,
        leading: CupertinoButton(
          child: Icon(
            Icons.chevron_left_rounded,
            color: themeState.fontColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(opacity: 0.7),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'E-class',
          style: TextStyle(
            fontSize: 18.0,
            color: themeState.fontColor,
          ),
        ),
      ),
      body: eclassState.isLoading
          ? spinkitfadingcircle()
          : eclassState.eclass.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Colors.grey,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        const Text(
                          "조회된 현학기 수강 내역이 없어요!",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          context.read<EclassProvider>().clearEclass();
                          context
                              .read<LoginProvider>()
                              .loginAll(SharedPrefModel.id, SharedPrefModel.pw)
                              .then((value) {
                            if (value) {
                              context.read<EclassProvider>().getEclass();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 20.0,
                        top: 5.0,
                        bottom: 5.0,
                        right: 20.0,
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EclassBoardView(
                              eclassState.eclass[index]['link']),
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(eclassState.eclass[index]['title']),
                          Text(
                            '${eclassState.eclass[index]['professor']} | 수강인원 ${eclassState.eclass[index]['participants']}',
                            style: TextStyle(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.6),
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: eclassState.eclass.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      thickness: 1,
                      indent: 20.0,
                      endIndent: 20.0,
                    );
                  },
                ),
    );
  }
}
