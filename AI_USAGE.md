# AI-Assisted Development Documentation

## Project Information

**Project:** SketchQuest – iOS  
**Module:** SE4041 – Mobile Application Design and Development  
**Assignment:** Assignment 02 – Part A  
**Platform:** iOS  
**Development:** Swift and SwiftUI  
**Emerging Technology:** Machine Learning (Core ML)  
**AI Assistance Tool:** OpenAI ChatGPT

## 1. Purpose of AI Assistance

ChatGPT was used during the development of SketchQuest to support application planning, SwiftUI implementation, machine learning model integration, debugging, testing, and documentation.

The application was developed and manually tested using Xcode and the iOS Simulator.

## 2. Selected AI Interaction Log

The following records summarize key AI-assisted development interactions. They are condensed summaries rather than complete verbatim prompt-and-response transcripts.

### Interaction 01 – Application Planning

**Prompt:** Provide beginner-friendly guidance for developing a SwiftUI drawing recognition application for iOS.

**AI Assistance:** Suggested the initial application structure, navigation flow, and development steps.

**Outcome:** Established the SketchQuest application concept and development plan.

### Interaction 02 – User Interface Development

**Prompt:** Help implement the application's drawing screens, navigation, result screens, history, and statistics.

**AI Assistance:** Provided SwiftUI implementation guidance and code suggestions for the application's interface.

**Outcome:** Implemented the main application screens and navigation.

### Interaction 03 – Machine Learning Training

**Prompt:** Guide the development of a machine learning model capable of recognizing eight hand-drawn object categories.

**AI Assistance:** Explained CNN-based image classification, dataset preparation, model training, and evaluation.

**Outcome:** Trained a custom Convolutional Neural Network using Quick, Draw! sketch data.

### Interaction 04 – Core ML Conversion

**Prompt:** Explain how to convert the trained CNN model into a format compatible with an iOS application.

**AI Assistance:** Provided guidance for converting the PyTorch model into a Core ML package and integrating it with Xcode.

**Outcome:** Integrated `SketchQuestCNN.mlpackage` into the iOS project.

### Interaction 05 – Recognition Troubleshooting

**Prompt:** The Core ML model produces incorrect predictions for some sketches. Help identify and resolve the problem.

**AI Assistance:** Suggested inspecting the image rendering and preprocessing pipeline, including coordinate orientation.

**Outcome:** Adjusted image preprocessing and manually tested recognition across supported categories.

### Interaction 06 – Drawing Challenge

**Prompt:** Help implement a timed drawing challenge with recognition results and a scoring system.

**AI Assistance:** Provided guidance for timer handling, challenge validation, and score calculations.

**Outcome:** Implemented and tested the Drawing Challenge feature.

### Interaction 07 – History and Statistics

**Prompt:** Help implement drawing history, saved results, and a statistics dashboard.

**AI Assistance:** Suggested SwiftUI approaches for presenting stored drawing records and calculated statistics.

**Outcome:** Implemented and manually tested History and Statistics functionality.

### Interaction 08 – Testing and Submission

**Prompt:** Provide instructions for testing the application and preparing the project for GitHub submission.

**AI Assistance:** Suggested functional test scenarios, GitHub repository preparation, README documentation, and project organization.

**Outcome:** Completed manual functional checks and published the Xcode project and Core ML model to GitHub.

## 3. Testing and Validation

The application was manually tested using Xcode and the iPhone Simulator.

Tested functionality included:

- Application launch and navigation
- Free Draw interaction
- Drawing Challenge mode
- Countdown timer
- Core ML sketch prediction
- Correct and incorrect drawing recognition outcomes
- Points calculation
- Drawing History
- Statistics and progress tracking

## 4. Developer Responsibilities

AI assistance provided explanations, implementation suggestions, and troubleshooting support.

The developer integrated the suggested code into the project, performed manual testing, identified issues, and checked application behaviour.

## 5. AI Transparency

ChatGPT was used as a
