import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_for_thought/classes/created_recipe_class.dart';
import 'dart:io';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RecipeCreation extends StatefulWidget {
  @override
  RecipeCreationState createState() => RecipeCreationState();
}

class RecipeCreationState extends State<RecipeCreation>
    with CreatedRecipeMixin {
  TextEditingController recipeTitle = TextEditingController();
  TextEditingController recipe = TextEditingController();
  TextEditingController cookTime = TextEditingController();
  TextEditingController servings = TextEditingController();
  TextEditingController cookInstructions = TextEditingController();
  TextEditingController ingredients = TextEditingController();
  List<dynamic> ingredientsList = [];
  final RoundedLoadingButtonController createRecipeButton =
      RoundedLoadingButtonController();

  //variable to hold value after calling areAllFieldsFilled()
  bool allFieldsAreFilled = false;
  void areAllFieldsFilled() {
    //all controllers except ingredients because ingredients controller is cleared after 'add ingredient' button is clicked
    if (recipeTitle.text.toString().isNotEmpty &&
        servings.text.toString().isNotEmpty &&
        cookTime.text.toString().isNotEmpty &&
        // ingredientsList.isNotEmpty &&
        cookInstructions.text.isNotEmpty) {
      setState(() {
        allFieldsAreFilled = true;
      });
    }
    //else
    setState(() {
      allFieldsAreFilled = false;
    });
  }

  //For user to input an image
  final picker = ImagePicker();

  XFile? xfileImage;
  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      xfileImage = img!;
    });
  }

  final emptyIngredientList = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Empty Input',
      message: 'Please enter an ingredient first!',
      contentType: ContentType.failure,
    ),
    actions: const [SizedBox.shrink()],
  );
  final emptyInput = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Empty Field',
      message: 'Please input all fields first!',
      contentType: ContentType.failure,
    ),
    actions: const [SizedBox.shrink()],
  );

  void displayImageChoice() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.gallery);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                      child: Row(
                        children: [
                          Icon(Icons.image),
                          Text(' From Gallery'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.camera);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                      child: Row(
                        children: [
                          Icon(Icons.camera),
                          Text(' From Camera'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // TextField character limits
  int recipeTitleMaxLength = 50;
  int servingsMaxLength = 3;
  int cookTimeMaxLength = 3;
  int ingredientsMaxLength = 50;
  int cookInstructionsMaxLength = 1500;
  // FocusNodes for TextFields, toggles the suffixIcons being visible
  FocusNode recipeTitleFocusNode = FocusNode();
  FocusNode servingsFocusNode = FocusNode();
  FocusNode cookTimeFocusNode = FocusNode();
  FocusNode ingredientsFocusNode = FocusNode();
  FocusNode cookInstructionsFocusNode = FocusNode();
  // textfield suffixicon character count colors
  MaterialColor? recipeTitleCharCountColor;
  MaterialColor? cookInstructionsCharCountColor;
  MaterialColor? ingredientsCharCountColor;
  MaterialColor? cookTimeCharCountColor; //inactive
  MaterialColor? servingsCharCountColor; //inactive
  // for CheckBox asking if the user wants to make the post public
  bool isPublicRecipe = false;

  @override
  void initState() {
    super.initState();
    recipeTitleFocusNode.addListener(_onFocusChange);
    servingsFocusNode.addListener(_onFocusChange);
    cookTimeFocusNode.addListener(_onFocusChange);
    ingredientsFocusNode.addListener(_onFocusChange);
    cookInstructionsFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    recipeTitleFocusNode.dispose();
    servingsFocusNode.dispose();
    cookTimeFocusNode.dispose();
    ingredientsFocusNode.dispose();
    cookInstructionsFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {}); //update the state when the focus changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), body: body());
  }

  LayoutBuilder body() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      //to set width of containers and other things, set to 90% of screen width
      double widthOfWidgets = constraints.maxWidth * .9;
      if (recipeTitle.text.length < (recipeTitleMaxLength * .5)) {
        // characters are < 50% of the limit
        recipeTitleCharCountColor = Colors.grey;
      } else if (recipeTitle.text.length < (recipeTitleMaxLength * .8)) {
        // characters are >= 50% and < 80% of the limit
        recipeTitleCharCountColor = Colors.orange;
      } else {
        // characters are >= 80% of the limit
        recipeTitleCharCountColor = Colors.red;
      }
      if (ingredients.text.length < (ingredientsMaxLength * .5)) {
        ingredientsCharCountColor = Colors.grey;
      } else if (ingredients.text.length < (ingredientsMaxLength * .8)) {
        ingredientsCharCountColor = Colors.orange;
      } else {
        ingredientsCharCountColor = Colors.red;
      }
      if (cookInstructions.text.length < (cookInstructionsMaxLength * .5)) {
        cookInstructionsCharCountColor = Colors.grey;
      } else if (cookInstructions.text.length <
          (cookInstructionsMaxLength * .8)) {
        cookInstructionsCharCountColor = Colors.orange;
      } else {
        cookInstructionsCharCountColor = Colors.red;
      }

      return Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: constraints.maxWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                SizedBox(
                  width: widthOfWidgets,
                  child: TextField(
                    focusNode: recipeTitleFocusNode,
                    controller: recipeTitle,
                    //Text Field for recipe namer
                    maxLength: recipeTitleMaxLength, //50 character limit
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Recipe Title',
                      suffixIcon: recipeTitleFocusNode.hasFocus
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '${recipeTitle.text.length}/$recipeTitleMaxLength',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: recipeTitleCharCountColor),
                              ),
                            )
                          : null,
                      counterText: '',
                      counterStyle: TextStyle(height: 0),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                    onEditingComplete: areAllFieldsFilled,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: (widthOfWidgets - 10) / 2,
                      child: TextField(
                        focusNode: servingsFocusNode,
                        controller: servings,
                        maxLength: servingsMaxLength,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Servings',
                          counterText: '',
                          counterStyle: TextStyle(height: 0),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        onEditingComplete: areAllFieldsFilled,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: (widthOfWidgets - 10) / 2,
                      child: TextField(
                        focusNode: cookTimeFocusNode,
                        controller: cookTime,
                        //Text Field for recipe name
                        maxLength:
                            cookTimeMaxLength, // 3 digit number max length
                        keyboardType: TextInputType
                            .number, // number keyboard for easy input
                        // allows only numbers in the input, useful in the case of preventing copy/pasting text into the field
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Cook Time (Minutes)',
                          counterText: '',
                          counterStyle: TextStyle(height: 0),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        onEditingComplete: areAllFieldsFilled,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // only show ingredients list if it has at least one item in it

                SizedBox(
                  width: widthOfWidgets,
                  child: Row(
                    //row containing the input field and the button to add ingredient
                    children: [
                      Expanded(
                        child: TextField(
                          //ingredient input field
                          controller: ingredients,
                          focusNode: ingredientsFocusNode,
                          maxLength:
                              ingredientsMaxLength, //50 character max per ingredient entry
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Ingredients',
                            suffixIcon: ingredientsFocusNode.hasFocus
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      '${ingredients.text.length}/$ingredientsMaxLength',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: ingredientsCharCountColor),
                                    ),
                                  )
                                : null,
                            counterText: '',
                            counterStyle: TextStyle(height: 0),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                          onEditingComplete: areAllFieldsFilled,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          //add ingredient button
                          onPressed: () {
                            if (ingredients.text.toString().isNotEmpty) {
                              setState(() {
                                ingredientsList
                                    .add(ingredients.text.toString());
                                ingredients.clear();
                              });
                              // didChangeDependencies();
                              areAllFieldsFilled();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Please enter an ingredient.')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                          child: Text(
                            'Add Ingredient',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: ingredientsList.isNotEmpty,
                  // ignore: sized_box_for_whitespace
                  child: Column(
                    children: [
                      SizedBox(
                        width: widthOfWidgets,
                        height: 190,
                        child: Column(
                          children: [
                            Text("Your Ingredients:",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 16)),
                            SizedBox(
                              height: 5,
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: SizedBox(
                                      width: widthOfWidgets,
                                      height: 160,
                                      child: ListView.separated(
                                        itemCount: ingredientsList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Material(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            color: Color.fromARGB(
                                                255, 232, 230, 230),
                                            child: ListTile(
                                              dense: true,
                                              title:
                                                  Text(ingredientsList[index]),
                                              trailing: IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  setState(() {
                                                    ingredientsList[index] =
                                                        null;
                                                    ingredientsList.removeWhere(
                                                        (element) =>
                                                            element == null);
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 5,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: widthOfWidgets,
                  child: TextField(
                    focusNode: cookInstructionsFocusNode,
                    controller: cookInstructions,
                    minLines: 5,
                    maxLines: 8,
                    maxLength: cookInstructionsMaxLength, //character limit
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Cooking Instructions',
                      suffixIcon: cookInstructionsFocusNode.hasFocus
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '${cookInstructions.text.length}/$cookInstructionsMaxLength',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: cookInstructionsCharCountColor),
                              ),
                            )
                          : null,
                      counterText: '',
                      counterStyle: TextStyle(height: 0),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                    onEditingComplete: areAllFieldsFilled,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                      child: Text(
                        'Choose a Photo!',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        displayImageChoice();
                      }),
                ),
                //if image not null show the image
                //if image null show text
                Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: xfileImage != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Image.file(
                                //to show image, you type like this.
                                File(xfileImage!.path),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                              ),
                            ),
                          )
                        : null),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Make this recipe public?',
                        style: TextStyle(fontSize: 16)),
                    Checkbox(
                        value: isPublicRecipe,
                        tristate: false,
                        checkColor: Color.fromARGB(255, 247, 247, 247),
                        activeColor: Color.fromARGB(255, 244, 4, 4),
                        onChanged: (value) {
                          setState(() {
                            isPublicRecipe = value!;
                          });
                        }),
                  ],
                ),
                SizedBox(
                  width: widthOfWidgets,
                  height: 60,
                  child: RoundedLoadingButton(
                      resetDuration: Duration(seconds: 2),
                      animateOnTap: true,
                      borderRadius: 8,
                      errorColor: Colors.red,
                      successColor: Colors.green,
                      color: Color.fromARGB(255, 244, 4, 4),
                      onPressed: () async {
                        if (recipeTitle.text.toString().isNotEmpty &&
                            servings.text.toString().isNotEmpty &&
                            cookTime.text.toString().isNotEmpty &&
                            ingredientsList.isNotEmpty &&
                            cookInstructions.text.toString().isNotEmpty) {
                          createRecipeButton.success();
                          Timer(Duration(seconds: 2),
                              () => createRecipeButton.reset());

                          //send the image to cloud storage
                          String downloadUrl = await uploadImage(
                              image: xfileImage, recipeName: recipeTitle.text);
                          //temporary variables hold recipe data
                          Map<String, dynamic> data = {
                            'title': recipeTitle.text,
                            'servings': servings.text,
                            'ingredients': ingredientsList,
                            'cookInstructions': cookInstructions.text,
                            'thumbnailUrl': downloadUrl,
                            'cookTime': cookTime.text
                          };
                          //add to user's personal created recipes collection
                          await uploadRecipe(
                              recipeData: data, name: recipeTitle.text);
                          if (isPublicRecipe) {
                            //if public, add to public created recipes collection
                            await uploadPublicRecipe(
                                recipeData: data, name: recipeTitle.text);
                          }
                          //ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Recipe Created"),
                                content: Text(
                                    "Your recipe has been created successfully!"),
                                actions: [
                                  Container(
                                    width: 70,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color.fromARGB(255, 244, 4, 4),
                                    ),
                                    child: TextButton(
                                      child: Text(
                                        "Ok",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                          //clear all input fields
                          recipeTitle.clear();
                          recipe.clear();
                          cookTime.clear();
                          servings.clear();
                          ingredients.clear();
                          ingredientsList.clear();
                          cookInstructions.clear();
                          setState(() {
                            xfileImage = null;
                          });
                        } else {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentMaterialBanner()
                            ..showMaterialBanner(emptyInput);
                          createRecipeButton.error();
                          Timer(Duration(seconds: 2),
                              () => createRecipeButton.reset());

                          Timer(
                              Duration(seconds: 2),
                              () => ScaffoldMessenger.of(context)
                                  .hideCurrentMaterialBanner());
                        }
                      },
                      controller: createRecipeButton,
                      child: Text(
                        'Confirm Recipe Creation',
                        style: TextStyle(fontSize: 20),
                      )
                      //else: notify user that they already created that recipe (duplicate name)
                      ),
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        ),
      );
    });
  }

  AppBar appBar() {
    return AppBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(80))),
      backgroundColor: Colors.grey,
      toolbarHeight: 30,
      centerTitle: true,
      title: Text(
        'Create a Recipe',
        style:
            TextStyle(color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
      ),
      automaticallyImplyLeading: false,
    );
  }
}
