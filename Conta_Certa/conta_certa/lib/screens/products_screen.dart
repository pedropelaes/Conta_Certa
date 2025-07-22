import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsState extends ChangeNotifier{
  
}

class ProductsScreen extends StatefulWidget{
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    
    return Consumer<ProductsState>(
      builder: (context, productsState, _){
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index){
              
            }
          ) 
        );
      }
    );
  }
}