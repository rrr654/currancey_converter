import 'dart:convert';

import 'package:currancey_converter/models/currency_model.dart';
import 'package:currancey_converter/shared/components/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color color1 = Colors.orange;
  Color color2= Colors.green;
  Color backGround = Colors.black45;
  List<CurrencyModel> currencies =[];
  String selectedBaseCode = "";
  String selectedBaseName = "EURO";
  String selectedCountryCode = "";
  String selectedCountryName= "US Dollar";
  String selectedCountrySymbol = "£";
  String convertedValue = "0.0";
  bool isLoading = false;
  bool isButtonLoading = false;
  @override
  void initState() {
    allCurrencies().then((value) {
      setState(() {
        isLoading = false;
      });
    }).catchError((onError){
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  backGround,
      body:isLoading ?
          Center(
            child: CircularProgressIndicator(color: color1,),
          )
          :
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    customCont(
                      text1:selectedBaseName.toUpperCase() ,
                        text2: "1 $selectedCountrySymbol",
                        color: color1,
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (ctx) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    )
                                ),
                                height: 700,
                                child: ListView.separated(
                                  itemCount: currencies.length,
                                  itemBuilder: (context, index) {
                                    return
                                      ListTile(
                                      onTap: () {
                                        selectedBaseCode = currencies[index].code!;
                                        selectedCountrySymbol = currencies[index].symbol!;
                                        selectedBaseName = currencies[index].name!;
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      leading: Text(currencies[index].code!,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      trailing: Text(currencies[index].symbol!),
                                      title: Text(currencies[index].name!),
                                    );
                                  },
                                  separatorBuilder: (BuildContext context,
                                      int index) {
                                    return const Divider(
                                      color: Colors.blue,
                                    );
                                  },

                                ),
                              );
                            },
                          );
                        }
                    ),
                    const SizedBox(height: 15,),
                    customCont(
                      text1: selectedCountryName.toUpperCase(),
                      text2: convertedValue,
                      color: color2,
                      onPressed: (){
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (ctx){
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32,vertical: 16),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  )
                              ),
                              height: 700,
                              child: ListView.separated(
                                itemCount: currencies.length,
                                itemBuilder: (context,index){
                                  return ListTile(
                                    onTap: () {
                                      selectedCountryCode=currencies[index].code!;
                                      selectedCountryName =currencies[index].name!;
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    leading:Text(currencies[index].code!,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    trailing:Text(currencies[index].symbol!),
                                    title:Text(currencies[index].name!),
                                  );
                                }, separatorBuilder: (BuildContext context, int index) {
                                return const Divider(
                                  color: Colors.blue,
                                );
                              },

                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: () {},
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.autorenew_rounded,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 30,),
          isButtonLoading?
          Center(
            child: CircularProgressIndicator(color: color1,),
          ):
          InkWell(
            onTap: () {
              setState(() {
                isButtonLoading = true;
              });
              convert(selectedBaseCode, selectedCountryCode).then((value){
              setState(() {
                convertedValue =value;
                isButtonLoading = false;
              });
            });
            },
            child: Container(
              width: 400,
              height: 80,
              decoration: BoxDecoration(
                color: color1,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.send,
                    size: 35,
                    color: Colors.white,
                  ),
                  SizedBox(width: 11),
                  Text(
                    "Convert",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                    ),
                  )
                ],
              ),
            ),
          ) ,
            const SizedBox(height: 15,),
            Container(
              width: 400,
              height: 80,
              decoration: BoxDecoration(
                  color: color1,
                  borderRadius: BorderRadius.circular(12)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:const [
                  Icon(
                    Icons.history,
                    size: 35,
                    color: Colors.white,
                  ),
                  SizedBox(width: 11),
                  Text(
                    "Historical Data",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white
                    ),
                  )
                ],
              ),
            ) ,
          ],
        ),
      ),
    );
  }
  //https://api.freecurrencyapi.com/v1/latest?apikey=tnOw2tbUyZNc1NoBHdMPEojXkCO87EC2JzdrT2sd&currencies=&base_currency=EUR
  Future<String> convert(String base,String currency)async{
    Uri uri= Uri(
      scheme: "https",
      host: "api.freecurrencyapi.com",
      path: "v1/latest",
      queryParameters: {
        "apikey":"tnOw2tbUyZNc1NoBHdMPEojXkCO87EC2JzdrT2sd",
        "currencies":currency,
        "base_currency" :base
      },
    );
    var response = await http.get(uri);
    if(response.statusCode==200){
      var decodedBody = json.decode(response.body) as Map<String,dynamic>;
      num rate  = decodedBody["data"][currency];
      return rate.toStringAsFixed(2);
    }else{
      return "Error";
    }

  }
  Future allCurrencies()async{
    setState(() {
      isLoading = true;
    });
    Uri uri= Uri(
      scheme: "https",
      host: "api.freecurrencyapi.com",
      path: "v1/currencies",
      queryParameters: {
        "apikey":"tnOw2tbUyZNc1NoBHdMPEojXkCO87EC2JzdrT2sd",
        "currencies":"",
      },
    );
    var response = await http.get(uri);
    if(response.statusCode==200){
      var decodedBody = json.decode(response.body) as Map<String,dynamic>;
      Map<String,dynamic> mappedCountries = decodedBody["data"];
      currencies =  mappedCountries.entries.map(
              (e) => CurrencyModel.fromJson(e.value as Map<String,dynamic>)
      ).toList();
    }else{
      return [];
    }
  }
}
