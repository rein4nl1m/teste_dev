import 'package:flutter/material.dart';
import 'package:news_app/core/blocs/news_bloc.dart';
import 'package:news_app/core/routes/app_routes.dart';
import 'package:news_app/data/model/news_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NewsBloc newsBloc;

  void searchWithKeyword() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pesquisar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Autocomplete<NewsModel>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<NewsModel>.empty();
                  }
                  return newsBloc.newsList.value.where((NewsModel option) {
                    return option.title
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (NewsModel selection) {
                  Navigator.pushNamed(
                    context,
                    Routes.newsHandlePage,
                    arguments: selection,
                  );
                },
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    newsBloc = Provider.of<NewsBloc>(context, listen: false);
    newsBloc.fetchAllNews();

    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Noticias'),
        actions: [
          IconButton(
            onPressed: () {
              searchWithKeyword();
            },
            icon: Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: buildNewsList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Incluir notícia',
        onPressed: () {
          Navigator.pushNamed(context, Routes.newsHandlePage).then(
            (value) => setState(() {}),
          );
        },
      ),
    );
  }

  StreamBuilder<List<NewsModel>> buildNewsList() {
    return StreamBuilder<List<NewsModel>>(
      stream: newsBloc.streamNewsList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar notícias'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Ainda não há noticias cadastradas',
            ),
          );
        }

        var list = snapshot.data;
        return ListView.builder(
          itemCount: list!.length,
          itemBuilder: (context, index) {
            var item = list[index];
            return buildListItem(item);
          },
        );
      },
    );
  }

  Widget buildListItem(NewsModel item) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await newsBloc.removeNews(item.id);

        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Notícia \"${item.title}\" excluída'),
          onVisible: () {
            setState(() {});
          },
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: ListTile(
        title: Text(item.title),
        subtitle: Text(item.description),
        trailing: Text(item.author),
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.newsHandlePage,
            arguments: item,
          ).then(
            (value) => setState(() {}),
          );
        },
      ),
    );
  }
}
