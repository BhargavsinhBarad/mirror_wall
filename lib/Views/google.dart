import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class google extends StatefulWidget {
  const google({super.key});

  @override
  State<google> createState() => _googleState();
}

class _googleState extends State<google> {
  List<String> bookmark = [];
  dynamic link = "https://www.google.com/";
  TextEditingController search = TextEditingController();
  InAppWebViewController? inAppWebViewController;
  GlobalKey<ScaffoldState> scaffolfkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffolfkey,
      appBar: AppBar(
        title: Text("My Browser"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if ("book" == value) {
                scaffolfkey.currentState!.showBottomSheet(
                  (context) => Container(
                    height: 400,
                    width: double.infinity,
                    child: Column(
                      children: bookmark
                          .map((e) => Center(
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(e),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              bookmark.remove(e);
                                            });
                                          },
                                          icon: Icon(
                                              Icons.highlight_remove_sharp))
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                );
              } else if ("search" == value) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("Search Engine"),
                    content: Column(
                      children: [
                        RadioListTile(
                          title: Text("Google"),
                          value: "https://www.google.com/",
                          groupValue: link,
                          onChanged: (val) {
                            setState(() {
                              link = val;
                            });
                            inAppWebViewController!.loadUrl(
                              urlRequest: URLRequest(
                                url: Uri.tryParse(link),
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                        RadioListTile(
                            title: Text("Yahoo"),
                            value: "https://www.yahoo.com/",
                            groupValue: link,
                            onChanged: (val) {
                              setState(() {
                                link = val;
                              });
                              inAppWebViewController!.loadUrl(
                                urlRequest: URLRequest(
                                  url: Uri.tryParse(link),
                                ),
                              );
                              Navigator.of(context).pop();
                            }),
                        RadioListTile(
                            title: Text("Bing"),
                            value: "https://www.bing.com/",
                            groupValue: link,
                            onChanged: (val) {
                              setState(() {
                                link = val;
                              });
                              inAppWebViewController!.loadUrl(
                                urlRequest: URLRequest(
                                  url: Uri.tryParse(link),
                                ),
                              );
                              Navigator.of(context).pop();
                            }),
                        RadioListTile(
                            title: Text("Duck Duck Go"),
                            value: "https://www.duckduckgo.com/",
                            groupValue: link,
                            onChanged: (val) {
                              setState(() {
                                link = val;
                              });
                              inAppWebViewController!.loadUrl(
                                urlRequest: URLRequest(
                                  url: Uri.tryParse(link),
                                ),
                              );
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: "book",
                  child: Row(
                    children: [
                      Icon(Icons.bookmark, color: Colors.black),
                      Text("All Bookmarks"),
                    ],
                  )),
              PopupMenuItem(
                  value: "search",
                  child: Row(
                    children: [
                      Icon(
                        Icons.screen_search_desktop_outlined,
                        color: Colors.black,
                      ),
                      Text("Search Engine"),
                    ],
                  ))
            ],
          )
        ],
      ),
      body: Column(children: [
        Expanded(
          flex: 7,
          child: StreamBuilder(
            stream: Connectivity().onConnectivityChanged,
            builder: (BuildContext context,
                AsyncSnapshot<ConnectivityResult> snapshot) {
              return (snapshot.data == ConnectivityResult.mobile ||
                      snapshot.data == ConnectivityResult.wifi)
                  ? InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: Uri.parse("https://www.google.com/"),
                      ),
                      onLoadStart: (controller, url) {
                        setState(() {
                          inAppWebViewController = controller;
                        });
                      },
                    )
                  : Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("lib/Assets/image.jpg"),
                        ),
                      ),
                    );
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: search,
                  decoration: InputDecoration(
                    hintText: "Search on Google...",
                    suffixIcon: IconButton(
                      onPressed: () {
                        inAppWebViewController?.loadUrl(
                          urlRequest: URLRequest(
                            url: Uri.parse(
                                "https://www.google.com/search?q=${search.text}"),
                          ),
                        );
                      },
                      icon: Icon(Icons.send),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        inAppWebViewController!.loadUrl(
                          urlRequest: URLRequest(
                            url: Uri.parse("https://www.google.com/"),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.home_filled,
                        size: 45,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (inAppWebViewController?.canGoForward() != null) {
                          inAppWebViewController!.goForward();
                        }
                      },
                      icon: Icon(
                        Icons.arrow_right,
                        size: 65,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        bookmark.add("${link}search?q=${search.text}");
                      },
                      icon: Icon(
                        Icons.bookmark,
                        size: 45,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (inAppWebViewController?.canGoBack() != null) {
                          inAppWebViewController!.goBack();
                        }
                      },
                      icon: Icon(
                        Icons.arrow_left_outlined,
                        size: 65,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        inAppWebViewController!.loadUrl(
                          urlRequest: URLRequest(
                            url: Uri.parse("https://www.google.com/"),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.refresh,
                        size: 45,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
