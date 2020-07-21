import 'package:compara_precos/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

void main() {
  runApp(ComparaPreco());
}

class ComparaPreco extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compara Preços',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Compara preços'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String item1Price = '0';
  String item2Price = '0';
  String item1PriceFormated = '0';
  String item2PriceFormated = '0';
  String item1Quantity = '1';
  String item2Quantity = '1';
  String item1PriceCalc = '';
  String item2PriceCalc = '';
  MoneyMaskedTextController moneyMasked = new MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', leftSymbol: 'R\$');
  int itemSelecionado = 0;
  final String moneyFormat = r'R$ 00,00';
  final List<String> buttons = [
    '1',
    '2',
    '3',
    '=',
    '4',
    '5',
    '6',
    'C',
    '7',
    '8',
    '9',
    '.',
    '0'
  ];

  @override
  Widget build(BuildContext context) {
    moneyMasked.updateValue(double.parse(item1Price));
    item1PriceFormated = moneyMasked.text;
    moneyMasked.updateValue(double.parse(item2Price));
    item2PriceFormated = moneyMasked.text;
    Widget itemSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItemColumn('Item 1', item1PriceFormated, item1Quantity, 1, item1PriceCalc),
          _buildItemColumn('Item 2', item2PriceFormated, item2Quantity, 3, item2PriceCalc),
        ],
      ),
    );

    void calculaPrecoUnidade(){
      double _quantity;
      if (item1Quantity=='0'){
        _quantity = 1;
      } else {
        _quantity = double.parse(item1Quantity);
      }
      moneyMasked.updateValue(double.parse(item1Price)/_quantity);
      item1PriceCalc = moneyMasked.text;
      if (item2Quantity=='0'){
        _quantity = 1;
      } else {
        _quantity = double.parse(item2Quantity);
      }
      moneyMasked.updateValue(double.parse(item2Price)/_quantity);
      item2PriceCalc = moneyMasked.text;
    }

    Widget buttonSection = Expanded(
      flex: 2,
      child: Container(
          child: GridView.builder(
        itemCount: buttons.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (BuildContext context, int index) {
          if (index == 3) {
            return MyButton(
              buttonTapped: () {
                setState(() {
                  if (itemSelecionado == 1) {
                    item1Price += buttons[index];
                    moneyMasked.updateValue(double.parse(item1Price));
                    item1PriceFormated = moneyMasked.text;
                  } else if (itemSelecionado == 2) {
                    item1Quantity += buttons[index];
                  } else if (itemSelecionado == 3) {
                    item2Price += buttons[index];
                    item2PriceFormated = MaskedTextController(
                            text: item2Price, mask: moneyFormat)
                        .text;
                  } else if (itemSelecionado == 4) {
                    item2Quantity += buttons[index];
                  }
                  calculaPrecoUnidade();
                });
              },
              color: Colors.deepPurpleAccent,
              textColor: Colors.white,
              buttonText: buttons[index],
            );
          } else if (index == 11) {
            //ponto
            return MyButton(
              buttonTapped: () {
                setState(() {
                  if (itemSelecionado == 1 && !item1Price.contains('.')) {
                    item1Price += buttons[index];
                    moneyMasked.updateValue(double.parse(item1Price));
                    item1PriceFormated = moneyMasked.text;
                  } else if (itemSelecionado == 3 &&
                      !item2Price.contains('.')) {
                    item2Price += buttons[index];
                    moneyMasked.updateValue(double.parse(item2Price));
                    item2PriceFormated = moneyMasked.text;
                  } else if (itemSelecionado == 2 &&
                      !item1Quantity.contains('.')) {
                    item1Quantity += buttons[index];
                  } else if (itemSelecionado == 4 &&
                      !item2Quantity.contains('.')) {
                    item2Quantity += buttons[index];
                  }
                  calculaPrecoUnidade();
                });
              },
              color: Colors.deepPurpleAccent,
              textColor: Colors.white,
              buttonText: buttons[index],
            );
          } else if (index == 7) {
            //clear
            return MyButton(
              buttonTapped: () {
                setState(() {
                  if (itemSelecionado == 1) {
                    if (item1Price.length > 0) {
                      item1Price =
                          item1Price.substring(0, item1Price.length - 1);
                    }
                    if (item1Price.length == 0) {
                      item1Price = '0';
                    }
                    moneyMasked.updateValue(double.parse(item1Price));
                    item1PriceFormated = moneyMasked.text;
                  } else if (itemSelecionado == 2) {
                    item1Quantity =
                        item1Quantity.substring(0, item1Quantity.length - 1);
                    if (item1Quantity.length == 0) {
                      item1Quantity = '0';
                    }
                  } else if (itemSelecionado == 3) {
                    if (item2Price.length > 0) {
                      item2Price =
                          item2Price.substring(0, item2Price.length - 1);
                    }
                    if (item2Price.length == 0) {
                      item2Price = '0';
                    }
                    moneyMasked.updateValue(double.parse(item2Price));
                    item2PriceFormated = moneyMasked.text;
                  } else if (itemSelecionado == 4) {
                    item2Quantity =
                        item2Quantity.substring(0, item2Quantity.length - 1);
                    if (item2Quantity.length == 0) {
                      item2Quantity = '0';
                    }
                  }
                  calculaPrecoUnidade();
                });
              },
              color: Colors.deepPurpleAccent,
              textColor: Colors.white,
              buttonText: buttons[index],
            );
          } else {
            return MyButton(
              buttonTapped: () {
                setState(() {
                  if (itemSelecionado == 1) {
                    if (!item1Price.contains(new RegExp(r'\d+\.\d{2}$'))) {
                      if (item1Price == '0') {
                        item1Price = '';
                      }
                      item1Price += buttons[index];
                      moneyMasked.updateValue(double.parse(item1Price));
                      item1PriceFormated = moneyMasked.text;
                    }
                  } else if (itemSelecionado == 2) {
                    if (item1Quantity == '0') {
                      item1Quantity = '';
                    }
                    item1Quantity += buttons[index];
                  } else if (itemSelecionado == 3) {
                    if (!item1Price.contains(new RegExp(r'\d+\.\d{2}$'))) {
                      if (item2Price == '0') {
                        item2Price = '';
                      }
                      item2Price += buttons[index];
                      moneyMasked.updateValue(double.parse(item2Price));
                      item2PriceFormated = moneyMasked.text;
                    }
                  } else if (itemSelecionado == 4) {
                    if (item2Quantity == '0') {
                      item2Quantity = '';
                    }
                    item2Quantity += buttons[index];
                  }
                  calculaPrecoUnidade();
                });
              },
              color: Colors.deepPurple[50],
              textColor: Colors.black,
              buttonText: buttons[index],
            );
          }
        },
      )),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            itemSection,
            buttonSection,
          ],
        ),
      ),
    );
  }

  Container _buildItemColumn(
      String label, String price, String quantity, int indice, String priceQuantity) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      margin: EdgeInsets.all(5),
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.headline4.fontSize * 1.1 + 150.0,
        width: 170,
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  itemSelecionado = indice;
                });
              },
              child: Container(
                color: itemSelecionado == indice
                    ? Colors.amber
                    : Colors.transparent,
                padding: EdgeInsets.all(10),
                child: Text(price),
              ),
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    itemSelecionado = indice + 1;
                  });
                },
                child: Container(
                  color: itemSelecionado == indice + 1
                      ? Colors.amber
                      : Colors.transparent,
                  padding: EdgeInsets.all(10),
                  child: Text(quantity),
                )),
            Text(
              "Preço/Unidade",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              priceQuantity,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ]),
    );
  }
}
