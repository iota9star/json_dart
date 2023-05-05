// Generated from JSON.g4 by ANTLR 4.12.0
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'JSONVisitor.dart';
import 'JSONBaseVisitor.dart';
const int RULE_json = 0, RULE_object = 1, RULE_pair = 2, RULE_array = 3, 
          RULE_value = 4, RULE_string = 5, RULE_number = 6, RULE_bool = 7, 
          RULE_null = 8;
class JSONParser extends Parser {
  static final checkVersion = () => RuntimeMetaData.checkVersion('4.12.0', RuntimeMetaData.VERSION);
  static const int TOKEN_EOF = IntStream.EOF;

  static final List<DFA> _decisionToDFA = List.generate(
      _ATN.numberOfDecisions, (i) => DFA(_ATN.getDecisionState(i), i));
  static final PredictionContextCache _sharedContextCache = PredictionContextCache();
  static const int TOKEN_T__0 = 1, TOKEN_T__1 = 2, TOKEN_T__2 = 3, TOKEN_T__3 = 4, 
                   TOKEN_T__4 = 5, TOKEN_T__5 = 6, TOKEN_T__6 = 7, TOKEN_T__7 = 8, 
                   TOKEN_T__8 = 9, TOKEN_STRING = 10, TOKEN_NUMBER = 11, 
                   TOKEN_WS = 12;

  @override
  final List<String> ruleNames = [
    'json', 'object', 'pair', 'array', 'value', 'string', 'number', 'bool', 
    'null'
  ];

  static final List<String?> _LITERAL_NAMES = [
      null, "'{'", "','", "'}'", "':'", "'['", "']'", "'true'", "'false'", 
      "'null'"
  ];
  static final List<String?> _SYMBOLIC_NAMES = [
      null, null, null, null, null, null, null, null, null, null, "STRING", 
      "NUMBER", "WS"
  ];
  static final Vocabulary VOCABULARY = VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

  @override
  Vocabulary get vocabulary {
    return VOCABULARY;
  }

  @override
  String get grammarFileName => 'JSON.g4';

  @override
  List<int> get serializedATN => _serializedATN;

  @override
  ATN getATN() {
   return _ATN;
  }

  JSONParser(TokenStream input) : super(input) {
    interpreter = ParserATNSimulator(this, _ATN, _decisionToDFA, _sharedContextCache);
  }

