// news page
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/news_model.dart';
import 'package:flutter_application_1/services/api_service.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final ApiService apiService = ApiService();
  bool isLoading = false;
  List<NewsModel> newsList = [];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() => isLoading = true);
    try {
      final news = await apiService.fetchNews();
      if (mounted) {
        setState(() {
          newsList = news;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('News'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16.0),
                  Text('Haberler yükleniyor...'),
                ],
              ),
            )
          : newsList.isEmpty
              ? const Center(
                  child: Text(
                    'Haber bulunamadı',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: newsList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                  itemBuilder: (context, index) {
                    final news = newsList[index];
                    return Card(
                      elevation: 6,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ((news.image ?? '').trim().isNotEmpty)
                                ? Image.network(
                                    news.image!,
                                    webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      debugPrint('Image load failed: ${news.image} | $error');
                                      return Container(
                                        color: Colors.blueGrey.shade100,
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 48,
                                          color: Colors.blueGrey,
                                        ),
                                      );
                                    },
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Container(
                                        color: Colors.blueGrey.shade50,
                                        alignment: Alignment.center,
                                        child: const CircularProgressIndicator(),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.blueGrey.shade100,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.newspaper,
                                      size: 48,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _CategoryChip(label: news.category ?? ''),
                                    _MetaChip(label: news.author ?? ''),
                                  ],
                                ),
                                const SizedBox(height: 12.0),
                                Text(
                                  news.title?.isNotEmpty == true ? news.title! : 'Başlık yok',
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  news.summary?.isNotEmpty == true ? news.summary! : 'Özet bulunamadı',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    height: 1.4,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 12.0),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      news.publishedAt?.isNotEmpty == true ? news.publishedAt! : '',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;

  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label.isNotEmpty ? label : 'Kategori'),
      backgroundColor: Colors.blue.shade50,
      labelStyle: TextStyle(
        color: Colors.blue.shade800,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(color: Colors.blue.shade100),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;

  const _MetaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.person, size: 18),
      label: Text(label.isNotEmpty ? label : 'Yazar'),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.grey.shade300),
    );
  }
}