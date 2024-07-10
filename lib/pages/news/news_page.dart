import 'package:flutter/material.dart';
import 'package:mc/pages/news/news_web_view.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<Article>> future;
  String? searchTerm;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  List<String> categoryItems = [
    "GENERAL",
    "BUSINESS",
    "ENTERTAINMENT",
    "HEALTH",
    "SCIENCE",
    "SPORTS",
    "TECHNOLOGY",
  ];

  late String selectedCategory;

  @override
  void initState() {
    selectedCategory = categoryItems[0];
    future = getNewsData();
    super.initState();
  }

  Future<List<Article>> getNewsData() async {
    NewsAPI newsAPI = NewsAPI(apiKey: "cdf85cbce16f4f498a9aec3a6ad22c0b");
    return await newsAPI.getTopHeadlines(
      country: "us",
      query: searchTerm,
      category: selectedCategory,
      pageSize: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearching ? searchAppBar() : appBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildCategories(),
            Expanded(
              child: FutureBuilder<List<Article>>(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error loading the news"));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return _buildNewsListView(snapshot.data!);
                  } else {
                    return const Center(child: Text("No news available"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar searchAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          setState(() {
            isSearching = false;
            searchTerm = null;
            searchController.text = "";
            future = getNewsData();
          });
        },
      ),
      title: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration: const InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.black54),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {
            setState(() {
              searchTerm = searchController.text;
              future = getNewsData();
            });
          },
        ),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text(
        "NEWS NOW",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {
            setState(() {
              isSearching = true;
            });
          },
        ),
      ],
    );
  }

  Widget _buildNewsListView(List<Article> articleList) {
    return ListView.builder(
      itemCount: articleList.length,
      itemBuilder: (context, index) {
        Article article = articleList[index];
        return _buildNewsItem(article);
      },
    );
  }

  Widget _buildNewsItem(Article article) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsWebView(url: article.url!),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                article.urlToImage ?? "",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 80);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.source.name!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.description ?? "",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categoryItems.map((category) {
            bool isSelected = category == selectedCategory;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = category;
                    future = getNewsData();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSelected ? const Color(0xFF42A5F5) : Colors.white,
                  foregroundColor:
                      isSelected ? Colors.white : const Color(0xFF42A5F5),
                  side: const BorderSide(
                    color: Color(0xFF42A5F5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : const Color(0xFF42A5F5),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
