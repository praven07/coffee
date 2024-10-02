import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/favorite_coffee_bloc/favorite_coffee_bloc.dart';
import '../blocs/favorite_coffee_bloc/favorite_coffee_event.dart';
import '../blocs/favorite_coffee_bloc/favorite_coffee_state.dart';
import '../models/coffee.dart';
import '../widgets/app_bar_title.dart';


class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<FavoriteCoffeeBloc>(context).add(LoadFavoriteCoffees());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const AppBarTitle(title: "Favorites"),
    );
  }

  Widget _buildBody() {

    return BlocBuilder<FavoriteCoffeeBloc, FavoriteCoffeeState>(
      builder: (context, state) {
        if (state is FavoriteCoffeesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FavoriteCoffeesLoaded) {
          return ImageGridView(coffees: state.coffees);
        }

        return const EmptyView();
      },
    );
  }
}

class ImageGridView extends StatelessWidget {
  final List<Coffee> coffees;

  const ImageGridView({super.key, required this.coffees});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: coffees.length,
      itemBuilder: (context, index) {

        Coffee coffee = coffees[index];

        return GestureDetector(
          onTap: () => _navigateToImageViewer(context, coffee),
          child: Hero(
            tag: coffee,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.memory(
                coffee.bytes,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
    );
  }

  void _navigateToImageViewer(BuildContext context, Coffee coffee) {
    Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return HeroImageViewer(coffee: coffee);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        )
    );
  }
}


class HeroImageViewer extends StatelessWidget {

  final Coffee coffee;

  const HeroImageViewer({super.key, required this.coffee});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: GestureDetector(
          onVerticalDragStart: (details) {
            Navigator.of(context).pop();
          },
          child: Center(
            child: Hero(
              tag: coffee,
              child: Image.memory(coffee.bytes, fit: BoxFit.cover,),
            ),
          ),
        ),
      ),
    );
  }
}


class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty, size: 50),
          SizedBox(height: 16),
          Text("You have no favorites"),
        ],
      ),
    );
  }
}



