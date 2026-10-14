# SketchQuest – iOS

**An Intelligent Sketch Recognition and Drawing Challenge App**

SE4041 – Mobile Application Design and Development  
Assignment 02 – Part A  
Platform: iOS  
Emerging Technology: Machine Learning (Core ML)

## Project Overview

SketchQuest is an interactive iOS drawing application developed using SwiftUI and Core ML.

Users can create sketches, participate in timed drawing challenges, receive machine learning predictions, earn points, and track their drawing progress.

## Key Features

- Free Draw mode
- Drawing Challenge mode
- AI-assisted sketch recognition using a trained CNN model
- Eight supported drawing categories: Apple, Bicycle, Car, Cat, Fish, House, Star, and Tree
- 30-second drawing challenges
- Points and scoring system
- Drawing history
- Statistics dashboard
- Local data persistence
- Modern SwiftUI navigation and interface

## Machine Learning Implementation

SketchQuest uses a custom Convolutional Neural Network (CNN) trained using sketch images from Google's Quick, Draw! dataset.

The model was converted into Apple's Core ML format and integrated into the iOS application.

**Model Details:**
- Architecture: Convolutional Neural Network
- Input: 64 × 64 RGB image
- Number of Classes: 8
- Frameworks: PyTorch and Core ML
- Best validation accuracy: 93.06%
- Held-out dataset test accuracy: 90.92%

These accuracy values represent the model's recorded dataset evaluation, not a guarantee of recognition accuracy for every user-created sketch.

The integrated model is located at `sketchquest/SketchQuestCNN.mlpackage`.

## Technologies Used

- Swift
- SwiftUI
- Core ML
- PyTorch
- Python
- Xcode
- Git and GitHub

## Installation and Setup

1. Clone or download this repository.
2. Open `sketchquest.xcodeproj` using Xcode on a Mac.
3. Select the application scheme and an iPhone Simulator.
4. Build and run the project.
5. Open Free Draw or Drawing Challenge to test sketch recognition.

The application requires a compatible Xcode and iOS Simulator environment.

## How to Use

1. Launch SketchQuest.
2. Select Free Draw to create a sketch.
3. Submit the sketch for recognition.
4. View the predicted drawing category.
5. Alternatively, select Drawing Challenge.
6. Complete the drawing before the timer expires.
7. Earn points for successful challenges.
8. View saved records and progress through History and Statistics.

## Testing

Manual functional testing was performed using Xcode and an iPhone Simulator.

The following features were tested:

- App launch and navigation
- Drawing canvas interaction
- Sketch submission
- Core ML classification
- Supported drawing categories
- Timed drawing challenges
- Point calculations
- Drawing history
- Statistics and progress tracking

## AI-Assisted Development

ChatGPT was used to assist with SwiftUI implementation, Core ML integration, troubleshooting, testing guidance, and documentation.

AI-assisted development activities will be documented separately in `AI_USAGE.md`.

## Academic Information

Developed for SE4041 – Mobile Application Design and Development, Assignment 02, Part A.

This repository contains the academic project source code and the integrated machine learning model.
