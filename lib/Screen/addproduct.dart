import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task/DataBase/database_helper.dart';
import 'package:task/DataBase/product.dart';
import 'package:task/Screen/home.dart';
import 'package:task/Widgets/button.dart';
import 'package:task/Widgets/colordata.dart';
import 'package:task/Widgets/text.dart';
import 'package:task/Widgets/textbox.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:task/statemangement/dashboard_screen_provider.dart';

String titleG = '';
Product prodG = Product('', '', '', '', 0);

class AddProduct extends StatefulWidget {
  AddProduct(String s, Product product, {Key? key}) : super(key: key) {
    titleG = s;
    prodG = product;
  }

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  DataBaseHelper databaseHelper = DataBaseHelper();
  Product product = Product('', '', '', '', 0);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController launchSiteController = TextEditingController();

  final int _ratingBarMode = 1;
   double _initialRating = 2.0;
  final bool _isVertical = false;
  double _rating=2;
  IconData? _selectedIcon;
  late DateTime pickedDate;
  @override
  void initState() {
    super.initState();
    if (prodG.productName != '') {
      nameController.text = prodG.productName;
      dateController.text = prodG.launchAt;
      product.launchAt= prodG.launchAt;
      launchSiteController.text = prodG.launchSite;
      _rating=prodG.popularity;
      _initialRating=prodG.popularity;
      String year,month,date;
      year =product.launchAt.split('/')[2];
      month =product.launchAt.split('/')[0];
      date =product.launchAt.split('/')[1];
      pickedDate=DateTime(int.parse(year),int.parse(month),int.parse(date));

      final postMdl =
      Provider.of<AddProductProvider>(context, listen: false);
      postMdl.setDateController(dateController);
    }
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
          title: NormalText(
            color: ColorData.grey,
            text: titleG,
            size: 18,
            weight: FontWeight.w700,
          ),
          centerTitle: true,
          backgroundColor: ColorData.white,
          iconTheme: const IconThemeData(color: ColorData.primary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BorderTextField(
                    textName: 'Product Name',
                    hintText: 'Enter Product Name',
                    controller: nameController,
                    validatorText: 'Product Name cannot be empty!'),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2000, 1, 1),
                        maxTime: DateTime(2050, 6, 7),
                        theme: const DatePickerTheme(
                            headerColor: Colors.orange,
                            backgroundColor: Colors.blue,
                            itemStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                            doneStyle:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        onChanged: (date) {
                      print('change $date in time zone ' +
                          date.timeZoneOffset.inHours.toString());
                    }, onConfirm: (date) {
                      pickedDate = date;
                      dateController.text = pickedDate.month.toString() +
                          '/' +
                          pickedDate.day.toString() +
                          '/' +
                          pickedDate.year.toString();
                      final postMdl =
                      Provider.of<AddProductProvider>(context, listen: false);
                      postMdl.setDateController(dateController);
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Consumer<AddProductProvider>(
                    builder: (context, provider, child) {
                      return NormalText(
                        color: ColorData.secondary,
                        text: 'Select Date: ' + provider.dateController.text,
                        size: 16,
                        weight: FontWeight.w400,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                BorderTextField(
                    textName: 'Launch Site',
                    hintText: 'Enter Launch Site',
                    controller: launchSiteController,
                    validatorText: 'Launch Site cannot be empty!'),
                const SizedBox(height: 10.0),
                _ratingBar(_ratingBarMode),
                const SizedBox(height: 20.0),
                NormalButton(
                    textName: titleG,
                    onPressed: () {
                      _formKey.currentState!.validate();
                      _save();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }



  // Save data to database
  void _save() async {
    product.productName = nameController.text;


    product.launchAt = pickedDate.month.toString() +
        '/' +
        pickedDate.day.toString() +
        '/' +
        pickedDate.year.toString();


    product.launchSite = launchSiteController.text;
    product.popularity = _rating;
    // moveToLastScreen();

    product.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (titleG != 'Add Product') {
      // Case 1: Update operation
      result = await databaseHelper.updateTodo(product);
    } else {
      // Case 2: Insert Operation
      result = await databaseHelper.insertTodo(product);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Product Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Product');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text(
            "OK",
            style: TextStyle(fontSize: 20, color: ColorData.primary),
          ),
          onPressed: () {
            final postMdl =
                Provider.of<DashBoardScreenProvider>(context, listen: false);

            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const HomePage()))
                .then((value) => postMdl.updateListView('Launch At'));
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Widget _ratingBar(int mode) {
    switch (mode) {
      case 1:
        return RatingBar.builder(
          initialRating: _initialRating,
          minRating: 1,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          allowHalfRating: true,
          unratedColor: Colors.amber.withAlpha(50),
          itemCount: 5,
          itemSize: 50.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            _selectedIcon ?? Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            _rating = rating;
            final postMdl =
            Provider.of<AddProductProvider>(context, listen: false);
            postMdl.setRating(_rating);
          },
          updateOnDrag: true,
        );
      case 2:
        return RatingBar(
          initialRating: _initialRating,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: _image('assets/heart.png'),
            half: _image('assets/heart_half.png'),
            empty: _image('assets/heart_border.png'),
          ),
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          onRatingUpdate: (rating) {
            _rating = rating;
            final postMdl =
            Provider.of<AddProductProvider>(context, listen: false);
            postMdl.setRating(_rating);
          },
          updateOnDrag: true,
        );
      case 3:
        return RatingBar.builder(
          initialRating: _initialRating,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return const Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return const Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return const Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                );
              case 3:
                return const Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return const Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
              default:
                return Container();
            }
          },
          onRatingUpdate: (rating) {
            _rating = rating;
            final postMdl =
            Provider.of<AddProductProvider>(context, listen: false);
            postMdl.setRating(_rating);
          },
          updateOnDrag: true,
        );
      default:
        return Container();
    }
  }
}

Widget _image(String asset) {
  return Image.asset(
    asset,
    height: 30.0,
    width: 30.0,
    color: ColorData.primary,
  );
}
