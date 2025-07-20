import 'package:flutter/material.dart';

class Region {
  final String id;
  final String name;
  final String code;
  final List<District> districts;
  final List<Board> availableBoards;

  Region({
    required this.id,
    required this.name,
    required this.code,
    required this.districts,
    required this.availableBoards,
  });
}

class District {
  final String id;
  final String name;
  final String regionId;

  District({
    required this.id,
    required this.name,
    required this.regionId,
  });
}

class Board {
  final String id;
  final String name;
  final String type; // CBSE, ICSE, State, Trade
  final List<String> supportedLanguages;
  final List<Class> classes;

  Board({
    required this.id,
    required this.name,
    required this.type,
    required this.supportedLanguages,
    required this.classes,
  });
}

class Class {
  final String id;
  final String name;
  final int grade;
  final List<Subject> subjects;

  Class({
    required this.id,
    required this.name,
    required this.grade,
    required this.subjects,
  });
  }
 
class Subject {
  final String id;
  final String name;
  final String icon;
  final Color color;
  final List<Book> books;
  final String description;

  Subject({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.books,
    required this.description,
  });
}

class Book {
  final String id;
  final String name;
  final String author;
  final String publisher;
  final String thumbnail;
  final List<Chapter> chapters;
  final String classId;
  final String subjectId;

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.publisher,
    required this.thumbnail,
    required this.chapters,
    required this.classId,
    required this.subjectId,
  });
}

class Chapter {
  final String id;
  final String name;
  final String summary;
  final String? videoUrl;
  final List<Quiz> quizzes;
  final List<String> topics;

  Chapter({
    required this.id,
    required this.name,
    required this.summary,
    this.videoUrl,
    required this.quizzes,
    required this.topics,
  });
}

class Quiz {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;

