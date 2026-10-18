import 'package:flutter/foundation.dart';
import '../data/models/service_model.dart';

class ServicesProvider extends ChangeNotifier {
  List<ServiceModel> _services = [];
  List<ServiceModel> _filteredServices = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isLoading = false;

  // ─── Categories ───────────────────────────────────────
  static const List<Map<String, dynamic>> categories = [
    {'label': 'All', 'icon': '🏠', 'color': 0xFF3FE56C},
    {'label': 'Cleaning', 'icon': '🧹', 'color': 0xFF64B5F6},
    {'label': 'Recycling', 'icon': '♻️', 'color': 0xFF4CAF50},
    {'label': 'Garden', 'icon': '🌱', 'color': 0xFF81C784},
    {'label': 'Solar', 'icon': '☀️', 'color': 0xFFFFB74D},
    {'label': 'Water', 'icon': '💧', 'color': 0xFF42A5F5},
    {'label': 'Waste', 'icon': '🗑️', 'color': 0xFFFF8A65},
    {'label': 'Security', 'icon': '🔒', 'color': 0xFFAB47BC},
  ];

  // ─── Getters ──────────────────────────────────────────
  List<ServiceModel> get services => _filteredServices;
  List<ServiceModel> get allServices => List.unmodifiable(_services);
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  int get serviceCount => _filteredServices.length;

  List<ServiceModel> get popularServices =>
      _services.where((s) => s.rating >= 4.7).toList();

  List<ServiceModel> get availableNowServices =>
      _services.where((s) => s.isAvailableNow).toList();

  ServicesProvider() {
    _initServices();
  }

