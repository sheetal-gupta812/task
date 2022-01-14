import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task/DataBase/database_helper.dart';
import 'package:task/DataBase/product.dart';

class DashBoardScreenProvider extends ChangeNotifier{
  DataBaseHelper databaseHelper = DataBaseHelper();
  List<Product> productList=[] ;
  int count = 0;
  String dropdownValue = 'Name';

  bool loading=true;


   Future<void> updateListView(String dropdownValue) async {
    int s=0;
    switch(dropdownValue)
    {
      case 'Launch At':
        s=0;
        break;
      case 'Name':
        s=1;
        break;
      case 'Launch Site':
        s=2;
        break;
      case 'Popularity':
        s=3;
        break;
    }
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    await dbFuture.then((database) {
      Future<List<Product>> todoListFuture = databaseHelper.getTodoList(s);
      todoListFuture.then((todoList) {
          productList = todoList;
          count = todoList.length;
          notifyListeners();
      });
    });
    loading=false;
    notifyListeners();
  }

  void delete(BuildContext context, Product prod,String dropdownValue) async {
    int result = await databaseHelper.deleteTodo(prod.productName);
    if (result != 0) {
      updateListView(dropdownValue);
      Navigator.pop(context);
    }
  }
}

class AddProductProvider extends ChangeNotifier{
  TextEditingController dateController = TextEditingController();

  late double _rating;

  void setRating(double r)
  {
    _rating=r;
    notifyListeners();
  }

  void setDateController(TextEditingController dController )
  {
    dateController=dController;
    notifyListeners();
  }
}