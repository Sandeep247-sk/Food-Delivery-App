import '../models/customization_option.dart';
import '../models/food_category.dart';
import '../models/menu_item.dart';
import '../models/review.dart';

class MockData {
  static const List<FoodCategory> categories = [
    FoodCategory(id: 'all', name: 'All Dishes', icon: '🍽️'),
    FoodCategory(id: 'biryani', name: 'Biryani', icon: '🍲'),
    FoodCategory(id: 'burgers', name: 'Burgers', icon: '🍔'),
    FoodCategory(id: 'pizza', name: 'Pizza', icon: '🍕'),
    FoodCategory(id: 'chinese', name: 'Chinese', icon: '🍜'),
    FoodCategory(id: 'north_indian', name: 'North Indian', icon: '🫓'),
    FoodCategory(id: 'salads', name: 'Salads', icon: '🥗'),
    FoodCategory(id: 'desserts', name: 'Cakes & Sweets', icon: '🍰'),
    FoodCategory(id: 'drinks', name: 'Beverages', icon: '🥤'),
  ];

  static final List<MenuItemModel> menuItems = [
    MenuItemModel(
      id: 'm1',
      name: 'Hyderabadi Dum Chicken Biryani',
      description:
          'Fragrant basmati rice dum cooked with marinated tender chicken pieces, saffron, and aromatic spices. Served with Mirchi Ka Salan and Raita.',
      price: 13.99,
      rating: 4.8,
      reviewCount: 1250,
      categoryId: 'biryani',
      imageUrl:
          'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=400&q=75',
      calories: 680,
      prepTime: '25-30 mins',
      distance: '1.8 km',
      isPopular: true,
      isVeg: false,
      restaurantName: 'Paradise Biryani House',
      offerTag: '60% OFF UP TO ₹120',
      ingredients: [
        'Basmati Rice',
        'Tender Chicken',
        'Saffron',
        'Indian Spices',
        'Caramelised Onions'
      ],
      sizes: const [
        FoodSizeOption(name: 'Half Portion (1 Person)', extraPrice: 0.0),
        FoodSizeOption(name: 'Full Portion (2 Persons)', extraPrice: 5.00),
      ],
      toppings: const [
        FoodToppingOption(id: 't_b1', name: 'Extra Boiled Egg', price: 0.99),
        FoodToppingOption(id: 't_b2', name: 'Extra Raita Cup', price: 0.75),
        FoodToppingOption(id: 't_b3', name: 'Extra Salan Gravy', price: 1.25),
      ],
      reviews: const [
        ReviewModel(
          id: 'r_b1',
          userName: 'Rahul Sharma',
          rating: 5.0,
          comment: 'Authentic Hyderabadi flavor! Rice was long grain and chicken super tender.',
          date: 'Today',
        ),
      ],
    ),
    MenuItemModel(
      id: 'm2',
      name: 'Truffle Angus Smash Burger',
      description:
          'Double smashed Angus beef patty, black truffle aioli, caramelised onions, and aged Swiss cheese on a toasted brioche bun.',
      price: 14.99,
      rating: 4.9,
      reviewCount: 320,
      categoryId: 'burgers',
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=400&q=75',
      calories: 780,
      prepTime: '15-20 mins',
      distance: '2.5 km',
      isPopular: true,
      isVeg: false,
      restaurantName: 'The Burger Club',
      offerTag: '50% OFF UP TO ₹100',
      ingredients: [
        'Angus Beef',
        'Truffle Aioli',
        'Swiss Cheese',
        'Brioche Bun',
        'Caramelised Onion'
      ],
      sizes: const [
        FoodSizeOption(name: 'Single Patty', extraPrice: 0.0),
        FoodSizeOption(name: 'Double Patty', extraPrice: 3.50),
        FoodSizeOption(name: 'Triple Monster', extraPrice: 6.00),
      ],
      toppings: const [
        FoodToppingOption(id: 't1', name: 'Extra Swiss Cheese', price: 1.50),
        FoodToppingOption(id: 't2', name: 'Crispy Bacon Strips', price: 2.00),
        FoodToppingOption(id: 't3', name: 'Fried Egg', price: 1.25),
      ],
      reviews: const [
        ReviewModel(
          id: 'r1',
          userName: 'Sarah Jenkins',
          rating: 5.0,
          comment: 'Best burger in town! The truffle aioli is incredible.',
          date: 'Yesterday',
        ),
      ],
    ),
    MenuItemModel(
      id: 'm3',
      name: 'Paneer Butter Masala & Naan',
      description:
          'Cottage cheese cubes simmered in a rich, buttery tomato cashew gravy with fenugreek. Served with 2 Garlic Butter Naans.',
      price: 12.50,
      rating: 4.7,
      reviewCount: 890,
      categoryId: 'north_indian',
      imageUrl:
          'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=400&q=75',
      calories: 620,
      prepTime: '20-25 mins',
      distance: '1.2 km',
      isPopular: true,
      isVeg: true,
      restaurantName: 'Punjabi Rasoi',
      offerTag: 'FLAT ₹125 OFF',
      ingredients: [
        'Fresh Paneer',
        'Butter Gravy',
        'Cashew Paste',
        'Kasuri Methi',
        'Garlic Naan'
      ],
      sizes: const [
        FoodSizeOption(name: 'Standard Meal', extraPrice: 0.0),
        FoodSizeOption(name: 'Jumbo Thali Combo', extraPrice: 4.00),
      ],
    ),
    MenuItemModel(
      id: 'm4',
      name: 'Artisan Wood-Fired Margherita',
      description:
          'Authentic sourdough crust topped with San Marzano tomato sauce, fresh buffalo mozzarella, olive oil, and fresh basil leaves.',
      price: 15.99,
      rating: 4.8,
      reviewCount: 450,
      categoryId: 'pizza',
      imageUrl:
          'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?auto=format&fit=crop&w=400&q=75',
      calories: 650,
      prepTime: '20 mins',
      distance: '3.1 km',
      isPopular: true,
      isVeg: true,
      restaurantName: 'Pizza Italia Oven',
      offerTag: 'BUY 1 GET 1 FREE',
      ingredients: [
        'Sourdough Dough',
        'San Marzano Tomatoes',
        'Buffalo Mozzarella',
        'Fresh Basil'
      ],
      sizes: const [
        FoodSizeOption(name: 'Medium 10"', extraPrice: 0.0),
        FoodSizeOption(name: 'Large 14"', extraPrice: 4.00),
      ],
    ),
    MenuItemModel(
      id: 'm5',
      name: 'Schezwan Hakka Noodles Supreme',
      description:
          'Wok-tossed noodles with crunchy vegetables, garlic, spring onions, and spicy Schezwan pepper sauce.',
      price: 11.20,
      rating: 4.6,
      reviewCount: 380,
      categoryId: 'chinese',
      imageUrl:
          'https://images.unsplash.com/photo-1585032226651-759b368d7246?auto=format&fit=crop&w=400&q=75',
      calories: 510,
      prepTime: '15 mins',
      distance: '2.0 km',
      isPopular: false,
      isVeg: true,
      restaurantName: 'Wok & Roll Chinese',
      offerTag: 'ITEMS AT ₹129',
      ingredients: [
        'Hakka Noodles',
        'Bell Peppers',
        'Schezwan Sauce',
        'Spring Onions'
      ],
    ),
    MenuItemModel(
      id: 'm6',
      name: 'Avocado Caesar Salad',
      description:
          'Crisp romaine lettuce, grilled chicken, sliced avocado, garlic croutons, shaved parmesan, and creamy Caesar dressing.',
      price: 12.99,
      rating: 4.6,
      reviewCount: 180,
      categoryId: 'salads',
      imageUrl:
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=400&q=75',
      calories: 420,
      prepTime: '10-15 mins',
      distance: '1.5 km',
      isPopular: false,
      isVeg: false,
      restaurantName: 'Green Bowl Organics',
      offerTag: '20% OFF WITH ONE',
    ),
    MenuItemModel(
      id: 'm7',
      name: 'Belgian Chocolate Lava Cake',
      description:
          'Warm molten chocolate cake served with vanilla bean gelato and fresh raspberry reduction.',
      price: 8.99,
      rating: 4.95,
      reviewCount: 640,
      categoryId: 'desserts',
      imageUrl:
          'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=400&q=75',
      calories: 510,
      prepTime: '10 mins',
      distance: '1.0 km',
      isPopular: true,
      isVeg: true,
      restaurantName: 'Sweet Tooth Patisserie',
      offerTag: 'FLAT 50% OFF',
    ),
    MenuItemModel(
      id: 'm8',
      name: 'Iced Dragonfruit Mango Smoothie',
      description:
          'Refreshing blend of fresh dragonfruit, mango puree, coconut water, and a splash of lime juice.',
      price: 5.99,
      rating: 4.8,
      reviewCount: 230,
      categoryId: 'drinks',
      imageUrl:
          'https://images.unsplash.com/photo-1553530666-ba11a7da3888?auto=format&fit=crop&w=400&q=75',
      calories: 190,
      prepTime: '5 mins',
      distance: '0.8 km',
      isPopular: false,
      isVeg: true,
      restaurantName: 'Juice Lounge Bar',
      offerTag: 'BUY 2 GET 1 FREE',
    ),
  ];

  static const List<Map<String, String>> promoBanners = [
    {
      'title': 'SWIGGY ONE DEAL',
      'subtitle': 'Free Delivery + Extra 15% OFF on top restaurants',
      'tag': 'SWIGGY ONE',
      'imageUrl':
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=75',
    },
    {
      'title': 'CRAZY DEALS • UP TO 60% OFF',
      'subtitle': 'Use code SWIGGY60 at checkout',
      'tag': 'GOURMET FEST',
      'imageUrl':
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=400&q=75',
    },
  ];

  static const List<Map<String, String>> swiggyServices = [
    {
      'title': 'Food',
      'subtitle': 'Free Delivery',
      'icon': '🍔',
      'color': '0xFFFFF3E0',
    },
    {
      'title': 'Instamart',
      'subtitle': 'Instant Grocery',
      'icon': '🛒',
      'color': '0xFFE8F5E9',
    },
    {
      'title': 'Dineout',
      'subtitle': 'Up to 50% Off',
      'icon': '🍽️',
      'color': '0xFFE1F5FE',
    },
    {
      'title': 'Genie',
      'subtitle': 'Pickup & Drop',
      'icon': '📦',
      'color': '0xFFF3E5F5',
    },
  ];
}
