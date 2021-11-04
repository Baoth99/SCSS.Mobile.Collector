import 'package:collector_app/blocs/categories_bloc.dart';
import 'package:collector_app/blocs/events/categories_event.dart';
import 'package:collector_app/blocs/models/scrap_category_model.dart';
import 'package:collector_app/blocs/states/categories_state.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/constants/text_constants.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/utils/cool_alert.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class CategoriesLayout extends StatelessWidget {
  const CategoriesLayout();

  @override
  Widget build(BuildContext context) {
    // category screen
    return BlocProvider(
      create: (context) => CategoriesBloc(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<CategoriesBloc, CategoriesState>(
            listener: (context, state) {
              if (state is NotLoadedState) {
                EasyLoading.show(status: TextConstants.processing);
              } else {
                EasyLoading.dismiss();
                if (state is ErrorState) {
                  CustomCoolAlert.showCoolAlert(
                    context: context,
                    title: state.errorMessage,
                    type: CoolAlertType.success,
                    onTap: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName(Routes.main));
                    },
                  );
                }
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: _appBar(context),
          body: _body(),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        TextConstants.category,
      ),
      actions: [
        BlocBuilder<CategoriesBloc, CategoriesState>(
          buildWhen: (p, c) => false,
          builder: (blocContext, state) {
            return InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(Routes.addCategory)
                  .then((value) {
                blocContext.read<CategoriesBloc>().add(EventInitData());
              }),
              child: Container(
                width: 60,
                child: Center(
                  child: Icon(
                    Icons.add,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _body() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 70,
            child: _searchField(),
          ),
          Flexible(
            child: _list(),
          ),
        ],
      ),
    );
  }

  _searchField() {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          color: Colors.white,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              labelText: 'Tìm danh mục...',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixIcon:
                  Icon(Icons.search, color: Theme.of(context).accentColor),
            ),
            onChanged: (value) {
              context
                  .read<CategoriesBloc>()
                  .add(EventChangeSearchName(searchName: value));
            },
          ),
        );
      },
    );
  }

  _list() {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (blocContext, state) {
        if (state is LoadedState) {
          if (state.filteredCategories.isNotEmpty) {
            return LazyLoadScrollView(
                scrollDirection: Axis.vertical,
                onEndOfPage: () {
                  print('load more');
                  _loadMoreTransactions(blocContext);
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    print('init');
                    blocContext.read<CategoriesBloc>().add(EventInitData());
                  },
                  child: GroupedListView<ScrapCategoryModel, String>(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 40),
                    physics: AlwaysScrollableScrollPhysics(),
                    elements: state.filteredCategories,
                    order: GroupedListOrder.ASC,
                    groupBy: (ScrapCategoryModel element) =>
                        element.name.characters.first.toUpperCase(),
                    groupSeparatorBuilder: (String element) =>
                        _groupSeparatorBuilder(name: element),
                    itemBuilder: (context, element) =>
                        _listTileBuilder(model: element, context: context),
                    separator: SizedBox(height: 10),
                  ),
                ));
          } else {
            return Center(
              child: Text('Không có danh mục'),
            );
          }
        } else {
          if (state is NotLoadedState) {
            return Center(
              child: Text('Không có danh mục'),
            );
          } else {
            return FunctionalWidgets.customErrorWidget();
          }
        }
      },
    );
  }

  _groupSeparatorBuilder({required String name}) {
    return Container(child: Text(name.characters.first.toUpperCase()));
  }

  _listTileBuilder({required ScrapCategoryModel model, required context}) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (blocContext, state) {
      return ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: SizedBox(
          width: 45.0,
          height: 45.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Stack(
              children: [
                const SizedBox(
                  width: 45.0,
                  height: 45.0,
                  child: const DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.green),
                  ),
                ),
                if (model.image != null)
                  Positioned(
                    width: 45.0,
                    height: 45.0,
                    child: Image(
                      image: model.image!,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ),
        ),
        title: Text(model.name),
        onTap: () => Navigator.of(context)
            .pushNamed(
          Routes.categoryDetail,
          arguments: model.id,
        )
            .then(
          (value) {
            blocContext.read<CategoriesBloc>().add(EventInitData());
          },
        ),
      );
    });
  }

  Future _loadMoreTransactions(BuildContext context) async {
    context.read<CategoriesBloc>().add(EventLoadMoreCategories());
  }
}
