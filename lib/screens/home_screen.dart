import 'package:coffee/widgets/app_bar_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/coffee_bloc/coffee_bloc.dart';
import '../blocs/coffee_bloc/coffee_event.dart';
import '../blocs/coffee_bloc/coffee_state.dart';
import '../blocs/favorite_coffee_bloc/favorite_coffee_bloc.dart';
import '../blocs/favorite_coffee_bloc/favorite_coffee_event.dart';
import '../models/coffee.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<CoffeeBloc>(context).add(LoadCoffee());
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
      title: const AppBarTitle(title: "Coffee"),
      actions: [
        _buildFavoriteIconButton(),
      ],
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: BlocBuilder<CoffeeBloc, CoffeeState>(
                bloc: BlocProvider.of<CoffeeBloc>(context),
                builder: (context, state) {
                  if (state is CoffeeLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is CoffeeLoaded) {
                    return CoffeeView(coffee: state.coffee);
                  } else {
                    return ErrorWithRefreshView(
                      onRefresh: _onNext,
                    );
                  }
                },
              ),
            ),
          ),
          OptionButtons(
            onNext: _onNext,
            onLike: _onLike,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteIconButton() {
    return IconButton(
      padding: const EdgeInsets.only(right: 16),
      onPressed: _openFavorites,
      iconSize: 30,
      icon: StreamBuilder(
        stream: BlocProvider.of<FavoriteCoffeeBloc>(context).length,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData && snapshot.data! > 0) {
            return Badge(
              label: Text(snapshot.data.toString()),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(
                  CupertinoIcons.heart_fill,
                  color: Colors.black,
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  void _openFavorites() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const FavoritesScreen(),
    ));
  }

  void _onLike() {
    if (BlocProvider.of<CoffeeBloc>(context).state is CoffeeLoaded) {
      BlocProvider.of<FavoriteCoffeeBloc>(context).add(
        AddFavoriteCoffee(
          (BlocProvider.of<CoffeeBloc>(context).state as CoffeeLoaded).coffee,
        ),
      );
      BlocProvider.of<CoffeeBloc>(context).add(LoadCoffee());
    }
  }

  void _onNext() {
    BlocProvider.of<CoffeeBloc>(context).add(LoadCoffee());
  }
}

class CoffeeView extends StatelessWidget {
  final Coffee coffee;

  const CoffeeView({super.key, required this.coffee});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 16,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.memory(coffee.bytes),
        ),
      ),
    );
  }
}

class OptionButtons extends StatelessWidget {
  final VoidCallback onLike;
  final VoidCallback onNext;

  const OptionButtons({super.key, required this.onLike, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LikeButton(onTap: onLike),
          const SizedBox(width: 16),
          Expanded(child: NextButton(onTap: onNext))
        ],
      ),
    );
  }
}

class LikeButton extends StatelessWidget {
  final VoidCallback onTap;

  const LikeButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Row(
          children: [
            Icon(
              CupertinoIcons.heart_fill,
              color: Colors.white,
            ),
            SizedBox(width: 20),
            Text(
              "Like",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  final VoidCallback onTap;

  const NextButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.black, width: 4),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Next",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 20),
            Icon(CupertinoIcons.arrow_right_circle_fill),
          ],
        ),
      ),
    );
  }
}

class ErrorWithRefreshView extends StatelessWidget {
  final VoidCallback onRefresh;

  const ErrorWithRefreshView({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 40,
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh),
        ),
        const Text("Failed to load a cup of coffee!"),
      ],
    );
  }
}
