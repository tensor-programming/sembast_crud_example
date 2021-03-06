import 'package:flutter/material.dart';

import 'package:sembast_crud_example/bloc/note_bloc.dart';
import 'package:sembast_crud_example/bloc/provider.dart';

import 'package:sembast_crud_example/models/model.dart';
import 'package:sembast_crud_example/database/crud.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteBloc>(
      builder: (_, NoteBloc bloc) =>
          bloc ??
          NoteBloc(
            DBLogic(),
          ),
      onDispose: (_, bloc) => bloc.dispose(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: DefaultTabController(
          length: 2,
          child: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<NoteBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes Crud'),
        bottom: TabBar(
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.info),
              text: 'Note Page',
            ),
            Tab(
              icon: Icon(Icons.input),
              text: 'Input Form',
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          InfoTab(bloc),
          FormTab(bloc),
        ],
      ),
    );
  }
}

class FormTab extends StatefulWidget {
  final NoteBloc bloc;

  FormTab(this.bloc);

  @override
  _FormTabState createState() => _FormTabState();
}

class _FormTabState extends State<FormTab> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _controller,
            onFieldSubmitted: (text) {
              widget.bloc.inSink
                  .add(Note(body: text, state: NotesState.INSERT));

              setState(() => _controller.clear());
            },
          )
        ],
      ),
    );
  }
}

class InfoTab extends StatefulWidget {
  final NoteBloc bloc;

  InfoTab(this.bloc);

  @override
  _InfoTabState createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  @override
  void initState() {
    super.initState();
    widget.bloc.inSink.add(Note(state: NotesState.GETALL));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: widget.bloc.outgoing,
              builder: (context, AsyncSnapshot<List<Note>> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return ListView(
                  children: snapshot.data
                      .map(
                        (note) => GestureDetector(
                              child: ListTile(
                                title: note.editing
                                    ? TextFormField(
                                        initialValue: note.body,
                                        onFieldSubmitted: (text) => setState(
                                              () => widget.bloc.inSink.add(
                                                    note.copyWith(
                                                      body: text,
                                                      editing: !note.editing,
                                                      state: NotesState.UPDATE,
                                                    ),
                                                  ),
                                            ),
                                      )
                                    : Text(note.body),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => setState(
                                        () => widget.bloc.inSink.add(
                                              note.copyWith(
                                                id: note.id,
                                                state: NotesState.DETLETE,
                                              ),
                                            ),
                                      ),
                                ),
                              ),
                              onTap: () {
                                setState(() => widget.bloc.inSink.add(
                                      note.copyWith(
                                          editing: !note.editing,
                                          state: NotesState.UPDATE),
                                    ));
                              },
                            ),
                      )
                      .toList(),
                );
              },
            ),
          ),
          MaterialButton(
            child: Text('Delete All'),
            onPressed: () => setState(() => widget.bloc.inSink.add(Note(
                  state: NotesState.DELETE_ALL,
                ))),
            elevation: 10.0,
            color: ThemeData.dark().indicatorColor,
          )
        ],
      ),
    );
  }
}
