import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task/DataBase/product.dart';
import 'package:task/Widgets/colordata.dart';
import 'package:task/Widgets/text.dart';
import 'package:task/DataBase/database_helper.dart';
import 'package:task/statemangement/dashboard_screen_provider.dart';
import 'addproduct.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  deleteDialogue(BuildContext context, int index) {
    Widget okButton = TextButton(
      child: const Text(
        "OK",
        style: TextStyle(fontSize: 20, color: ColorData.primary),
      ),
      onPressed: () {
        final postMdl =
            Provider.of<DashBoardScreenProvider>(context, listen: false);
        postMdl.delete(context, postMdl.productList[index], 'Launch At');
      },
    );
    AlertDialog alert = AlertDialog(
      title: NormalText(
        color: ColorData.grey,
        text: 'Do you really want to delete',
        size: 18,
        weight: FontWeight.w700,
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  DataBaseHelper databaseHelper = DataBaseHelper();
  //List<Product> productList=[] ;
  //int count = 0;
  String dropdownValue = 'Name';
  late final _ratingController;
  double _userRating = 3.0;
  final bool _isVertical = false;

  IconData? _selectedIcon;

  @override
  void initState() {
    super.initState();
    final postMdl =
        Provider.of<DashBoardScreenProvider>(context, listen: false);
    postMdl.updateListView('Launch At');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: ColorData.primary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NormalText(
                color: ColorData.grey,
                text: 'Product List',
                size: 18,
                weight: FontWeight.w700,
              ),
              Consumer<DashBoardScreenProvider>(
                builder: (context, provider, child) {
                  return DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      //setState(() {
                      dropdownValue = newValue!;
                      provider.updateListView(dropdownValue);
                      // });
                    },
                    items: <String>[
                      'Launch At',
                      'Name',
                      'Launch Site',
                      'Popularity'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 30, color: ColorData.primary),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AddProduct(
                          "Add Product", Product('', '', '', '', 0))));
                },
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: ColorData.white,
          iconTheme: const IconThemeData(color: ColorData.primary),
        ),
      ),
      body: Consumer<DashBoardScreenProvider>(
        builder: (context, provider, child) {
          return provider.loading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: ColorData.primary,
                  ),
                )
              : GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  shrinkWrap: true,
                  children: List.generate(
                    provider.count,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  children: [
                                    NormalText(
                                        size: 16,
                                        color: ColorData.secondary,
                                        text: provider.productList[index].date,
                                        weight: FontWeight.w400),
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        AddProduct(
                                                            "Edit Product",
                                                            provider.productList[
                                                                index])));
                                          },
                                          child: const Icon(
                                            Icons.edit,
                                            color: ColorData.grey,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            deleteDialogue(context, index);
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: ColorData.red,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                NormalText(
                                    size: 18,
                                    color: ColorData.secondary,
                                    text:
                                        provider.productList[index].productName,
                                    weight: FontWeight.w500),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                NormalText(
                                    size: 16,
                                    color: ColorData.secondary,
                                    text:
                                        provider.productList[index].launchSite,
                                    weight: FontWeight.w400),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                NormalText(
                                    size: 16,
                                    color: ColorData.secondary,
                                    text: provider.productList[index].launchAt,
                                    weight: FontWeight.w500),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                RatingBarIndicator(
                                  rating:
                                      provider.productList[index].popularity,
                                  itemBuilder: (context, index) => Icon(
                                    _selectedIcon ?? Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 30.0,
                                  unratedColor: Colors.amber.withAlpha(50),
                                  direction: _isVertical
                                      ? Axis.vertical
                                      : Axis.horizontal,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
