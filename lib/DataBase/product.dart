class Product {

  String _productName = '';
  String _launchAt = '';
  String _date = '';
  String _launchSite = '';
  double _popularity = 0;

  Product(this._productName, this._launchAt, this._date, this._launchSite,this._popularity );


  String get productName => _productName;

  String get launchAt => _launchAt;

  String get date => _date;

  String get launchSite => _launchSite;

  double get popularity => _popularity;


  set productName(String newProdName) {
    if (newProdName.length <= 255) {
      _productName = newProdName;
    }
  }
  set launchAt(String newlaunchAt) {
    if (newlaunchAt.length <= 50) {
      _launchAt = newlaunchAt;
    }
  }

  set date(String newDate) {
   _date = newDate;
  }

  set launchSite(String newlaunchSite) {
    if (newlaunchSite.length <= 100) {
      _launchSite = newlaunchSite;
    }
  }

  set popularity(double newPopularity) {
    if (newPopularity <= 5) {
      _popularity = newPopularity;
    }
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (productName != null) {
      map['productName'] = _productName;
    }
    map['launchSite'] = launchSite;
    map['launchAt'] = _launchAt;
    map['date'] = _date;
    map['popularity'] = _popularity;

    return map;
  }

  // Extract a Note object from a Map object
  Product.fromMapObject(Map<String, dynamic> map) {
    _productName = map['productName'];
    launchSite = map['launchSite'];
    _launchAt = map['launchAt'];
    _date = map['date'];
    _popularity = map['popularity'];
  }
}