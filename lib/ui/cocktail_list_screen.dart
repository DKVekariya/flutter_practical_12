import 'package:flutter/material.dart';
import '../data/service/api_service.dart';

class CocktailListScreen extends StatefulWidget {
  const CocktailListScreen({super.key});

  @override
  State<CocktailListScreen> createState() => _CocktailListScreenState();
}

class _CocktailListScreenState extends State<CocktailListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _cocktails = [];
  bool _isLoading = false;

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
    _fetchCocktails('');
  }

  Future<void> _fetchCocktails(String query) async {
    setState(() {
      _isLoading = true;
    });

    List<dynamic> cocktails = await _apiService.fetchCocktails(query);

    setState(() {
      _cocktails = cocktails;
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _fetchCocktails(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drinks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search mocktails...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[400]),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged();
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                _onSearchChanged();
              },
            ),
            SizedBox(height: 16),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _cocktails.isEmpty
                ? Center(child: Text('No cocktails found'))
                : Expanded(
              child: ListView.builder(
                itemCount: _cocktails.length,
                itemBuilder: (context, index) {
                  var cocktail = _cocktails[index];
                  return Card(
                    child: SizedBox(
                      height: 120, // Fixed height for consistent look
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.0),
                              child: cocktail['strDrinkThumb'] != null
                                  ? Image.network(
                                cocktail['strDrinkThumb'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                                  : Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                child: Icon(Icons.no_drinks, size: 40),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    cocktail['strDrink'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    cocktail['strInstructions'] ?? 'No instructions available',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
