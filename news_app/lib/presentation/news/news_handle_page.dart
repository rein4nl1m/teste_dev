import 'package:flutter/material.dart';
import 'package:news_app/core/blocs/news_bloc.dart';
import 'package:news_app/data/model/news_model.dart';
import 'package:news_app/presentation/widgets/default_spacer.dart';
import 'package:provider/provider.dart';

class NewsHandlePage extends StatefulWidget {
  final NewsModel? news;
  const NewsHandlePage({Key? key, this.news}) : super(key: key);

  @override
  _NewsHandlePageState createState() => _NewsHandlePageState();
}

class _NewsHandlePageState extends State<NewsHandlePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late NewsModel? news;
  late NewsBloc newsBloc;
  late bool editNews;
  bool processing = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController authorController = TextEditingController();

  initForm() {
    titleController.text = news!.title;
    descriptionController.text = news!.description;
    authorController.text = news!.author;
  }

  @override
  void initState() {
    news = widget.news;
    editNews = news != null;
    if (editNews) initForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(editNews ? 'Editar Notícia' : 'Incluir Notícia'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Título',
                    counter: SizedBox(),
                  ),
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Necessário preencher o título';
                    }

                    if (value.length < 3) {
                      return 'Preencher com no mínimo 3 caracteres';
                    }

                    return null;
                  },
                ),
                defaultSpacer(size),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Descrição',
                  ),
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Necessário preencher o conteúdo da noticia';
                    }

                    if (value.length < 10) {
                      return 'Preencher com no mínimo 10 caracteres';
                    }

                    return null;
                  },
                ),
                defaultSpacer(size),
                TextFormField(
                  controller: authorController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Autor',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Necessário informar o autor da noticia';
                    }

                    if (value.length < 3) {
                      return 'Preencher com no mínimo 3 caracteres';
                    }

                    return null;
                  },
                ),
                defaultSpacer(size),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: processing
                            ? Colors.white
                            : editNews
                                ? Colors.green
                                : null,
                      ),
                      onPressed: () async {
                        setState(() => processing = !processing);
                        if (_formKey.currentState!.validate()) {
                          newsBloc = Provider.of<NewsBloc>(
                            context,
                            listen: false,
                          );
                          if (editNews) {
                            await newsBloc.editNews(
                              news!.copyWith(
                                title: titleController.text,
                                description: descriptionController.text,
                                author: authorController.text,
                              ),
                            );
                          } else {
                            var item = NewsModel(
                              title: titleController.text,
                              description: descriptionController.text,
                              author: authorController.text,
                            );

                            await newsBloc.addNews(item);
                          }

                          Navigator.pop(context);
                        }

                        setState(() => processing = !processing);
                      },
                      child: processing
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(editNews ? 'Atualizar' : 'Incluir'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
