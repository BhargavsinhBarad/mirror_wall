import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class google extends StatefulWidget {
  const google({super.key});

  @override
  State<google> createState() => _googleState();
}

class _googleState extends State<google> {
  String? searchString;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> bookmark = [];
  String link = "https://www.google.com/";
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
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
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
                    );
                  },
                );
              } else if ("search" == value) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("Search Engine"),
                    content: Container(
                      height: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RadioListTile(
                            title: Text("Google"),
                            value: "https://www.google.com/",
                            groupValue: link,
                            onChanged: (val) {
                              setState(() {
                                link = val!;
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
                                  link = val!;
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
                                  link = val!;
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
                                  link = val!;
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: TextFormField(
                        onSaved: (val) {
                          searchString = val;
                        },
                        controller: search,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          hintText: "Search on Google...",
                          suffixIcon: IconButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                inAppWebViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                    url: Uri.parse(
                                        "https://www.google.com/search?q=${searchString}"),
                                  ),
                                );
                                search.clear();
                              }
                            },
                            icon: Icon(Icons.send),
                          ),
                        ),
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
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (inAppWebViewController?.canGoForward() != null) {
                            inAppWebViewController!.goForward();
                          }
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          bookmark.add("${link}search?q=${searchString}");
                        },
                        icon: Icon(
                          Icons.bookmark,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (inAppWebViewController?.canGoBack() != null) {
                            inAppWebViewController!.goBack();
                          }
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 30,
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
                          size: 35,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
