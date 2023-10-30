import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dietary.dart';



class PersonalizedRecommendations extends StatefulWidget {
  static const String routeName = '/risk_level';
  final String? diabetesLevel;
  final String? cancerLevels;
  final String? obesityLevels;
  final String? cardiovascularLevels;
  final String? strokeLevels;
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => PersonalizedRecommendations(),
    );
  }

  const PersonalizedRecommendations(
      {Key? key, this.diabetesLevel, this.cancerLevels, this.obesityLevels, this.cardiovascularLevels, this.strokeLevels})
      : super(key: key);

  @override
  _PersonalizedRecommendationsState createState() =>
      _PersonalizedRecommendationsState();
}


class _PersonalizedRecommendationsState extends State<PersonalizedRecommendations> {
  PageRouteBuilder _customPageRouteBuilder(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset.zero; // Ends at the center of the screen
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dietPlans = [
      {'label': 'Diabetes',
        "level": widget.diabetesLevel,
        'plans':[
          {"title": "**The Mayo Clinic Diet**", "level":"Low Risk", "description":"This diet is a healthy-eating plan that helps control blood sugar. It is naturally rich in nutrients and low in fat and calories. Key elements are fruits, vegetables, and whole grains. The plan helps you control your blood sugar, manage your weight, and control heart disease risk factors such as high blood pressure and high blood fats.","link":"https://www.mayoclinic.org/diseases-conditions/diabetes/in-depth/diabetes-diet/art-20044295"},
          {"title": "**The Healthline Diet**", "level":"Medium Risk", "description":"This diet focuses on high protein, low sugar options like avocados and fatty fish. The main goal is to manage blood sugar levels while also preventing diabetes complications like heart disease. Some of the best foods for people with diabetes include fatty fish, leafy greens, and foods high in fiber.","link":"https://www.healthline.com/nutrition/16-best-foods-for-diabetics"},
          {"title": "**The Diabetes UK Diet**", "level":"High Risk", "description":"This diet emphasizes the importance of eating healthy meals at regular times to better use insulin that the body makes or gets through medicine. It recommends choosing portion sizes that suit the needs for your size and activity level. Recommended foods include fruits, vegetables, whole grains, legumes (such as beans and peas), and low-fat dairy products (such as milk and cheese).","link":"https://www.diabetes.org.uk/guide-to-diabetes/enjoy-food/eating-with-diabetes/what-is-a-healthy-balanced-diet"},

        ]
      },
      {'label': 'Cardiovascular',
        "level": widget.cardiovascularLevels,
        'plans':[
                {"title": "**Healthy eating**", "level":"Low Risk", "description":"A healthy diet can help reduce your risk of developing coronary heart disease and stop you gaining weight, reducing your risk of diabetes and high blood pressure.","link":"https://www.bhf.org.uk/informationsupport/support/healthy-living/healthy-eating"},
                {"title": "**What is the cardiac diet?**", "level":"Medium Risk", "description":"The cardiac diet aims to reduce the risk of cardiovascular disease. It prioritizes foods such as vegetables, whole grains, and oily fish. It also limits processed foods that are high in sugar and salt.","link":"https://www.medicalnewstoday.com/articles/cardiac-diet"},
                {"title": "**Menus for heart-healthy eating: Cut the fat and salt**", "level":"High Risk", "description":"Do you want to adopt a heart-healthy diet, but aren't sure where to start? One way to begin is to create a daily meal plan that emphasizes vegetables, fruits and whole grains and limits high-fat foods (such as red meat, cheese and baked goods) and high-sodium foods (such as canned or processed foods).","link":"https://www.mayoclinic.org/diseases-conditions/heart-disease/in-depth/heart-healthy-diet/art-20046702"},

              ]
      },
      {'label': 'Cancer',
        "level": widget.cancerLevels,
        'plans':[
          {"title": "**Diet & Nutrition During Cancer Treatment**", "level":"Low Risk", "description":"A Healthy Diet Is Important at Each Step in the Cancer Journey Eating problems like nausea or decreased appetite are common during cancer treatment. These problems can make it hard to feel well and eat healthy. ","link":"https://www.cancersupportcommunity.org/diet-nutrition-during-cancer-treatment#:~:text=Limit%20high%2Dcalorie%20foods%20such,help%20you%20feel%20more%20full"},
          {"title": "**How to Eat When You Have Cancer**", "level":"Medium Risk", "description":"What you eat is really important when you have cancer. Your body needs enough calories and nutrients to stay strong. But the disease can make it hard to get what you need, which can be different before, during, and after treatment. And sometimes, you just won’t feel like eating.","link":"https://www.webmd.com/cancer/cancer-diet"},
          {"title": "**Cancer Diet**", "level":"High Risk", "description":"“Sometimes it also depends on the specific type of cancer you have,” explains Rajagopal. “Treatment for breast cancer and blood cancers often involve steroids. Steroids can actually increase your appetite and increase your blood sugar levels, which might lead to insulin resistance and weight gain. ","link":"https://www.hopkinsmedicine.org/health/conditions-and-diseases/cancer/cancer-diet-foods-to-add-and-avoid-during-cancer-treatment"},
        ]
      },
      {'label': 'Stroke',
        "level": widget.strokeLevels,
        'plans':[
          {"title": "**Diet after stroke**", "level":"Low Risk", "description":"A dietitian can help make sure you are getting adequate nutrition. This may mean having particular types of foods and drinks, eating more or less food and taking nutritional supplements.","link":"https://strokefoundation.org.au/what-we-do/for-survivors-and-carers/after-stroke-factsheets/diet-after-stroke-fact-sheet#:~:text=Grain%20(cereal)%20foods%2C%20mostly,their%20alternatives%20%E2%80%93%20mostly%20reduced%20fat"},
          {"title": "**How to Eat After You’ve Had a Stroke**", "level":"Medium Risk", "description":"In the wake of a stroke, many things about your life may be different, including your diet. Changing your diet can help reduce your risk of having another stroke. A healthy diet will also ensure your body is getting the nutrients it needs to support neurological and physical healing.","link":"https://www.everydayhealth.com/stroke/diet-after-a-stroke.aspx"},
          {"title": "**All About Diet for Stroke Patients**", "level":"High Risk", "description":"It is crucial for stroke patients to maintain a healthy diet. Eating nutritious foods can help reduce the risk of having another stroke and improve overall health. ","link":"https://lonestarneurology.net/stroke/diet-for-stroke-prevention/"},
        ]
      },
      {'label': 'Obesity',
        "level": widget.obesityLevels,
        'plans':[
          {"title": "**Obesity Prevention Source**", "level":"Low Risk", "description":"With the daily crush of media coverage about obesity, weight, and health, it’s easy for people to feel overwhelmed. But there are simple steps you can take to help keep weight in check and lower the risk of many chronic diseases.","link":"https://www.hsph.harvard.edu/obesity-prevention-source/diet-lifestyle-to-prevent-obesity/"},
          {"title": "**Diet Chart For Obesity Patient**", "level":"Medium Risk", "description":"A low fat diet, as the name implies, is a dietary pattern that limits the fat intake at about 1/3 of the total daily calories consumed. It consists of little fat, particularly saturated fats and cholesterol which lead to increased blood cholesterol levels and heart attack.","link":"https://www.lybrate.com/topic/obesity-diet-chart"},
          {"title": "**Food and Diet**", "level":"High Risk", "description":"It’s no secret that the amount of calories people eat and drink has a direct impact on their weight: Consume the same number of calories that the body burns over time, and weight stays stable. Consume more than the body burns, weight goes up. Less, weight goes down.","link":"https://www.hsph.harvard.edu/obesity-prevention-source/obesity-causes/diet-and-weight/"},
        ]
      },

    ];


    return Scaffold(
      appBar: AppBar(
        title: Text("Personalized Recommendations"),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://i.pinimg.com/originals/06/38/c0/0638c03a05c4c636193a2eeb40f916c7.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Column(
                    children: dietPlans.map((value) {
                      final List plans = value["plans"];
                      final String level = value["level"];
                      print("Plans => ${plans}");
                      return Column(
                        children: [
                          Text(
                            "${value["label"]} - ${value["level"]}",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue[900],
                              fontFamily: 'Raleway',
                            ),
                          ),
                          Column(
                            children: plans.map((item) {
                              return item["level"] == level ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "${item["title"]}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${item["description"]}",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final Uri url = Uri.parse(item["link"]);
                                        if (!await launchUrl(url)) {
                                          throw Exception('Could not launch $url');
                                        }
                                      },
                                      child: Text("Learn More"),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              ): Container();
                            }).toList(),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route){
                        return route.settings.name == 'DietaryPage';
                      });

                      // Navigator.push(context, _customPageRouteBuilder(DietaryPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[900],
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Back To Home',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PersonalizedRecommendations(),
  ));
}
