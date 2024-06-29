
## Description

Recipe finding has become convoluted, and time consuming. The goal of this project, it to present recipes to users in a simple and intuitive way. Borrowing from the Tinder formula, we aim to present users with recipes in a modular, mobile friendly format, of which they can like or dislike. We will allow users to create their own recipes, with the goal of becoming a personal cookbook.

## Technologies

This app was developed using **Dart** and **Flutter**. One of the main reasons is because Flutter allows for seamless cross-platform development. Having the flexibility to choose your deployment platform    proved very useful over the course of our project. Another reason for using this technology, was for the simple fact that it was new technology to each developer working on this project. We wanted to not only build a cool and original piece of software, but also the challenge and excitement of learning something new.

We make use of the **Spoonacular API** to supply our application with recipe data.

We use **Firebase** for our backend. We use the built in authentification features that firebase provides, as well as the NO-SQL Firestore database for data retention.

# Installation

### Clone this repository
```bash
$ git clone https://github.com/gavin-fromm/Recipeal.git
```
### Navigate to the repository
```
$ cd Recipe-Tinder/food_for_thought
```
### Install Dependencies
```bash
flutter clean
flutter pub get
```

# Running the Application

## Android Emulator 
(Note: You must have android studio and an emulation device added. The device we worked with, is the Google Pixel XL 5.5" with the API level 30)

Open VS Code and click the highlighted option

![Readme Image 1](https://user-images.githubusercontent.com/109327531/231516021-e73ee33d-79f6-41e2-930b-29d0eafa919f.png)

Then, choose the Android Emulation Device from the list

![Readme Image 2](https://user-images.githubusercontent.com/109327531/231515839-28efdc45-c216-478c-a15d-10e80a292a2f.png)

### Run the app
```bash
flutter run
```


## Apple Emulator
(Note: You must be using a device with Mac OS to use the Apple Emulator)

Open the Simulator App (Use spotlight search by pressing CMD + Space)

![image](https://user-images.githubusercontent.com/109327531/231543617-d1378f32-f43b-48bd-a889-1a18078858b0.png)

### Run the app
```bash
flutter run
```

## Browser
### Run the app
```bash
flutter run
```

Enter '2' to run the application on Chrome

![Readme Image 3](https://user-images.githubusercontent.com/109327531/231539434-6437bd7b-4441-4c53-9e22-2ae28fba5741.png)


## Notes
To login as an admin use these credentials - Email: admin@admin.com, Password: admin00. To login regularly, you may create and use your own personal account, or you can use the account we have made for you - Email: profseyed@wayne.edu, Password: Recipeal-CSC4996
