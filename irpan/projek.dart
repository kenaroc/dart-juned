import 'dart:io';
import 'package:csv/csv.dart';
void main() {
  File stock = File('stock.csv');
  String csv = stock.readAsStringSync();
  List<List<dynamic>> products = CsvToListConverter().convert(csv);
  bool next = true;

  do {
    printMenu();

    stdout.write("Pilih opsi (1/2/3/4/5): ");
    String choice = stdin.readLineSync()!;

    if (choice == '1') {
      addProduct(products);
    } else if (choice == '2') {
      viewStock(products);
    } else if (choice == '3') {
      addStock(products);
    } else if (choice == '4') {
      reduceStock(products);
    } else if (choice == '5') {
      break;
    } else {
      print("Opsi tidak valid. Silakan pilih 1, 2, 3, 4, atau 5.");
    }

    try {
      String stockCsv = const ListToCsvConverter().convert(products);
      stock.writeAsStringSync(stockCsv);
    } catch (err) {
      print(err);
    }

    stdout.write("Kembali ke menu? (Y/N): ");
    String? answer = stdin.readLineSync();
    if (answer == 'N' || answer == 'n') {
      next = false;
    }
  } while (next);
}

void printMenu() {
  print("+---------------------+");
  print("|  1. Tambah produk   |");
  print("|  2. Lihat Stock     |");
  print("|  3. Tambah Stock    |");
  print("|  4. Kurangi Stock   |");
  print("|  5. Keluar          |");
  print("+---------------------+");
}

void addProduct(List<List<dynamic>> products) {
  stdout.write("Masukkan nama produk: ");
  String productName = stdin.readLineSync()!;
  products.add([productName, 0, ""]);

  stdout.write("Masukkan jumlah stok: ");
  int productStock = int.parse(stdin.readLineSync()!);
  products.last[1] = productStock;

  if (productStock <= 10) {
    products.last[2] = "ringan";
    print('ringan');
  } else if (productStock >= 10) {
    products.last[2] = "berat";
    print('berat');
  } else {
    print("error");
  }

  print("Produk berhasil ditambahkan ke stok.");
}

void viewStock(List<List<dynamic>> products) {
  if (products.isEmpty) {
    print("Stok kosong.");
  } else {
    print("\nStok Pabrik:");
    for (int i = 0; i < products.length; i++) {
      print("${i + 1}. ${products[i][0]} - Stok: ${products[i][1]}, ${products[i][2]}"
          "\n ==========================================");
    }
  }
}

void addStock(List<List<dynamic>> products) {
  try {
    if (products.isEmpty) {
      throw Exception("Stok kosong. Tambahkan produk terlebih dahulu.");
    } else {
      viewStock(products);

      stdout.write("Pilih nomor produk yang akan ditambahkan stok: ");
      int selectedProductIndex = int.parse(stdin.readLineSync()!) - 1;

      if (selectedProductIndex < 0 || selectedProductIndex >= products.length) {
        throw Exception("Nomor produk tidak valid.");
      }

      stdout.write("Masukkan jumlah stok tambahan: ");
      int additionalStock = int.parse(stdin.readLineSync()!);

      if (additionalStock < 0) {
        throw Exception("Jumlah stok tambahan tidak valid.");
      }

      products[selectedProductIndex][1] += additionalStock;

      print(
          "Stok produk ${products[selectedProductIndex][0]} berhasil ditambahkan sebanyak $additionalStock. Stok sekarang: ${products[selectedProductIndex][1]}");
    }
  } catch (e) {
    print("Error: $e");
  }
}

void reduceStock(List<List<dynamic>> products) {
  try {
    if (products.isEmpty) {
      throw Exception("Stok kosong. Tambahkan produk terlebih dahulu.");
    } else {
      viewStock(products);

      stdout.write("Pilih nomor produk yang akan dikurangi: ");
      int selectedProductIndex = int.parse(stdin.readLineSync()!) - 1;

      if (selectedProductIndex < 0 || selectedProductIndex >= products.length) {
        throw Exception("Nomor produk tidak valid.");
      }

      stdout.write("Masukkan jumlah stok yang dikurangi: ");
      int reducedStock = int.parse(stdin.readLineSync()!);

      if (reducedStock < 0 || reducedStock > products[selectedProductIndex][1]) {
        throw Exception("Jumlah stok yang dikurangi tidak valid.");
      }

      products[selectedProductIndex][1] -= reducedStock;

      print(
          "Stok produk ${products[selectedProductIndex][0]} berhasil dikurangi sebanyak $reducedStock. Stok sekarang: ${products[selectedProductIndex][1]}");
    }
  } catch (e) {
    print("Error: $e");
  }
}