  Quiz({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}

// Sample Data
class SampleData {
  static List<Region> getRegions() {
    return [
      Region(
        id: 'kerala',
        name: 'Kerala',
        code: 'KL',
        districts: [
          District(id: 'ernakulam', name: 'Ernakulam', regionId: 'kerala'),
          District(id: 'thiruvananthapuram', name: 'Thiruvananthapuram', regionId: 'kerala'),
          District(id: 'kozhikode', name: 'Kozhikode', regionId: 'kerala'),
        ],
        availableBoards: [
          Board(
            id: 'cbse',
            name: 'CBSE',
            type: 'National',
            supportedLanguages: ['English', 'Hindi'],
            classes: getCBSEClasses(),
          ),
          Board(
            id: 'kerala_state',
            name: 'Kerala State Board',
            type: 'State',
            supportedLanguages: ['English', 'Malayalam'],
            classes: getKeralaClasses(),
          ),
        ],
      ),
      Region(
        id: 'maharashtra',
        name: 'Maharashtra',
        code: 'MH',
        districts: [
          District(id: 'mumbai', name: 'Mumbai', regionId: 'maharashtra'),
          District(id: 'pune', name: 'Pune', regionId: 'maharashtra'),
          District(id: 'nagpur', name: 'Nagpur', regionId: 'maharashtra'),
        ],
        availableBoards: [
          Board(
            id: 'cbse',
            name: 'CBSE',
            type: 'National',
            supportedLanguages: ['English', 'Hindi'],
            classes: getCBSEClasses(),
          ),
          Board(
            id: 'maharashtra_state',
            name: 'Maharashtra State Board',
            type: 'State',
            supportedLanguages: ['English', 'Marathi'],
            classes: getMaharashtraClasses(),
          ),
        ],
      ),
      Region(
        id: 'uttar_pradesh',
        name: 'Uttar Pradesh',
        code: 'UP',
        districts: [
          District(id: 'lucknow', name: 'Lucknow', regionId: 'uttar_pradesh'),
          District(id: 'kanpur', name: 'Kanpur', regionId: 'uttar_pradesh'),
          District(id: 'varanasi', name: 'Varanasi', regionId: 'uttar_pradesh'),
        ],
        availableBoards: [
          Board(
            id: 'cbse',
            name: 'CBSE',
            type: 'National',
            supportedLanguages: ['English', 'Hindi'],
            classes: getCBSEClasses(),
          ),
          Board(
            id: 'up_state',
            name: 'UP State Board',
            type: 'State',
            supportedLanguages: ['English', 'Hindi'],
            classes: getUPClasses(),
          ),
        ],
      ),
    ];
  }

  static List<Class> getCBSEClasses() {
    return [
      Class(
        id: 'cbse_9',
        name: 'Class 9',
        grade: 9,
        subjects: getCBSE9Subjects(),
      ),
      Class(
        id: 'cbse_10',
        name: 'Class 10',
        grade: 10,
        subjects: getCBSE10Subjects(),
      ),
    ];
  }

  static List<Class> getKeralaClasses() {
    return [
      Class(
        id: 'kerala_9',
        name: 'Class 9',
        grade: 9,
        subjects: getKerala9Subjects(),
      ),
      Class(
        id: 'kerala_10',
        name: 'Class 10',
        grade: 10,
        subjects: getKerala10Subjects(),
      ),
    ];
  }

  static List<Class> getMaharashtraClasses() {
    return [
      Class(
        id: 'maharashtra_9',
        name: 'Class 9',
        grade: 9,
        subjects: getMaharashtra9Subjects(),
      ),
      Class(
        id: 'maharashtra_10',
        name: 'Class 10',
        grade: 10,
        subjects: getMaharashtra10Subjects(),
      ),
    ];
  }

  static List<Class> getUPClasses() {
    return [
      Class(
        id: 'up_9',
        name: 'Class 9',
        grade: 9,
        subjects: getUP9Subjects(),
      ),
      Class(
        id: 'up_10',
        name: 'Class 10',
        grade: 10,
        subjects: getUP10Subjects(),
      ),
    ];
  }

  static List<Subject> getCBSE9Subjects() {
    return [
      Subject(
        id: 'maths',
        name: 'Mathematics',
        icon: '🧮',
        color: Colors.blue,
        description: 'Algebra, Geometry, Statistics',
        books: getMathsBooks('cbse_9'),
      ),
      Subject(
        id: 'science',
        name: 'Science',
        icon: '🔬',
        color: Colors.green,
        description: 'Physics, Chemistry, Biology',
        books: getScienceBooks('cbse_9'),
      ),
      Subject(
        id: 'english',
        name: 'English',
        icon: '📖',
        color: Colors.orange,
        description: 'Literature, Grammar, Writing',
        books: getEnglishBooks('cbse_9'),
      ),
      Subject(
        id: 'social',
        name: 'Social Studies',
        icon: '🌍',
        color: Colors.brown,
        description: 'History, Geography, Civics',
        books: getSocialBooks('cbse_9'),
      ),
    ];
  }

  static List<Subject> getCBSE10Subjects() {
    return [
      Subject(
        id: 'maths',
        name: 'Mathematics',
        icon: '🧮',
        color: Colors.blue,
        description: 'Algebra, Geometry, Trigonometry',
        books: getMathsBooks('cbse_10'),
      ),
      Subject(
        id: 'science',
        name: 'Science',
        icon: '🔬',
        color: Colors.green,
        description: 'Physics, Chemistry, Biology',
        books: getScienceBooks('cbse_10'),
      ),
      Subject(
        id: 'english',
        name: 'English',
        icon: '📖',
        color: Colors.orange,
        description: 'Literature, Grammar, Writing',
        books: getEnglishBooks('cbse_10'),
      ),
      Subject(
        id: 'social',
        name: 'Social Studies',
        icon: '🌍',
        color: Colors.brown,
        description: 'History, Geography, Civics',
        books: getSocialBooks('cbse_10'),
      ),
    ];
  }

  static List<Subject> getKerala9Subjects() {
    return [
      Subject(
        id: 'maths',
        name: 'Mathematics',
        icon: '🧮',
        color: Colors.blue,
        description: 'Algebra, Geometry, Statistics',
        books: getMathsBooks('kerala_9'),
      ),
      Subject(
        id: 'science',
        name: 'Science',
        icon: '🔬',
        color: Colors.green,
        description: 'Physics, Chemistry, Biology',
        books: getScienceBooks('kerala_9'),
      ),
      Subject(
        id: 'malayalam',
        name: 'Malayalam',
        icon: '📖',
        color: Colors.orange,
        description: 'Literature, Grammar, Writing',
        books: getMalayalamBooks('kerala_9'),
      ),
    ];
  }

  static List<Subject> getKerala10Subjects() {
    return [
      Subject(
        id: 'maths',
        name: 'Mathematics',
        icon: '🧮',
        color: Colors.blue,
        description: 'Algebra, Geometry, Trigonometry',
        books: getMathsBooks('kerala_10'),
      ),
      Subject(
        id: 'science',
        name: 'Science',
        icon: '🔬',
        color: Colors.green,
        description: 'Physics, Chemistry, Biology',
        books: getScienceBooks('kerala_10'),
      ),
      Subject(
        id: 'malayalam',
        name: 'Malayalam',
        icon: '📖',
        color: Colors.orange,
        description: 'Literature, Grammar, Writing',
        books: getMalayalamBooks('kerala_10'),
      ),
    ];
  }

  static List<Subject> getMaharashtra9Subjects() {
    return [
      Subject(
        id: 'maths',
        name: 'Mathematics',
        icon: '🧮',
        color: Colors.blue,
        description: 'Algebra, Geometry, Statistics',
        books: getMathsBooks('maharashtra_9'),
      ),
      Subject(
        id: 'science',
        name: 'Science',
        icon: '🔬',
        color: Colors.green,
        description: 'Physics, Chemistry, Biology',
        books: getScienceBooks('maharashtra_9'),
      ),
      Subject(
        id: 'marathi',
        name: 'Marathi',
        icon: '📖',
        color: Colors.orange,
        description: 'Literature, Grammar, Writing',
        books: getMarathiBooks('maharashtra_9'),
      ),
    ];
  }

  static List<Subject> getMaharashtra10Subjects() {
    return [
      Subject(
        id: 'maths',
        name: 'Mathematics',
        icon: '🧮',
        color: Colors.blue,
        description: 'Algebra, Geometry, Trigonometry',
        books: getMathsBooks('maharashtra_10'),
      ),
      Subject(
        id: 'science',
        name: 'Science',
        icon: '🔬',
        color: Colors.green,
        description: 'Physics, Chemistry, Biology',
        books: getScienceBooks('maharashtra_10'),
      ),
      Subject(
        id: 'marathi',
        name: 'Marathi',
        icon: '📖',
        color: Colors.orange,
        description: 'Literature, Grammar, Writing',
        books: getMarathiBooks('maharashtra_10'),
      ),
    ];
  }

  static List<Subject> getUP9Subjects() {
    return [
      Subject(
        id: 'maths',
        name: 'Mathematics',
        icon: '🧮',
        color: Colors.blue,
        description: 'Algebra, Geometry, Statistics',
        books: getMathsBooks('up_9'),
      ),
      Subject(
        id: 'science',
        name: 'Science',
        icon: '🔬',
        color: Colors.green,
        description: 'Physics, Chemistry, Biology',
        books: getScienceBooks('up_9'),
      ),
      Subject(
        id: 'hindi',
        name: 'Hindi',
        icon: '📖',
        color: Colors.orange,
        description: 'Literature, Grammar, Writing',
        books: getHindiBooks('up_9'),
      ),
    ];
  }

  static List<Subject> getUP10Subjects() {
    return [
      Subject(
        id: 'maths',
        name: 'Mathematics',
        icon: '🧮',
        color: Colors.blue,
        description: 'Algebra, Geometry, Trigonometry',
        books: getMathsBooks('up_10'),
      ),
      Subject(
        id: 'science',
        name: 'Science',
        icon: '🔬',
        color: Colors.green,
        description: 'Physics, Chemistry, Biology',
        books: getScienceBooks('up_10'),
      ),
      Subject(
        id: 'hindi',
        name: 'Hindi',
        icon: '📖',
        color: Colors.orange,
        description: 'Literature, Grammar, Writing',
        books: getHindiBooks('up_10'),
      ),
    ];
  }

  static List<Book> getMathsBooks(String classId) {
    return [
      Book(
        id: 'maths_1',
        name: 'Mathematics Textbook',
        author: 'NCERT',
        publisher: 'NCERT',
        thumbnail: 'assets/images/maths_book.png',
        classId: classId,
        subjectId: 'maths',
        chapters: getMathsChapters(),
      ),
    ];
  }

  static List<Book> getScienceBooks(String classId) {
    return [
      Book(
        id: 'science_1',
        name: 'Science Textbook',
        author: 'NCERT',
        publisher: 'NCERT',
        thumbnail: 'assets/images/science_book.png',
        classId: classId,
        subjectId: 'science',
        chapters: getScienceChapters(),
      ),
    ];
  }

  static List<Book> getEnglishBooks(String classId) {
    return [
      Book(
        id: 'english_1',
        name: 'English Textbook',
        author: 'NCERT',
        publisher: 'NCERT',
        thumbnail: 'assets/images/english_book.png',
        classId: classId,
        subjectId: 'english',
        chapters: getEnglishChapters(),
      ),
    ];
  }

  static List<Book> getSocialBooks(String classId) {
    return [
      Book(
        id: 'social_1',
        name: 'Social Studies Textbook',
        author: 'NCERT',
        publisher: 'NCERT',
        thumbnail: 'assets/images/social_book.png',
        classId: classId,
        subjectId: 'social',
        chapters: getSocialChapters(),
      ),
    ];
  }

  static List<Book> getMalayalamBooks(String classId) {
    return [
      Book(
        id: 'malayalam_1',
        name: 'Malayalam Textbook',
        author: 'Kerala State Board',
        publisher: 'Kerala State Board',
        thumbnail: 'assets/images/malayalam_book.png',
        classId: classId,
        subjectId: 'malayalam',
        chapters: getMalayalamChapters(),
      ),
    ];
  }

  static List<Book> getMarathiBooks(String classId) {
    return [
      Book(
        id: 'marathi_1',
        name: 'Marathi Textbook',
        author: 'Maharashtra State Board',
        publisher: 'Maharashtra State Board',
        thumbnail: 'assets/images/marathi_book.png',
        classId: classId,
        subjectId: 'marathi',
        chapters: getMarathiChapters(),
      ),
    ];
  }

  static List<Book> getHindiBooks(String classId) {
    return [
      Book(
        id: 'hindi_1',
        name: 'Hindi Textbook',
        author: 'UP State Board',
        publisher: 'UP State Board',
        thumbnail: 'assets/images/hindi_book.png',
        classId: classId,
        subjectId: 'hindi',
        chapters: getHindiChapters(),
      ),
    ];
  }

  static List<Chapter> getMathsChapters() {
    return [
      Chapter(
        id: 'ch1',
        name: 'Number Systems',
        summary: 'Introduction to real numbers, rational and irrational numbers',
        topics: ['Real Numbers', 'Rational Numbers', 'Irrational Numbers'],
        quizzes: getMathsQuizzes(),
      ),
      Chapter(
        id: 'ch2',
        name: 'Algebra',
        summary: 'Polynomials, linear equations, and quadratic equations',
        topics: ['Polynomials', 'Linear Equations', 'Quadratic Equations'],
        quizzes: getMathsQuizzes(),
      ),
    ];
  }

  static List<Chapter> getScienceChapters() {
    return [
      Chapter(
        id: 'ch1',
        name: 'Matter in Our Surroundings',
        summary: 'Introduction to matter, states of matter, and properties',
        topics: ['Matter', 'States of Matter', 'Properties'],
        quizzes: getScienceQuizzes(),
      ),
      Chapter(
        id: 'ch2',
        name: 'Is Matter Around Us Pure',
        summary: 'Mixtures, solutions, and separation techniques',
        topics: ['Mixtures', 'Solutions', 'Separation Techniques'],
        quizzes: getScienceQuizzes(),
      ),
    ];
  }

  static List<Chapter> getEnglishChapters() {
    return [
      Chapter(
        id: 'ch1',
        name: 'The Fun They Had',
        summary: 'A story about future education and technology',
        topics: ['Reading', 'Comprehension', 'Vocabulary'],
        quizzes: getEnglishQuizzes(),
      ),
      Chapter(
        id: 'ch2',
        name: 'The Road Not Taken',
        summary: 'A poem about choices and decisions in life',
        topics: ['Poetry', 'Literary Devices', 'Theme'],
        quizzes: getEnglishQuizzes(),
      ),
    ];
  }

  static List<Chapter> getSocialChapters() {
    return [
      Chapter(
        id: 'ch1',
        name: 'India - Size and Location',
        summary: 'Geographical features and location of India',
        topics: ['Geography', 'Location', 'Size'],
        quizzes: getSocialQuizzes(),
      ),
      Chapter(
        id: 'ch2',
        name: 'Physical Features of India',
        summary: 'Mountains, plains, and plateaus of India',
        topics: ['Mountains', 'Plains', 'Plateaus'],
        quizzes: getSocialQuizzes(),
      ),
    ];
  }

  static List<Chapter> getMalayalamChapters() {
    return [
      Chapter(
        id: 'ch1',
        name: 'മലയാള സാഹിത്യം',
        summary: 'Introduction to Malayalam literature',
        topics: ['സാഹിത്യം', 'കവിത', 'കഥ'],
        quizzes: getMalayalamQuizzes(),
      ),
    ];
  }

  static List<Chapter> getMarathiChapters() {
    return [
      Chapter(
        id: 'ch1',
        name: 'मराठी साहित्य',
        summary: 'Introduction to Marathi literature',
        topics: ['साहित्य', 'कविता', 'कथा'],
        quizzes: getMarathiQuizzes(),
      ),
    ];
  }

  static List<Chapter> getHindiChapters() {
    return [
      Chapter(
        id: 'ch1',
        name: 'हिंदी साहित्य',
        summary: 'Introduction to Hindi literature',
        topics: ['साहित्य', 'कविता', 'कहानी'],
        quizzes: getHindiQuizzes(),
      ),
    ];
  }

  static List<Quiz> getMathsQuizzes() {
    return [
      Quiz(
        id: 'q1',
        question: 'What is the value of π (pi)?',
        options: ['3.14', '3.141', '3.14159', '3.1415926'],
        correctAnswer: 2,
        explanation: 'π (pi) is approximately 3.14159',
      ),
    ];
  }

  static List<Quiz> getScienceQuizzes() {
    return [
      Quiz(
        id: 'q1',
        question: 'Which state of matter has definite volume but no definite shape?',
        options: ['Solid', 'Liquid', 'Gas', 'Plasma'],
        correctAnswer: 1,
        explanation: 'Liquids have definite volume but take the shape of their container',
      ),
    ];
  }

  static List<Quiz> getEnglishQuizzes() {
    return [
      Quiz(
        id: 'q1',
        question: 'What is a simile?',
        options: ['A comparison using like or as', 'A direct comparison', 'A word that sounds like what it means', 'A type of poem'],
        correctAnswer: 0,
        explanation: 'A simile is a comparison using like or as',
      ),
    ];
  }

  static List<Quiz> getSocialQuizzes() {
    return [
      Quiz(
        id: 'q1',
        question: 'What is the capital of India?',
        options: ['Mumbai', 'Delhi', 'Kolkata', 'Chennai'],
        correctAnswer: 1,
        explanation: 'Delhi is the capital of India',
      ),
    ];
  }

  static List<Quiz> getMalayalamQuizzes() {
    return [
      Quiz(
        id: 'q1',
        question: 'മലയാളത്തിലെ ആദ്യത്തെ കവി ആരാണ്?',
        options: ['കുഞ്ചൻ നമ്പ്യാർ', 'എഴുത്തച്ഛൻ', 'തുഞ്ചത്ത് രാമാനുജൻ', 'ഒട്ടനാർ'],
        correctAnswer: 1,
        explanation: 'എഴുത്തച്ഛൻ മലയാളത്തിലെ ആദ്യത്തെ കവിയാണ്',
      ),
    ];
  }

  static List<Quiz> getMarathiQuizzes() {
    return [
      Quiz(
        id: 'q1',
        question: 'मराठी साहित्यातील पहिला कवी कोण आहे?',
        options: ['संत ज्ञानेश्वर', 'संत तुकाराम', 'संत नामदेव', 'संत एकनाथ'],
        correctAnswer: 0,
        explanation: 'संत ज्ञानेश्वर मराठी साहित्यातील पहिला कवी आहे',
      ),
    ];
  }

  static List<Quiz> getHindiQuizzes() {
    return [
      Quiz(
        id: 'q1',
        question: 'हिंदी साहित्य का जनक किसे माना जाता है?',
        options: ['भारतेन्दु हरिश्चन्द्र', 'महावीर प्रसाद द्विवेदी', 'रामधारी सिंह दिनकर', 'सूर्यकांत त्रिपाठी निराला'],
        correctAnswer: 0,
        explanation: 'भारतेन्दु हरिश्चन्द्र को हिंदी साहित्य का जनक माना जाता है',
      ),
    ];
  }
} 