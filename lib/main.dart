import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IMC App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: ''),
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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  String _result;
  int _result_index = -1;

  @override
  void initState() {
    super.initState();
    resetFields();
  }

  void resetFields() {
    _weightController.text = '';
    _heightController.text = '';
    _result_index = -1;
    setState(() {
      _result = 'Informe seus dados';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [buildForm(), buildGrid()],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Calculadora de IMC'),
      backgroundColor: Colors.blue,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            resetFields();
          },
        )
      ],
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildTextFormField(
            label: "Peso (kg)",
            error: "Insira seu peso!",
            controller: _weightController,
          ),
          buildTextFormField(
              label: "Altura (cm)",
              error: "Insira uma altura!",
              controller: _heightController),
          buildTextResult(),
        ],
      ),
    );
  }

  static const classificacao = {
    0: "Magreza grave",
    1: "Magreza moderada",
    2: "Magreza leve",
    3: "Saudável",
    4: "Sobrepeso",
    5: "Obesidade Grau I",
    6: "Obesidade Grau II (severa)",
    7: "Obesidade Grau III (mórbida)"
  };

  void calcularImc() {
    double weight = double.parse(_weightController.text);
    double height = double.parse(_heightController.text) / 100.0;
    double imc = weight / (height * height);
    setState(() {
      _result = "IMC = ${imc.toStringAsPrecision(2)}\n";
      if (imc < 16)
        _result_index = 0;
      else if (imc < 17)
        _result_index = 1;
      else if (imc < 18.5)
        _result_index = 2;
      else if (imc < 25)
        _result_index = 3;
      else if (imc < 30)
        _result_index = 4;
      else if (imc < 35)
        _result_index = 5;
      else if (imc < 40)
        _result_index = 6;
      else
        _result_index = 7;
    });
  }

  Widget buildGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: classificacao.entries.map((entry) {
            var w = Card(
                color: entry.key == _result_index
                    ? _result_index == 3 ? Colors.green : Colors.red
                    : Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(entry.value),
                ));
            return w;
          }).toList(),
        ),
      ),
    );
  }

  Widget buildTextResult() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0),
      child: Text(
        _result,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildTextFormField(
      {TextEditingController controller, String error, String label}) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      onChanged: (valor) {
        if (_formKey.currentState.validate()) {
          calcularImc();
        } else {
          setState(() {
            _result = 'Informe seus dados';
            _result_index = -1;
          });
        }
      },
      validator: (text) {
        return text.isEmpty ? error : null;
      },
    );
  }
}