  JsonContext json() {
    dynamic _localctx = JsonContext(context, state);
    enterRule(_localctx, 0, RULE_json);
    try {
      enterOuterAlt(_localctx, 1);
      state = 18;
      value();
      state = 19;
      match(TOKEN_EOF);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ObjectContext object() {
    dynamic _localctx = ObjectContext(context, state);
    enterRule(_localctx, 2, RULE_object);
    int _la;
    try {
      state = 34;
      errorHandler.sync(this);
      switch (interpreter!.adaptivePredict(tokenStream, 1, context)) {
      case 1:
        enterOuterAlt(_localctx, 1);
        state = 21;
        match(TOKEN_T__0);
        state = 22;
        pair();
        state = 27;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
        while (_la == TOKEN_T__1) {
          state = 23;
          match(TOKEN_T__1);
          state = 24;
          pair();
          state = 29;
          errorHandler.sync(this);
          _la = tokenStream.LA(1)!;
        }
        state = 30;
        match(TOKEN_T__2);
        break;
      case 2:
        enterOuterAlt(_localctx, 2);
        state = 32;
        match(TOKEN_T__0);
        state = 33;
        match(TOKEN_T__2);
        break;
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  PairContext pair() {
    dynamic _localctx = PairContext(context, state);
    enterRule(_localctx, 4, RULE_pair);
    try {
      enterOuterAlt(_localctx, 1);
      state = 36;
      match(TOKEN_STRING);
      state = 37;
      match(TOKEN_T__3);
      state = 38;
      value();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ArrayContext array() {
    dynamic _localctx = ArrayContext(context, state);
    enterRule(_localctx, 6, RULE_array);
    int _la;
    try {
      state = 53;
      errorHandler.sync(this);
      switch (interpreter!.adaptivePredict(tokenStream, 3, context)) {
      case 1:
        enterOuterAlt(_localctx, 1);
        state = 40;
        match(TOKEN_T__4);
        state = 41;
        value();
        state = 46;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
        while (_la == TOKEN_T__1) {
          state = 42;
          match(TOKEN_T__1);
          state = 43;
          value();
          state = 48;
          errorHandler.sync(this);
          _la = tokenStream.LA(1)!;
        }
        state = 49;
        match(TOKEN_T__5);
        break;
      case 2:
        enterOuterAlt(_localctx, 2);
        state = 51;
        match(TOKEN_T__4);
        state = 52;
        match(TOKEN_T__5);
        break;
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ValueContext value() {
    dynamic _localctx = ValueContext(context, state);
    enterRule(_localctx, 8, RULE_value);
    try {
      state = 61;
      errorHandler.sync(this);
      switch (tokenStream.LA(1)!) {
      case TOKEN_STRING:
        enterOuterAlt(_localctx, 1);
        state = 55;
        string();
        break;
      case TOKEN_NUMBER:
        enterOuterAlt(_localctx, 2);
        state = 56;
        number();
        break;
      case TOKEN_T__0:
        enterOuterAlt(_localctx, 3);
        state = 57;
        object();
        break;
      case TOKEN_T__4:
        enterOuterAlt(_localctx, 4);
        state = 58;
        array();
        break;
      case TOKEN_T__6:
      case TOKEN_T__7:
        enterOuterAlt(_localctx, 5);
        state = 59;
        bool();
        break;
      case TOKEN_T__8:
        enterOuterAlt(_localctx, 6);
        state = 60;
        null_();
        break;
      default:
        throw NoViableAltException(this);
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  StringContext string() {
    dynamic _localctx = StringContext(context, state);
    enterRule(_localctx, 10, RULE_string);
    try {
      enterOuterAlt(_localctx, 1);
      state = 63;
      match(TOKEN_STRING);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  NumberContext number() {
    dynamic _localctx = NumberContext(context, state);
    enterRule(_localctx, 12, RULE_number);
    try {
      enterOuterAlt(_localctx, 1);
      state = 65;
      match(TOKEN_NUMBER);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  BoolContext bool() {
    dynamic _localctx = BoolContext(context, state);
    enterRule(_localctx, 14, RULE_bool);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 67;
      _la = tokenStream.LA(1)!;
      if (!(_la == TOKEN_T__6 || _la == TOKEN_T__7)) {
      errorHandler.recoverInline(this);
      } else {
        if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
        errorHandler.reportMatch(this);
        consume();
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  NullContext null_() {
    dynamic _localctx = NullContext(context, state);
    enterRule(_localctx, 16, RULE_null);
    try {
      enterOuterAlt(_localctx, 1);
      state = 69;
      match(TOKEN_T__8);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  static const List<int> _serializedATN = [
      4,1,12,72,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,6,
      2,7,7,7,2,8,7,8,1,0,1,0,1,0,1,1,1,1,1,1,1,1,5,1,26,8,1,10,1,12,1,29,
      9,1,1,1,1,1,1,1,1,1,3,1,35,8,1,1,2,1,2,1,2,1,2,1,3,1,3,1,3,1,3,5,3,
      45,8,3,10,3,12,3,48,9,3,1,3,1,3,1,3,1,3,3,3,54,8,3,1,4,1,4,1,4,1,4,
      1,4,1,4,3,4,62,8,4,1,5,1,5,1,6,1,6,1,7,1,7,1,8,1,8,1,8,0,0,9,0,2,4,
      6,8,10,12,14,16,0,1,1,0,7,8,71,0,18,1,0,0,0,2,34,1,0,0,0,4,36,1,0,
      0,0,6,53,1,0,0,0,8,61,1,0,0,0,10,63,1,0,0,0,12,65,1,0,0,0,14,67,1,
      0,0,0,16,69,1,0,0,0,18,19,3,8,4,0,19,20,5,0,0,1,20,1,1,0,0,0,21,22,
      5,1,0,0,22,27,3,4,2,0,23,24,5,2,0,0,24,26,3,4,2,0,25,23,1,0,0,0,26,
      29,1,0,0,0,27,25,1,0,0,0,27,28,1,0,0,0,28,30,1,0,0,0,29,27,1,0,0,0,
      30,31,5,3,0,0,31,35,1,0,0,0,32,33,5,1,0,0,33,35,5,3,0,0,34,21,1,0,
      0,0,34,32,1,0,0,0,35,3,1,0,0,0,36,37,5,10,0,0,37,38,5,4,0,0,38,39,
      3,8,4,0,39,5,1,0,0,0,40,41,5,5,0,0,41,46,3,8,4,0,42,43,5,2,0,0,43,
      45,3,8,4,0,44,42,1,0,0,0,45,48,1,0,0,0,46,44,1,0,0,0,46,47,1,0,0,0,
      47,49,1,0,0,0,48,46,1,0,0,0,49,50,5,6,0,0,50,54,1,0,0,0,51,52,5,5,
      0,0,52,54,5,6,0,0,53,40,1,0,0,0,53,51,1,0,0,0,54,7,1,0,0,0,55,62,3,
      10,5,0,56,62,3,12,6,0,57,62,3,2,1,0,58,62,3,6,3,0,59,62,3,14,7,0,60,
      62,3,16,8,0,61,55,1,0,0,0,61,56,1,0,0,0,61,57,1,0,0,0,61,58,1,0,0,
      0,61,59,1,0,0,0,61,60,1,0,0,0,62,9,1,0,0,0,63,64,5,10,0,0,64,11,1,
      0,0,0,65,66,5,11,0,0,66,13,1,0,0,0,67,68,7,0,0,0,68,15,1,0,0,0,69,
      70,5,9,0,0,70,17,1,0,0,0,5,27,34,46,53,61
  ];

  static final ATN _ATN =
      ATNDeserializer().deserialize(_serializedATN);
}
class JsonContext extends ParserRuleContext {
  ValueContext? value() => getRuleContext<ValueContext>(0);
  TerminalNode? EOF() => getToken(JSONParser.TOKEN_EOF, 0);
  JsonContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_json;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is JSONVisitor<T>) {
     return visitor.visitJson(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ObjectContext extends ParserRuleContext {
  List<PairContext> pairs() => getRuleContexts<PairContext>();
  PairContext? pair(int i) => getRuleContext<PairContext>(i);
  ObjectContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_object;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is JSONVisitor<T>) {
     return visitor.visitObject(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class PairContext extends ParserRuleContext {
  TerminalNode? STRING() => getToken(JSONParser.TOKEN_STRING, 0);
  ValueContext? value() => getRuleContext<ValueContext>(0);
  PairContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_pair;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is JSONVisitor<T>) {
     return visitor.visitPair(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ArrayContext extends ParserRuleContext {
  List<ValueContext> values() => getRuleContexts<ValueContext>();
  ValueContext? value(int i) => getRuleContext<ValueContext>(i);
  ArrayContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_array;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is JSONVisitor<T>) {
     return visitor.visitArray(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ValueContext extends ParserRuleContext {
  StringContext? string() => getRuleContext<StringContext>(0);
  NumberContext? number() => getRuleContext<NumberContext>(0);
  ObjectContext? object() => getRuleContext<ObjectContext>(0);
  ArrayContext? array() => getRuleContext<ArrayContext>(0);
  BoolContext? bool() => getRuleContext<BoolContext>(0);
  NullContext? null_() => getRuleContext<NullContext>(0);
  ValueContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_value;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is JSONVisitor<T>) {
     return visitor.visitValue(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class StringContext extends ParserRuleContext {
  TerminalNode? STRING() => getToken(JSONParser.TOKEN_STRING, 0);
  StringContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_string;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is JSONVisitor<T>) {
     return visitor.visitString(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class NumberContext extends ParserRuleContext {
  TerminalNode? NUMBER() => getToken(JSONParser.TOKEN_NUMBER, 0);
  NumberContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_number;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is JSONVisitor<T>) {
     return visitor.visitNumber(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class BoolContext extends ParserRuleContext {
  BoolContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_bool;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is JSONVisitor<T>) {
     return visitor.visitBool(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class NullContext extends ParserRuleContext {
  NullContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_null;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is JSONVisitor<T>) {
     return visitor.visitNull(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