  void _initServices() {
    _isLoading = true;

    _services = [
      ServiceModel(
        id: '1',
        title: 'Eco Home\nCleaning',
        emoji: '🧹',
        image: 'assets/images/eco_cleaning.png',
        basePrice: 299,
        rating: 4.8,
        duration: '2-3 hours',
        category: 'Cleaning',
        tags: ['Popular', 'Eco'],
        ecoScore: 92,
        ecoImpact: ['Non-toxic products', 'Reusable supplies'],
        requiresImage: true,
        suggestion: 'Photos help us estimate the cleaning scope accurately',
        options: const [
          ServiceOptionModel(label: '1 BHK', price: 299),
          ServiceOptionModel(label: '2 BHK', price: 499),
          ServiceOptionModel(label: '3 BHK', price: 699),
          ServiceOptionModel(label: '4+ BHK', price: 999),
        ],
        isAvailableNow: true,
      ),
      ServiceModel(
        id: '2',
        title: 'Garbage\nCollection',
        emoji: '🗑️',
        image: 'assets/images/garbage_collection.png',
        basePrice: 49,
        rating: 4.6,
        duration: '30-45 min',
        category: 'Waste',
        tags: ['Daily', 'Essential'],
        ecoScore: 85,
        ecoImpact: ['Segregated waste', 'Composting'],
        options: const [
          ServiceOptionModel(label: 'One-time', price: 49),
          ServiceOptionModel(label: '1 Week', price: 149),
          ServiceOptionModel(label: '1 Month', price: 499),
        ],
        isAvailableNow: true,
      ),
      ServiceModel(
        id: '3',
        title: 'Recycling\nPickup',
        emoji: '♻️',
        image: 'assets/images/recycling_pickup.png',
        basePrice: 0,
        rating: 4.9,
        duration: '1-2 hours',
        category: 'Recycling',
        tags: ['Free', 'Eco Hero'],
        ecoScore: 98,
        ecoImpact: ['Reduces landfill', 'Earns eco-points'],
        options: const [
          ServiceOptionModel(label: 'Paper & Cardboard', price: 0),
          ServiceOptionModel(label: 'Plastic & Metal', price: 0),
          ServiceOptionModel(label: 'Electronics', price: 49),
          ServiceOptionModel(label: 'Mixed', price: 0),
        ],
        isAvailableNow: true,
      ),
      ServiceModel(
        id: '4',
        title: 'Solar Panel\nCleaning',
        emoji: '☀️',
        image: 'assets/images/solar_cleaning.png',
        basePrice: 599,
        rating: 4.7,
        duration: '1-2 hours',
        category: 'Solar',
        tags: ['Premium', 'Specialized'],
        ecoScore: 95,
        ecoImpact: ['+20% efficiency', 'Clean energy boost'],
        requiresImage: true,
        suggestion: 'Share a photo of your solar setup for accurate pricing',
        options: const [
          ServiceOptionModel(label: 'Up to 5 Panels', price: 599),
          ServiceOptionModel(label: '6-10 Panels', price: 999),
          ServiceOptionModel(label: '11-20 Panels', price: 1499),
          ServiceOptionModel(label: '20+ Panels', price: 1999),
        ],
        isAvailableNow: true,
      ),
      ServiceModel(
        id: '5',
        title: 'Deep Clean\nPro',
        emoji: '✨',
        image: 'assets/images/deep_clean.png',
        basePrice: 899,
        rating: 4.9,
        duration: '4-6 hours',
        category: 'Cleaning',
        tags: ['Premium', '⭐ Top Rated'],
        ecoScore: 90,
        ecoImpact: ['Enzyme-based cleaners', 'Zero harsh chemicals'],
        requiresImage: true,
        options: const [
          ServiceOptionModel(label: '1 BHK', price: 899),
          ServiceOptionModel(label: '2 BHK', price: 1299),
          ServiceOptionModel(label: '3 BHK', price: 1799),
          ServiceOptionModel(label: 'Villa', price: 2499),
        ],
        isAvailableNow: false,
        nextAvailableSlot: '3:00 PM',
      ),
      ServiceModel(
        id: '6',
        title: 'Water Tank\nCleaning',
        emoji: '💧',
        image: 'assets/images/water_tank.png',
        basePrice: 699,
        rating: 4.5,
        duration: '2-3 hours',
        category: 'Water',
        tags: ['Health', 'Essential'],
        ecoScore: 88,
        ecoImpact: ['Clean water', 'Eco-safe chemicals'],
        options: const [
          ServiceOptionModel(label: '500L Tank', price: 699),
          ServiceOptionModel(label: '1000L Tank', price: 999),
          ServiceOptionModel(label: '2000L Tank', price: 1499),
        ],
        isAvailableNow: true,
      ),
      ServiceModel(
        id: '7',
        title: 'Garden\nCare',
        emoji: '🪴',
        image: 'assets/images/garden_care.png',
        basePrice: 399,
        rating: 4.8,
        duration: '2-4 hours',
        category: 'Garden',
        tags: ['Popular', 'Relaxing'],
        ecoScore: 96,
        ecoImpact: ['Organic fertilizers', 'Native plants'],
        options: const [
          ServiceOptionModel(label: 'Basic (< 500 sq ft)', price: 399),
          ServiceOptionModel(label: 'Medium (500-1000 sq ft)', price: 699),
          ServiceOptionModel(label: 'Large (1000+ sq ft)', price: 1199),
          ServiceOptionModel(label: 'Terrace Garden', price: 499),
        ],
        isAvailableNow: true,
      ),
      ServiceModel(
        id: '8',
        title: 'Smart\nCompost',
        emoji: '🌱',
        image: 'assets/images/smart_compost.png',
        basePrice: 199,
        rating: 4.7,
        duration: '1 hour setup',
        category: 'Recycling',
        tags: ['Start-up Kit', 'Eco Hero'],
        ecoScore: 99,
        ecoImpact: ['Zero waste', 'Rich soil for garden'],
        options: const [
          ServiceOptionModel(label: 'Starter Kit', price: 199),
          ServiceOptionModel(label: 'Family Kit', price: 399),
          ServiceOptionModel(label: 'Community Kit', price: 999),
        ],
        isAvailableNow: true,
      ),
      ServiceModel(
        id: '9',
        title: 'Bulk Waste\nRemoval',
        emoji: '🚛',
        image: 'assets/images/bulk_waste.png',
        basePrice: 999,
        rating: 4.4,
        duration: '3-5 hours',
        category: 'Waste',
        tags: ['Heavy', 'One-time'],
        ecoScore: 78,
        ecoImpact: ['Responsible disposal', 'Max recycling'],
        requiresImage: true,
        suggestion: 'Send photos so we can assign the right vehicle',
        options: const [
          ServiceOptionModel(label: 'Small Load (< 200 kg)', price: 999),
          ServiceOptionModel(label: 'Medium Load (200-500 kg)', price: 1999),
          ServiceOptionModel(label: 'Large Load (500+ kg)', price: 3499),
        ],
        isAvailableNow: false,
        nextAvailableSlot: 'Tomorrow 9 AM',
      ),
      ServiceModel(
        id: '10',
        title: 'Air Purifier\nService',
        emoji: '🌬️',
        image: 'assets/images/air_purifier.png',
        basePrice: 349,
        rating: 4.6,
        duration: '1-2 hours',
        category: 'Cleaning',
        tags: ['Health', 'Indoor'],
        ecoScore: 87,
        ecoImpact: ['Better air quality', 'Filter recycling'],
        options: const [
          ServiceOptionModel(label: 'Filter Replacement', price: 349),
          ServiceOptionModel(label: 'Full Service', price: 699),
          ServiceOptionModel(label: 'Deep Clean + Filter', price: 999),
        ],
        isAvailableNow: true,
      ),
      ServiceModel(
        id: '11',
        title: 'Home\nGuard',
        emoji: '🔒',
        image: 'assets/images/homeguard.png',
        basePrice: 1499,
        rating: 4.9,
        duration: '4-6 hours',
        category: 'Security',
        tags: ['Premium', 'Smart Home'],
        ecoScore: 82,
        ecoImpact: ['Energy-efficient sensors', 'Solar-powered options'],
        options: const [
          ServiceOptionModel(label: '1 BHK', price: 1499),
          ServiceOptionModel(label: '2 BHK', price: 2499),
          ServiceOptionModel(label: '3 BHK', price: 3499),
          ServiceOptionModel(label: 'Villa', price: 4999),
        ],
        isAvailableNow: true,
      ),
    ];

    _filteredServices = List.from(_services);
    _isLoading = false;
  }

  // ─── Search & Filter ─────────────────────────────────
  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredServices = _services.where((s) {
      final matchesSearch = _searchQuery.isEmpty ||
          s.displayTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()));
      final matchesCategory =
          _selectedCategory == 'All' || s.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  ServiceModel? getServiceById(String id) {
    try {
      return _services.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  List<ServiceModel> getServicesByCategory(String category) {
    return _services.where((s) => s.category == category).toList();
  }
}
