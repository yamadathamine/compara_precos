import 'package:compara_precos/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:spannable_grid/spannable_grid.dart';

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
  String item1PriceCalc = 'R\$0.00';
  String item2PriceCalc = 'R\$0.00';
  String item1PriceCalc1000 = 'R\$0.00';
  String item2PriceCalc1000 = 'R\$0.00';
  Color statusItem1 = Colors.transparent;
  Color statusItem2 = Colors.transparent;
  Color buttonColor1 = Colors.teal[600];
  Color buttonTextColor1 = Colors.white;
  Color buttonColor2 = Colors.teal[50];
  Color buttonTextColor2 = Colors.black;
  int itemSelecionado = 0;
  final String moneyFormat = r'R$ 00,00';
  final List<String> buttons = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '.',
    '0',
    '<-',
  ];
  String formataDinheiro(String valor) {
    MoneyMaskedTextController moneyMasked = new MoneyMaskedTextController(
        decimalSeparator: '.', thousandSeparator: ',', leftSymbol: 'R\$');
    moneyMasked.updateValue(double.parse(valor));
    return moneyMasked.text;
  }

  @override
  Widget build(BuildContext context) {
    item1PriceFormated = formataDinheiro(item1Price);
    item2PriceFormated = formataDinheiro(item2Price);
    Orientation orientation = MediaQuery.of(context).orientation;

    Widget buttonSection = Expanded(
      flex: 5,
      child: ListView(
        children: [Container(
            margin: EdgeInsets.all(8),
            child: SpannableGrid(
              columns: 4,
              rows: 4,
              cells: _getCells(),
              spacing: 2.0,
            )
        ),
      ]),
    );

    Widget itemSection = Expanded(
        flex: 4,
        child: Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: _buildItemColumn(
                      'Item 1',
                      item1PriceFormated,
                      item1Quantity,
                      1,
                      item1PriceCalc,
                      statusItem1,
                      item1PriceCalc1000)),
              Expanded(
                  flex: 1,
                  child: _buildItemColumn(
                      'Item 2',
                      item2PriceFormated,
                      item2Quantity,
                      3,
                      item2PriceCalc,
                      statusItem2,
                      item2PriceCalc1000)),
            ],
          ),
        ));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: (orientation == Orientation.portrait)?
        Column(
          children: <Widget>[
            itemSection,
            buttonSection,
          ],
        ):
        Row(children: <Widget>[
          itemSection,
          buttonSection,
        ],),
      ),
    );
  }

  void calculaPrecoUnidade() {
    double _quantity;
    double _result1;
    double _result2;
    if (item1Quantity == '0') {
      _quantity = 1;
    } else {
      _quantity = double.parse(item1Quantity);
    }
    _result1 = double.parse(item1Price) / _quantity;
    item1PriceCalc = formataDinheiro(_result1.toString());
    item1PriceCalc1000 = formataDinheiro((_result1 * 1000).toString());
    if (item2Quantity == '0') {
      _quantity = 1;
    } else {
      _quantity = double.parse(item2Quantity);
    }
    _result2 = double.parse(item2Price) / _quantity;
    item2PriceCalc = formataDinheiro(_result2.toString());
    item2PriceCalc1000 = formataDinheiro((_result2 * 1000).toString());
    if (_result1 > _result2) {
      statusItem1 = Colors.red[100];
      statusItem2 = Colors.green[100];
    } else {
      statusItem2 = Colors.red[100];
      statusItem1 = Colors.green[100];
    }
  }

  String adicionaDigito(String numAtual, String novoDigito) {
    if (numAtual == '0') {
      numAtual = '';
    }
    return numAtual + novoDigito;
  }

  String removeUltimoDigito(String numAtual) {
    if (numAtual.length > 0) {
      numAtual = numAtual.substring(0, numAtual.length - 1);
    }
    if (numAtual.length == 0) {
      numAtual = '0';
    }
    return numAtual;
  }

  String atualizaPreco(String precoAtual, String novoDigito) {
    if (!precoAtual.contains(new RegExp(r'\d+\.\d{2}$'))) {
      precoAtual = adicionaDigito(precoAtual, novoDigito);
    }
    return precoAtual;
  }

  List<SpannableGridCellData> _getCells() {
    List<SpannableGridCellData> result = List();
    int cont = 0;
    for (var linha = 1; linha < 5; linha++) {
      for (var coluna = 1; coluna < 4; coluna++) {
        if (cont == 9) {
          //ponto
          result.add(SpannableGridCellData(
              column: coluna,
              row: linha,
              id: 'ponto',
              child: Container(
                  child: MyButton(
                buttonTapped: () {
                  setState(() {
                    if (itemSelecionado == 1 && !item1Price.contains('.')) {
                      item1Price += '.';
                      item1PriceFormated = formataDinheiro(item1Price);
                    } else if (itemSelecionado == 3 &&
                        !item2Price.contains('.')) {
                      item2Price += '.';
                      item2PriceFormated = formataDinheiro(item2Price);
                      ;
                    } else if (itemSelecionado == 2 &&
                        !item1Quantity.contains('.')) {
                      item1Quantity += '.';
                    } else if (itemSelecionado == 4 &&
                        !item2Quantity.contains('.')) {
                      item2Quantity += '.';
                    }
                    calculaPrecoUnidade();
                  });
                },
                color: buttonColor1,
                textColor: buttonTextColor1,
                buttonText: '.',
              )
              )
          ));
        } else if (cont == 11) {
          result.add(SpannableGridCellData(
              column: coluna,
              row: linha,
              id: buttons[cont],
              child: Container(
                  child: MyIconButton(
                buttonTapped: () {
                  setState(() {
                    if (itemSelecionado == 1) {
                      item1Price = removeUltimoDigito(item1Price);
                      item1PriceFormated = formataDinheiro(item1Price);
                    } else if (itemSelecionado == 2) {
                      item1Quantity = removeUltimoDigito(item1Quantity);
                    } else if (itemSelecionado == 3) {
                      item2Price = removeUltimoDigito(item2Price);
                      item2PriceFormated = formataDinheiro(item2Price);
                    } else if (itemSelecionado == 4) {
                      item2Quantity = removeUltimoDigito(item2Quantity);
                    }
                    calculaPrecoUnidade();
                  });
                },
                color: buttonColor1,
                iconColor: buttonTextColor1,
                icon: Icons.backspace,
              )
              )
          ));
        } else {
          result.add(
            SpannableGridCellData(
              column: coluna,
              row: linha,
              id: buttons[cont],
              child: Container(
                child: _createDigitButton(buttons[cont]),
              ),
            ),
          );
        }
        cont++;
      }
    }
    result.add(
      SpannableGridCellData(
        column: 4,
        row: 1,
        rowSpan: 2,
        id: 'C',
        child: Container(
            child: MyButton(
          buttonTapped: () {
            setState(() {
              if (itemSelecionado == 1) {
                item1Price = '0';
                item1PriceFormated = formataDinheiro(item1Price);
              } else if (itemSelecionado == 2) {
                item1Quantity = '0';
              } else if (itemSelecionado == 3) {
                item2Price = '0';
                item2PriceFormated = formataDinheiro(item2Price);
              } else if (itemSelecionado == 4) {
                item2Quantity = '0';
              }
              calculaPrecoUnidade();
            });
          },
          color: buttonColor1,
          textColor: buttonTextColor1,
          buttonText: 'C',
        )),
      ),
    );
    result.add(
      SpannableGridCellData(
        column: 4,
        row: 3,
        rowSpan: 2,
        id: 'CA',
        child: Container(
          child: MyButton(
            buttonTapped: () {
              setState(() {
                item1Price = '0';
                item1PriceFormated = formataDinheiro(item1Price);
                item1Quantity = '0';
                item2Price = '0';
                item2PriceFormated = formataDinheiro(item2Price);
                item2Quantity = '0';
                calculaPrecoUnidade();
                statusItem1 = Colors.transparent;
                statusItem2 = Colors.transparent;
              });
            },
            color: buttonColor1,
            textColor: buttonTextColor1,
            buttonText: 'CA',
          ),
        ),
      ),
    );
    return result;
  }

  MyButton _createDigitButton(String digit) {
    return MyButton(
      buttonTapped: () {
        setState(() {
          if (itemSelecionado == 1) {
            item1Price = atualizaPreco(item1Price, digit);
            item1PriceFormated = formataDinheiro(item1Price);
          } else if (itemSelecionado == 2) {
            item1Quantity = adicionaDigito(item1Quantity, digit);
          } else if (itemSelecionado == 3) {
            item2Price = atualizaPreco(item2Price, digit);
            item2PriceFormated = formataDinheiro(item2Price);
          } else if (itemSelecionado == 4) {
            item2Quantity = adicionaDigito(item2Quantity, digit);
          }
          calculaPrecoUnidade();
        });
      },
      color: buttonColor2,
      textColor: buttonTextColor2,
      buttonText: digit,
    );
  }

  Container _buildItemColumn(
      String label,
      String price,
      String quantity,
      int indice,
      String priceQuantity,
      Color statusItem,
      String priceQuantity1000) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: statusItem),
        borderRadius: BorderRadius.circular(5),
        color: statusItem,
      ),
      margin: EdgeInsets.only(left: 5, right: 5),
      padding: EdgeInsets.all(5),
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.headline3.fontSize * 1.1 + 280.0,
        width: 170,
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.subtitle1.fontSize + 1,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.subtitle1.fontSize,
              ),
              child: Text(
                'Preço',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.subtitle2.fontSize,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  itemSelecionado = indice;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          itemSelecionado == indice ? Colors.blue : Colors.grey,
                      width: itemSelecionado == indice ? 2 : 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.headline4.fontSize * 1.2,
                ),
                padding: EdgeInsets.all(10),
                child: Text(
                  price,
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.subtitle1.fontSize),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.subtitle1.fontSize,
              ),
              child: Text(
                'Quantidade',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.subtitle2.fontSize,
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    itemSelecionado = indice + 1;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: itemSelecionado == indice + 1
                            ? Colors.blue
                            : Colors.grey,
                        width: itemSelecionado == indice + 1 ? 2 : 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  constraints: BoxConstraints.expand(
                    height:
                        Theme.of(context).textTheme.headline4.fontSize * 1.2,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    quantity,
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.subtitle1.fontSize),
                  ),
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
                fontSize: Theme.of(context).textTheme.headline5.fontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "Preço * 1000 Unidades",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              priceQuantity1000,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline6.fontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          ]),
    );
  }
}
