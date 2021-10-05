# UniLabs Mobile :test_tube:

This is the mobile application for UniLabs Inventory Management System


## Setup Guide :raised_hands:

Make sure you have flutter installed.

```bash
$ git clone https://github.com/UniLabsIMS/UniLabs-APP.git
$ cd UniLabs-APP
```

Intall dependencies

```bash
flutter pub get
```

To run the app, connect the mobile device or open the android emulator and run the following command

```bash
flutter run
```



## Starting a New Feature :hammer_and_wrench:


Checkout main and pull changes

```bash
git checkout main
git pull
```

checkut to a new branch
```bash
git checkout -b feature/<feature_name>
```

install missing dependancies 

```bash
flutter pub get
```
Start and run the app.

```bash
flutter run
```

#### Merging the current branch to master :hammer_and_wrench:

Pull updates your local main branch
```bash
git checkout main
git checkout pull
```

Update the required branch

```bash
git checkout <your_branch>
git merge main
```

Start the app
```bash
flutter run
```
