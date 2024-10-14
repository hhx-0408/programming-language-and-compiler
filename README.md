# **Project README**

## **Team Members**

- **Name**: Huilin Tai, Huixuan Huang
- **UNI**: HT2666, 

*(Add additional team members as necessary.)*

---

## **Table of Contents**

1. [Introduction](#introduction)
2. [Lexical Grammar](#lexical-grammar)
   - [Token Types and Definitions](#token-types-and-definitions)
3. [Installation and Execution](#installation-and-execution)
   - [Prerequisites](#prerequisites)
   - [Installation Steps](#installation-steps)
   - [Execution](#execution)
4. [Detailed Description of Each Step](#detailed-description-of-each-step)
   - [Scanner Algorithm](#scanner-algorithm)
   - [State Transitions with Finite Automata](#state-transitions-with-finite-automata)
   - [Error Handling](#error-handling)
5. [Sample Input Programs and Expected Outputs](#sample-input-programs-and-expected-outputs)
   - [Program 1](#program-1)
   - [Program 2](#program-2)
   - [Program 3](#program-3)
   - [Program 4](#program-4)
   - [Program 5](#program-5)
6. [Conclusion](#conclusion)

---

## **Introduction**

This project involves creating a lexer (scanner) for a custom programming language designed for musical notation and playback commands. The lexer reads source code written in this language and outputs a list of tokens, showing state transitions using finite automata. It also handles lexical errors appropriately.

---

## **Lexical Grammar**

### **Token Types and Definitions**

Our language consists of the following token types:

1. **Keywords**: Reserved words that have special meaning in the language.

   - **Definition**: Specific strings that represent commands or declarations.
   - **Tokens**: `instrument`, `bpm`, `play`, `repeat`, `end`, `title`, `composer`
   - **Regex**: `instrument|bpm|play|repeat|end|title|composer`

2. **Identifiers**: Names defined by the user for variables or other entities.

   - **Definition**: A sequence starting with a letter, followed by letters, digits, or underscores.
   - **Regex**: `[a-zA-Z][a-zA-Z0-9_]*`

3. **Operators**: Symbols that perform operations.

   - **Definition**: Characters like `=` or `:`.
   - **Tokens**: `=`, `:`
   - **Regex**: `=|:`

4. **Numbers**: Numeric literals representing integer values.

   - **Definition**: One or more digits.
   - **Regex**: `[0-9]+`

5. **String Literals**: Text enclosed in double quotes.

   - **Definition**: A sequence of characters enclosed in `" "`.
   - **Regex**: `\"[^\n\r\"]*\"`

6. **Music Notes**: Special tokens representing musical notes.

   - **Definition**: A sequence of two letters (solfege), a digit (octave), and an accidental symbol.
   - **Solfege**: `do`, `re`, `mi`, `fa`, `so`, `la`, `ti`
   - **Accidentals**: `#` (sharp), `-` (natural), `_` (flat)
   - **Regex**: `(do|re|mi|fa|so|la|ti)[0-7](#|-|_)`

7. **Durations**: Tokens representing note durations.

   - **Definition**: Specific strings indicating length of notes.
   - **Tokens**: `whole`, `half`, `quarter`, `eighth`, `sixteenth`
   - **Regex**: `whole|half|quarter|eighth|sixteenth`

8. **Punctuation**: Symbols that separate statements or elements.

   - **Tokens**:
     - **Left Parenthesis**: `(`
     - **Right Parenthesis**: `)`
     - **Semicolon**: `;`
     - **Comma**: `,`
   - **Regex**: `\(|\)|;|,`

### **Summary of Tokens**

| Token Type     | Example       | Description                               |
|----------------|---------------|-------------------------------------------|
| KEYWORD        | `play`        | Reserved words                            |
| IDENTIFIER     | `melody1`     | User-defined names                        |
| OPERATOR       | `=`           | Assignment or other operations            |
| NUMBER         | `120`         | Numeric literals                          |
| STRING_LITERAL | `"Hello"`     | Text enclosed in double quotes            |
| MUSICNOTE      | `Do5#`        | Musical note notation                     |
| DURATION       | `quarter`     | Note durations                            |
| LPAREN         | `(`           | Left parenthesis                          |
| RPAREN         | `)`           | Right parenthesis                         |
| SEMICOLON      | `;`           | Statement terminator                      |
| COMMA          | `,`           | Separator                                 |

---

## **Installation and Execution**

### **Prerequisites**

- **OCaml Compiler**: Ensure that the OCaml compiler (`ocamlc`) is installed on your system.

  - **Installation on Ubuntu/Debian**:
    ```bash
    sudo apt-get install ocaml
    ```

  - **Installation on macOS (using Homebrew)**:
    ```bash
    brew install ocaml
    ```

### **Installation Steps**

1. **Clone the Repository**: Download or clone the project files to your local machine.

2. **Make the Script Executable**: Ensure the `install_and_run.sh` script has execute permissions.

   ```bash
   chmod +x install_and_run.sh
   ```

### **Execution**

Run the lexer using the provided shell script:

```bash
./install_and_run.sh <input_file>
```

- Replace `<input_file>` with the path to one of the sample input programs or your own source code file.

**Example**:

```bash
./install_and_run.sh Program1.txt
```

---

## **Detailed Description of Each Step**

### **Scanner Algorithm**

The scanner reads the input source code character by character and tokenizes it based on the defined lexical grammar. It uses explicit state transitions to model a finite automaton for each token type.

- **Character Classification**: The scanner classifies each character using helper functions:
  - `is_letter`
  - `is_digit`
  - `is_whitespace`
  - `is_accidental`
  - `is_identifier_char`

- **Token Recognition**:
  - **Keywords and Identifiers**: Starts with a letter, followed by letters, digits, or underscores.
  - **Music Notes**: Specific sequence matching solfege, octave, and accidental.
  - **Numbers**: One or more digits.
  - **String Literals**: Text enclosed in double quotes.
  - **Operators and Punctuation**: Single characters like `=`, `:`, `;`, etc.

- **Lexing Functions**:
  - `match_keyword`: Determines if a word is a keyword.
  - `match_music_note`: Matches and validates music notes using state transitions.
  - `read_identifier`: Reads identifiers.
  - `read_number`: Reads numeric literals.
  - `read_string_literal`: Reads string literals, handling unterminated strings.

### **State Transitions with Finite Automata**

The lexer models finite automata for complex tokens, such as music notes and string literals.

#### **Music Note Automaton**

- **State 0**: Expecting first letter of solfege.
  - Transition to State 1 if a letter is found.
- **State 1**: Expecting second letter of solfege.
  - Transition to State 2 if a letter is found.
- **State 2**: Expecting a digit for octave (0-7).
  - Transition to State 3 if a digit is found.
- **State 3**: Expecting an accidental (`#`, `-`, `_`).
  - Accept token if an accidental is found.
- **Error States**: If any expected character is not found, the lexer resets to the starting position and raises an error or treats the sequence as an identifier.

#### **String Literal Automaton**

- **State 0**: Expecting opening quote (`"`).
  - Transition to State 1 upon finding `"`.
- **State 1**: Reading characters until closing quote.
  - Remain in State 1 for any character except `"` or newline.
  - Transition to Accepting State upon finding closing `"`.
  - Transition to Error State if newline or end of file is encountered without closing `"`.

### **Error Handling**

The lexer handles lexical errors by raising exceptions with descriptive messages:

- **Unterminated String Literals**: If a string literal is not closed before the end of line or file.
- **Invalid Characters**: Characters that do not belong to any token class.
- **Invalid Music Notes**: Incorrect format or invalid solfege names.

Errors are caught in the `main.ml` file and displayed to the user.

---

## **Sample Input Programs and Expected Outputs**

### **Program 1**

**File**: `Program1.txt`

**Content**:

```plaintext
title "Ode to Joy";
composer "Beethoven";
instrument piano;
bpm 120;
play Do5#;
end
```

**Description**: This program sets up basic information and plays a single note.

**Expected Output**:

```plaintext
<KEYWORD, "title">
<STRING_LITERAL, "Ode to Joy">
<SEMICOLON, ";">
<KEYWORD, "composer">
<STRING_LITERAL, "Beethoven">
<SEMICOLON, ";">
<KEYWORD, "instrument">
<IDENTIFIER, "piano">
<SEMICOLON, ";">
<KEYWORD, "bpm">
<NUMBER, "120">
<SEMICOLON, ";">
<KEYWORD, "play">
<MUSICNOTE, "Do5#">
<SEMICOLON, ";">
<KEYWORD, "end">
```

### **Program 2**

**File**: `Program2.txt`

**Content**:

```plaintext
title "Fur Elise";
composer "Beethoven";
instrument piano;
bpm 100;
play Mi5_ Fa5_ Mi5_ Re5_ Do5_ Re5_ Mi5_;
end
```

**Description**: Demonstrates playing a sequence of notes.

**Expected Output**:

- Tokens for each keyword, string literal, identifier, number, music note, and punctuation.

### **Program 3**

**File**: `Program3.txt`

**Content**:

```plaintext
title "Invalid Note Test";
composer "Tester";
instrument violin;
bpm 90;
play Do9#;
end
```

**Description**: Tests error handling with an invalid music note (octave `9` is out of range).

**Expected Output**:

```plaintext
LexingError: Invalid music note at position X
```

### **Program 4**

**File**: `Program4.txt`

**Content**:

```plaintext
title "Unterminated String
composer "Test";
```

**Description**: Tests error handling with an unterminated string literal.

**Expected Output**:

```plaintext
LexingError: String literal not terminated before end of line
```

### **Program 5**

**File**: `Program5.txt`

**Content**:

```plaintext
title "Special Character Test";
composer "Test@Composer";
```

**Description**: Tests error handling with invalid characters in identifiers.

**Expected Output**:

```plaintext
LexingError: Invalid character '@' at position X
```

---

## **Conclusion**

This project successfully implements a lexer for a custom programming language focused on musical notation. The lexer reads input files, tokenizes the content based on defined lexical grammar, shows state transitions using finite automata, and handles lexical errors appropriately.

By following the instructions in this README, you can compile and run the lexer on provided sample programs or your own source code written in the language.

---

**Note**: Replace `[Your Name]` and `[Your UNI]` with your actual name and University Network ID. If you have team members, list their names and UNIs as well.
