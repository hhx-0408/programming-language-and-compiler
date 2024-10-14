 
# **Project README**

## **Team Members**

- **Name**: Huilin Tai, Huixuan Huang
- **UNI**: HT2666, [Add others if applicable]

---

## **Table of Contents**

1. [Introduction](#introduction)
2. [Language Structure](#language-structure)
3. [Lexical Grammar](#lexical-grammar)
   - [Token Types and Definitions](#token-types-and-definitions)
4. [Installation and Execution](#installation-and-execution)
   - [Prerequisites](#prerequisites)
   - [Installation Steps](#installation-steps)
   - [Execution](#execution)
5. [Detailed Description of Each Step](#detailed-description-of-each-step)
   - [Scanner Algorithm](#scanner-algorithm)
   - [State Transitions with Finite Automata](#state-transitions-with-finite-automata)
   - [Error Handling](#error-handling)
6. [Sample Input Programs and Expected Outputs](#sample-input-programs-and-expected-outputs)
   - [Program 1](#program-1)
   - [Program 2](#program-2)
   - [Program 3](#program-3)
   - [Program 4](#program-4)
   - [Program 5](#program-5)
7. [Conclusion](#conclusion)

---

## **Introduction**

This project involves creating a lexer (scanner) for a custom programming language designed for musical notation and playback commands. The lexer reads source code written in this language and outputs a list of tokens, showing state transitions using finite automata. It also handles lexical errors appropriately, highlighting where issues in the input occur.

---

## **Language Structure**

Our custom language is designed for music composition and playback commands. It allows users to declare instruments, beats per minute (BPM), composers, and titles, and specify music notes with their corresponding durations.

### **Key Constructs**:
1. **Instrument Declaration**: Specifies the instrument used, such as `Piano` or `Violin`.
   
   ```plaintext
   INSTRUMENT = Piano;
   ```

2. **BPM Declaration**: Sets the beats per minute for the music playback.
   
   ```plaintext
   BPM = 120;
   ```

3. **Composer and Title Declaration**: Allows the user to assign a title and a composer name for the piece.
   
   ```plaintext
   TITLE = "Symphony No. 5";
   COMPOSER = "Ludwig van Beethoven";
   ```

4. **Play Command**: Defines the notes to be played along with their duration. A note consists of a solfege syllable (e.g., `Do`, `Re`), an octave (0-7), and an optional accidental (`#`, `-`, `_`).

   ```plaintext
   PLAY Do4# quarter;
   ```

5. **Music Notes**: Music notes are expressed in solfege notation (e.g., `Do`, `Re`, `Mi`), followed by an octave number (e.g., `4` for middle octave), and an accidental (`#` for sharp, `-` for natural, `_` for flat).

6. **End Command**: Marks the end of the music declaration.
   
   ```plaintext
   END;
   ```

---

## **Lexical Grammar**

### **Token Types and Definitions**

Our language consists of the following token types:

1. **Keywords**: Reserved words with special meaning, such as commands for setting the instrument, BPM, title, composer, and playing notes.

   - **Tokens**: `INSTRUMENT`, `BPM`, `PLAY`, `TITLE`, `COMPOSER`, `END`
   - **Regex**: `instrument|bpm|play|end|title|composer`

2. **Identifiers**: User-defined variable names like the instrument name.

   - **Regex**: `[a-zA-Z][a-zA-Z0-9_]*`

3. **Operators**: Used for assignments, including `=`.

   - **Regex**: `=`

4. **Numbers**: Represent integer values, such as BPM or the octave of a note.

   - **Regex**: `[0-9]+`

5. **String Literals**: Text enclosed in double quotes, such as a composer’s name.

   - **Regex**: `\"[^\n\r\"]*\"`

6. **Music Notes**: Music notes consist of a solfege syllable (e.g., `Do`, `Re`), followed by an octave number, and an optional accidental (`#`, `-`, `_`).

   - **Regex**: `(do|re|mi|fa|so|la|ti)[0-7](#|-|_)`

7. **Durations**: Indicate how long a note is held, such as `quarter`, `half`, `whole`.

   - **Regex**: `whole|half|quarter|eighth|sixteenth`

8. **Punctuation**: Characters that separate statements or commands.

   - **Tokens**: `(`, `)`, `;`, `,`
   - **Regex**: `\(|\)|;|,`

### **Summary of Tokens**

| Token Type     | Example       | Description                               |
|----------------|---------------|-------------------------------------------|
| KEYWORD        | `play`        | Reserved words                            |
| IDENTIFIER     | `Piano`       | User-defined names                        |
| OPERATOR       | `=`           | Assignment operator                       |
| NUMBER         | `120`         | Numeric literals                          |
| STRING_LITERAL | `"Beethoven"` | Text enclosed in double quotes            |
| MUSICNOTE      | `Do5#`        | Music note notation                       |
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

### **State Transitions with Finite Automata**

The lexer models finite automata for complex tokens, such as music notes and string literals. Each token type is processed by transitioning between states. If a character does not match the expected token pattern, the lexer raises a `LexingError`.

---

## **Sample Input Programs and Expected Outputs**

### **Program 1**

**File**: `Program1.txt`

**Content**:

```plaintext
INSTRUMENT = Piano;
BPM = 120;
PLAY Do4# quarter;
END;
```

**Description**: This basic program sets the instrument to Piano, BPM to 120, and plays a `Do4#` note for a `quarter` duration.

**Expected Output**:

```plaintext
<KEYWORD, "INSTRUMENT">
<OPERATOR, "=">
<IDENTIFIER, "Piano">
<SEMICOLON, ";">
<KEYWORD, "BPM">
<OPERATOR, "=">
<NUMBER, "120">
<SEMICOLON, ";">
<KEYWORD, "PLAY">
<MUSICNOTE, "Do4#">
<DURATION, "quarter">
<SEMICOLON, ";">
<KEYWORD, "END">
<SEMICOLON, ";">
```

---

### **Program 2**

**File**: `Program2.txt`

**Content**:

```plaintext
INSTRUMENT = Violin;
BPM = 100;
PLAY Mi5_ Fa5_ Mi5_ Re5_ Do5_ Re5_ Mi5_;
END;
```

**Description**: This program plays a sequence of music notes on a violin at 100 BPM.

**Expected Output**:

```plaintext
<KEYWORD, "INSTRUMENT">
<OPERATOR, "=">
<IDENTIFIER, "Violin">
<SEMICOLON, ";">
<KEYWORD, "BPM">
<OPERATOR, "=">
<NUMBER, "100">
<SEMICOLON, ";">
<KEYWORD, "PLAY">
<MUSICNOTE, "Mi5_">
<MUSICNOTE, "Fa5_">
<M

USICNOTE, "Mi5_">
<MUSICNOTE, "Re5_">
<MUSICNOTE, "Do5_">
<MUSICNOTE, "Re5_">
<MUSICNOTE, "Mi5_">
<SEMICOLON, ";">
<KEYWORD, "END">
<SEMICOLON, ";">
```

---

### **Program 3**

**File**: `Program3.txt`

**Content**:

```plaintext
do4_ la4- mi3#;
mynameis###,
mi3#,,,
"365^&*()",
Do3
```

**Description**: This program includes invalid characters such as `#` in an identifier and special characters in string literals.

**Expected Output**:

```plaintext
LexingError: Invalid character '#' at position 25
```

---

### **Program 4**

**File**: `Program4.txt`

**Content**:

```plaintext
do3#
*}{INSTRUMENT = Piano;
BPM = 120;
COMPOSER = "Ludwig van Beethoven";
TITLE = "Symphony No. 5";
PLAY Do4# quarter;
END;
```

**Description**: This program includes invalid syntax and characters (`*`), testing the lexer’s error handling capabilities.

**Expected Output**:

```plaintext
LexingError: Invalid character '*' at position 65
```

---

### **Program 5**

**File**: `Program5.txt`

**Content**:

```plaintext
INSTRUMENT = Piano;
BPM = 120;
COMPOSER = "Ludwig van Beethoven";
TITLE = "Symphony No. 5";
PLAY Do4# quarter;
END;
```

**Description**: A well-formed program that sets up a musical piece with uppercase keywords and plays a note.

**Expected Output**:

```plaintext
<KEYWORD, "INSTRUMENT">
<OPERATOR, "=">
<IDENTIFIER, "Piano">
<SEMICOLON, ";">
<KEYWORD, "BPM">
<OPERATOR, "=">
<NUMBER, "120">
<SEMICOLON, ";">
<KEYWORD, "COMPOSER">
<OPERATOR, "=">
<STRING_LITERAL, "Ludwig van Beethoven">
<SEMICOLON, ";">
<KEYWORD, "TITLE">
<OPERATOR, "=">
<STRING_LITERAL, "Symphony No. 5">
<SEMICOLON, ";">
<KEYWORD, "PLAY">
<MUSICNOTE, "Do4#">
<DURATION, "quarter">
<SEMICOLON, ";">
<KEYWORD, "END">
<SEMICOLON, ";">
```

---

## **Conclusion**

This project successfully implements a lexer for a custom programming language focused on musical notation. The lexer reads input files, tokenizes the content based on defined lexical grammar, shows state transitions using finite automata, and handles lexical errors appropriately.

By following the instructions in this README, you can compile and run the lexer on provided sample programs or your own source code written in the language.

---
 
