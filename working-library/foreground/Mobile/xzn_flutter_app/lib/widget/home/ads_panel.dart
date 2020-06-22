import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xzn/conf/config.dart';
import 'package:xzn/models/ads.dart';
import 'package:xzn/page/web_view.dart';
import 'package:xzn/services/ads_service.dart';

class AdsCard extends StatelessWidget {
  AdsCard({this.ads, this.mini: false});
  bool mini;
  Ads ads;

  @override
  Widget build(BuildContext context) {
    Widget placeholder = Image.asset(
        "assets/image/default_picture.webp", //头像占位图，加载过程中显示
        fit: BoxFit.cover,
      );
    String imageUrl = Config.baseUrl()+"user/adpic/"+ads.picture;
    return Expanded(
      child: GestureDetector(
        child: CachedNetworkImage(
          height: mini?60:80,
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => placeholder,
          errorWidget: (context, url, error) => placeholder,
        ),
        onTap: () {
          if (ads.type == "url")
            Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                return WebView(url: ads.data);
              }));
        },
      )
//      Image.network(Config.baseUrl()+"user/adpic/"+ads.picture)
    );
  }
}

class AdsPanel extends StatefulWidget {
  @override
  _AdsPanelState createState() => _AdsPanelState();
}

class _AdsPanelState extends State<AdsPanel> {
  var _future;

  @override
  void initState() {
    _future = getAdsList("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        var widget;
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.hasError);
            widget = Icon(
              Icons.error,
              color: Colors.red,
              size: 48,
            );
          } else {
            print(snapshot.data[0].toJson());
              widget = Column(
                children: <Widget>[
//                  ...snapshot.data.map((cartItem) {
//                    return Text("C");
//                  }),
                  Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      AdsCard(ads: snapshot.data[0],),
                      AdsCard(ads: snapshot.data[1],)
                    ],
                  ),
//                  SizedBox(
//                    height: 30,
//                  ),
                  Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      AdsCard(ads: snapshot.data[2], mini: true,),
                      AdsCard(ads: snapshot.data[3], mini: true,),
                      AdsCard(ads: snapshot.data[4], mini: true,)
                    ],
                  ),
                ],
              );
          }
        } else {
          widget = Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 200,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ));
        }
        return widget;
      },
    );
  }
}