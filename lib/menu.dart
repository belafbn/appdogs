import 'package:flutter/material.dart';
import 'package:projeto/screens/gifs.dart';
import 'package:projeto/screens/tarefas/list.dart';
import 'package:projeto/screens/livros/list.dart';
import 'package:projeto/screens/posts.dart';
class MenuOptions extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MenuOptionsState();
  }
}

class MenuOptionsState extends State<MenuOptions>{
  int paginaAtual = 0;
  PageController? pc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          ListaTarefa(),
          ListaLivro(),
          GifsPage(),
          PostPage()
        ],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.access_alarm), label: "Tarefas"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Livros"),
          BottomNavigationBarItem(icon: Icon(Icons.gif_box_outlined), label: "Gifs"),
          BottomNavigationBarItem(icon: Icon(Icons.comment), label: "Posts")
        ],
        onTap: (pagina) {
          pc?.animateToPage(pagina, duration: const Duration(microseconds: 400),
              curve: Curves.ease);
        },
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black54,
      ),
    );
  }

  setPaginaAtual(pagina){
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }
}