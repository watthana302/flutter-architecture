import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core_libs/dependency_injection/get_it.dart';
import 'package:product/features/home/domain/entities/product.dart';
import 'package:product/features/home/domain/port/product/service.dart';
import 'package:product/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:product/features/home/presentation/widgets/home_jumbotron.dart';
import 'package:core_ui/widgets/compounds/loading/loading_indicator.dart';
import 'package:core_ui/widgets/compounds/navbar/home_nav.dart';
import 'package:product/features/home/presentation/widgets/catalog.dart';
import 'package:product/mocks/products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductHomePage extends ConsumerStatefulWidget {
  const ProductHomePage({super.key});

  @override
  ConsumerState<ProductHomePage> createState() => _ProductHomePageState();
}

class _ProductHomePageState extends ConsumerState<ProductHomePage> {

  @override
  void initState() {
    super.initState();
    Future((){
      ref.read(homeViewModelProvider.notifier).getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeVM = ref.watch(homeViewModelProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const HomeNavbar(),
              Expanded(
                  child: homeVM.loading
                      ? const Loading()
                      : ListView.builder(
                    itemCount: homeVM.categories.length,
                    itemBuilder: (context, index) {
                      return Column(
                        key: UniqueKey(),
                        children: [
                          HomeJumbotron(
                              imageUrl: categoryImages[homeVM.categories[index]]!,
                              title: homeVM.categories[index].toUpperCase(),
                              buttonTitle: 'View Collection'
                          ),
                          Catalog(
                            title: 'All products',
                            products: homeVM.products[index],
                          ),
                          const SizedBox(height: 24,)
                        ],
                      );},)
              )
            ],
          ),
        ),
    );
  }
}
