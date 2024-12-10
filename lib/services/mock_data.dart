// lib/services/mock_data.dart

import '../models/food_item.dart';

// Generate food items based on the given file names
List<FoodItem> mockFoodItems = [
  FoodItem(
    id: '1',
    name: 'Beef Biryani',
    price: 13.99,
    image:
        'https://drive.google.com/uc?export=view&id=1vCellU3WiG-qG43QYw65rInxrhAgpRcy',
    category: 'Biryani',
    isNewDeal: true,
    isTopSelling: true,
    brand: 'Karachi Darbar',
    description:
        'Aromatic beef biryani with flavorful spices, served with raita.',
  ),
  FoodItem(
    id: '2',
    name: 'Chicken Biryani',
    price: 12.50,
    image:
        'https://drive.google.com/uc?export=view&id=1UJCrSWidKAcKs11siTgcgL7VCe3yPN97',
    category: 'Biryani',
    isNewDeal: false,
    isTopSelling: true,
    brand: 'Karachi Darbar',
    description:
        'Delicious chicken biryani with tender chicken pieces and fragrant rice.',
  ),
  FoodItem(
    id: '3',
    name: 'Classic Burger',
    price: 8.99,
    image:
        'https://drive.google.com/uc?export=view&id=1S5gURMBpTkXDTD7KJmr1SAqVypvpC9FK',
    category: 'Burger',
    isNewDeal: true,
    isTopSelling: false,
    brand: 'Burger King',
    description: 'Juicy beef burger topped with lettuce, tomato, and cheese.',
  ),
  FoodItem(
    id: '4',
    name: 'Chocolate Cake',
    price: 6.99,
    image:
        'https://drive.google.com/uc?export=view&id=10pRVVfKV3YC6j2kqaqmEFFbzFv-22uyn',
    category: 'Cake',
    isNewDeal: false,
    isTopSelling: true,
    brand: 'KababJees Bakers',
    description: 'Rich chocolate cake with creamy chocolate frosting.',
  ),
  FoodItem(
    id: '5',
    name: 'Chocolate Donut',
    price: 3.50,
    image:
        'https://drive.google.com/uc?export=view&id=1OjOc5607qwfn-YxNgoahzqGsAPEBdLno',
    category: 'Donut',
    isNewDeal: true,
    isTopSelling: false,
    brand: 'Dunkin\' Donuts',
    description: 'Soft donut with a rich chocolate glaze.',
  ),
  FoodItem(
    id: '6',
    name: 'Club Sandwich',
    price: 7.99,
    image:
        'https://drive.google.com/uc?export=view&id=1d6hp666Ha1MCM-FUwHBd6M6GKkexY7PA',
    category: 'Sandwich',
    isNewDeal: false,
    isTopSelling: true,
    brand: 'KFC',
    description:
        'Grilled club sandwich filled with chicken, bacon, and veggies.',
  ),
  FoodItem(
    id: '7',
    name: 'Hot Coffee',
    price: 4.50,
    image:
        'https://drive.google.com/uc?export=view&id=1BGX_TU5-xXv4M3g37KAipku_P36LGplv',
    category: 'Coffee',
    isNewDeal: true,
    isTopSelling: true,
    brand: 'Starbucks',
    description: 'Freshly brewed coffee with a rich, robust flavor.',
  ),
  FoodItem(
    id: '8',
    name: 'Fried Chicken',
    price: 9.99,
    image:
        'https://drive.google.com/uc?export=view&id=17xAM3yzzNsxFXw7EZHeotKaf4ux6qVAx',
    category: 'Fast Food',
    isNewDeal: false,
    isTopSelling: true,
    brand: 'KFC',
    description: 'Crispy fried chicken served with a side of fries.',
  ),
  FoodItem(
    id: '9',
    name: 'Pepperoni Pizza',
    price: 12.99,
    image:
        'https://drive.google.com/uc?export=view&id=1s11GtwIKH3q2MgLqEzwaudWjEL532Xim',
    category: 'Pizza',
    isNewDeal: true,
    isTopSelling: true,
    brand: 'Domino\'s',
    description: 'Pepperoni pizza with melted cheese and crispy crust.',
  ),
  FoodItem(
    id: '10',
    name: 'Brulee Latte',
    price: 5.50,
    image:
        'https://drive.google.com/uc?export=view&id=14Q2IM8V7SyCshzXMcRPuzjMnW3fbI8JV',
    category: 'Coffee',
    isNewDeal: true,
    isTopSelling: false,
    brand: 'Starbucks',
    description: 'Smooth latte with a caramel brulee twist.',
  ),
  FoodItem(
    id: '11',
    name: 'Chai Tea',
    price: 4.99,
    image:
        'https://drive.google.com/uc?export=view&id=1q93NZwJEdCGsFYxLASCd7AfVeaNIYlLr',
    category: 'Coffee',
    isNewDeal: false,
    isTopSelling: true,
    brand: 'Starbucks',
    description: 'Spiced chai tea served hot with steamed milk.',
  ),
  FoodItem(
    id: '12',
    name: 'Pineapple Cake',
    price: 7.99,
    image:
        'https://drive.google.com/uc?export=view&id=1MCbpNvqVbrkUTVIFZ6s8ioXVb8QWTSZU',
    category: 'Cake',
    isNewDeal: true,
    isTopSelling: false,
    brand: 'KababJees Bakers',
    description: 'Moist pineapple cake topped with creamy frosting.',
  ),
  FoodItem(
    id: '13',
    name: 'Beef Burger',
    price: 9.50,
    image:
        'https://drive.google.com/uc?export=view&id=1noScSdwyNVdRRh4QwArZOMVVbjCUwpAq',
    category: 'Burger',
    isNewDeal: false,
    isTopSelling: true,
    brand: 'Burger King',
    description: 'Thick beef patty with cheese, lettuce, and special sauce.',
  ),
  FoodItem(
    id: '14',
    name: 'Fruit Salad',
    price: 6.50,
    image:
        'https://drive.google.com/uc?export=view&id=1sHRusU1s7VeBNnoZGdpJkWSCwMSp5kcw',
    category: 'Salad',
    isNewDeal: true,
    isTopSelling: false,
    brand: 'FreshCo',
    description: 'Freshly chopped mixed fruits served with a honey drizzle.',
  ),
  FoodItem(
    id: '15',
    name: 'Assorted Donuts',
    price: 11.99,
    image:
        'https://drive.google.com/uc?export=view&id=19MkIAFun1UAn5mOYWkEVmw2UVS3dfIgB',
    category: 'Donut',
    isNewDeal: true,
    isTopSelling: true,
    brand: 'Dunkin\' Donuts',
    description: 'A variety of glazed, chocolate, and filled donuts.',
  ),
  FoodItem(
    id: '16',
    name: 'Salad',
    price: 11.99,
    image:
        'https://drive.google.com/uc?export=view&id=1YMk7kPCV3JA5Rug98wR4PhUAMegIHh2P',
    category: 'Salad',
    isNewDeal: false,
    isTopSelling: true,
    brand: 'FreshCo',
    description: 'Freshly chopped mixed fruits served with a honey drizzle.',
  ),
  FoodItem(
    id: '17',
    name: 'Fried Chicken',
    price: 12.05,
    image:
        'https://drive.google.com/uc?export=view&id=16fCifUPHP5mdIieYBVzJwMHuLMTZa4tw',
    category: 'Fast Food',
    isNewDeal: true,
    isTopSelling: false,
    brand: 'KFC',
    description: 'Crispy fried chicken served with a side of fries.',
  ),
];
