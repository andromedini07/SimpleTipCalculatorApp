import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tip_calculator_app/util/hexcolor.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Simple Tip Calculator App"),
          centerTitle: false,
          backgroundColor: Colors.indigo,
        ),
        body: BillSplitter(),
      );
}

class BillSplitter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BillSplitterState();
}

class BillSplitterState extends State<BillSplitter> {
  int _tipPercentage = 0;
  int _personCounter = 1;
  double _billAmount = 0.0;
  Color _purple = HexColor("#6908D6");

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      alignment: Alignment.center,
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(20.5),
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: _purple.withOpacity(0.1), //Colors.purpleAccent.shade100,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total per person",
                  style: TextStyle(
                      color: _purple,
                      fontWeight: FontWeight.normal,
                      fontSize: 17),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "\$${calculateTotalPerPerson(_billAmount, _tipPercentage.toDouble(), _personCounter).toStringAsFixed(2)}",
                    style: TextStyle(
                        color: _purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 34.9),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                  color: Colors.blueGrey.shade100, style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: _purple),
                  decoration: InputDecoration(
                      prefixText: "Bill Amount",
                      prefixIcon: Icon(Icons.attach_money)),
                  onChanged: (String text) {
                    // Logic
                    setState(() {
                      if (text.trim().isNotEmpty) {
                        _billAmount = double.parse(text);
                      }
                    });
                  },
                  inputFormatters: [LengthLimitingTextInputFormatter(5)],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Split",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    Row(
                      children: [
                        InkWell(
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: _purple.withOpacity(0.1)),
                            child: Center(
                              child: Text(
                                "-",
                                style: TextStyle(
                                    color: _purple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              if (_personCounter > 1) {
                                _personCounter--;
                              }
                            });
                          },
                        ),
                        Text(
                          "$_personCounter",
                          style: TextStyle(
                              color: _purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0),
                        ),
                        InkWell(
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: _purple.withOpacity(0.1)),
                            child: Center(
                              child: Text(
                                "+",
                                style: TextStyle(
                                    color: _purple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _personCounter++;
                            });
                          },
                        )
                      ],
                    )
                  ],
                ),
                // Split Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tip"),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "\$${calculateTipPerPerson(_billAmount, _tipPercentage.toDouble(), _personCounter).toStringAsFixed(2)}",
                        style: TextStyle(
                            color: _purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    )
                  ],
                ),
                // Slider
                Column(
                  children: [
                    Text(
                      "$_tipPercentage %",
                      style: TextStyle(
                          color: _purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    Slider(
                        min: 0,
                        max: 100,
                        activeColor: _purple,
                        divisions: 20,
                        inactiveColor: Colors.grey,
                        value: _tipPercentage.toDouble(),
                        onChanged: (double newValue) {
                          setState(() {
                            _tipPercentage = newValue.round();
                          });
                        })
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  double calculateTipPerPerson(
      double billAmount, double tipPercent, int split) {
    return (billAmount * (tipPercent / 100)) / split;
  }

  double calculateTotalPerPerson(
      double billAmount, double tipPercent, int split) {
    var tipPerPerson = calculateTipPerPerson(billAmount, tipPercent, split);
    return (billAmount / split) + tipPerPerson;
  }
}