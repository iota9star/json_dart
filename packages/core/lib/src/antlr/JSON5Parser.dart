// Generated from JSON5.g4 by ANTLR 4.12.0
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'JSON5Visitor.dart';
import 'JSON5BaseVisitor.dart';
const int RULE_json5 = 0, RULE_object = 1, RULE_pair = 2, RULE_key = 3, 
          RULE_value = 4, RULE_array = 5, RULE_string = 6, RULE_bool = 7, 
          RULE_null = 8, RULE_number = 9;
class JSON5Parser extends Parser {
  static final checkVersion = () => RuntimeMetaData.checkVersion('4.12.0', RuntimeMetaData.VERSION);
  static const int TOKEN_EOF = IntStream.EOF;

  static final List<DFA> _decisionToDFA = List.generate(
      _ATN.numberOfDecisions, (i) => DFA(_ATN.getDecisionState(i), i));
  static final PredictionContextCache _sharedContextCache = PredictionContextCache();
  static const int TOKEN_T__0 = 1, TOKEN_T__1 = 2, TOKEN_T__2 = 3, TOKEN_T__3 = 4, 
                   TOKEN_T__4 = 5, TOKEN_T__5 = 6, TOKEN_T__6 = 7, TOKEN_T__7 = 8, 
                   TOKEN_T__8 = 9, TOKEN_SINGLE_LINE_COMMENT = 10, TOKEN_MULTI_LINE_COMMENT = 11, 
                   TOKEN_LITERAL = 12, TOKEN_STRING = 13, TOKEN_NUMBER = 14, 
                   TOKEN_NUMERIC_LITERAL = 15, TOKEN_SYMBOL = 16, TOKEN_IDENTIFIER = 17, 
                   TOKEN_WS = 18;

  @override
  final List<String> ruleNames = [
    'json5', 'object', 'pair', 'key', 'value', 'array', 'string', 'bool', 
    'null', 'number'
  ];

  static final List<String?> _LITERAL_NAMES = [
      null, "'{'", "','", "'}'", "':'", "'['", "']'", "'true'", "'false'", 
      "'null'"
  ];
  static final List<String?> _SYMBOLIC_NAMES = [
      null, null, null, null, null, null, null, null, null, null, "SINGLE_LINE_COMMENT", 
      "MULTI_LINE_COMMENT", "LITERAL", "STRING", "NUMBER", "NUMERIC_LITERAL", 
      "SYMBOL", "IDENTIFIER", "WS"
  ];
  static final Vocabulary VOCABULARY = VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

  @override
  Vocabulary get vocabulary {
    return VOCABULARY;
  }

  @override
  String get grammarFileName => 'JSON5.g4';

  @override
  List<int> get serializedATN => _serializedATN;

  @override
  ATN getATN() {
   return _ATN;
  }

  JSON5Parser(TokenStream input) : super(input) {
    interpreter = ParserATNSimulator(this, _ATN, _decisionToDFA, _sharedContextCache);
  }

  Json5Context json5() {
    dynamic _localctx = Json5Context(context, state);
    enterRule(_localctx, 0, RULE_json5);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 21;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if ((((_la) & ~0x3f) == 0 && ((1 << _la) & 123810) != 0)) {
        state = 20;
        value();
      }

      state = 23;
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
      int _alt;
      state = 41;
      errorHandler.sync(this);
      switch (interpreter!.adaptivePredict(tokenStream, 3, context)) {
      case 1:
        enterOuterAlt(_localctx, 1);
        state = 25;
        match(TOKEN_T__0);
        state = 26;
        pair();
        state = 31;
        errorHandler.sync(this);
        _alt = interpreter!.adaptivePredict(tokenStream, 1, context);
        while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
          if (_alt == 1) {
            state = 27;
            match(TOKEN_T__1);
            state = 28;
            pair(); 
          }
          state = 33;
          errorHandler.sync(this);
          _alt = interpreter!.adaptivePredict(tokenStream, 1, context);
        }
        state = 35;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
        if (_la == TOKEN_T__1) {
          state = 34;
          match(TOKEN_T__1);
        }

        state = 37;
        match(TOKEN_T__2);
        break;
      case 2:
        enterOuterAlt(_localctx, 2);
        state = 39;
        match(TOKEN_T__0);
        state = 40;
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
      state = 43;
      key();
      state = 44;
      match(TOKEN_T__3);
      state = 45;
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

  KeyContext key() {
    dynamic _localctx = KeyContext(context, state);
    enterRule(_localctx, 6, RULE_key);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 47;
      _la = tokenStream.LA(1)!;
      if (!((((_la) & ~0x3f) == 0 && ((1 << _la) & 176128) != 0))) {
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

  ValueContext value() {
    dynamic _localctx = ValueContext(context, state);
    enterRule(_localctx, 8, RULE_value);
    try {
      state = 55;
      errorHandler.sync(this);
      switch (tokenStream.LA(1)!) {
      case TOKEN_STRING:
        enterOuterAlt(_localctx, 1);
        state = 49;
        string();
        break;
      case TOKEN_NUMBER:
      case TOKEN_NUMERIC_LITERAL:
      case TOKEN_SYMBOL:
        enterOuterAlt(_localctx, 2);
        state = 50;
        number();
        break;
      case TOKEN_T__0:
        enterOuterAlt(_localctx, 3);
        state = 51;
        object();
        break;
      case TOKEN_T__4:
        enterOuterAlt(_localctx, 4);
        state = 52;
        array();
        break;
      case TOKEN_T__6:
      case TOKEN_T__7:
        enterOuterAlt(_localctx, 5);
        state = 53;
        bool();
        break;
      case TOKEN_T__8:
        enterOuterAlt(_localctx, 6);
        state = 54;
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

  ArrayContext array() {
    dynamic _localctx = ArrayContext(context, state);
    enterRule(_localctx, 10, RULE_array);
    int _la;
    try {
      int _alt;
      state = 73;
      errorHandler.sync(this);
      switch (interpreter!.adaptivePredict(tokenStream, 7, context)) {
      case 1:
        enterOuterAlt(_localctx, 1);
        state = 57;
        match(TOKEN_T__4);
        state = 58;
        value();
        state = 63;
        errorHandler.sync(this);
        _alt = interpreter!.adaptivePredict(tokenStream, 5, context);
        while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
          if (_alt == 1) {
            state = 59;
            match(TOKEN_T__1);
            state = 60;
            value(); 
          }
          state = 65;
          errorHandler.sync(this);
          _alt = interpreter!.adaptivePredict(tokenStream, 5, context);
        }
        state = 67;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
        if (_la == TOKEN_T__1) {
          state = 66;
          match(TOKEN_T__1);
        }

        state = 69;
        match(TOKEN_T__5);
        break;
      case 2:
        enterOuterAlt(_localctx, 2);
        state = 71;
        match(TOKEN_T__4);
        state = 72;
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

  StringContext string() {
    dynamic _localctx = StringContext(context, state);
    enterRule(_localctx, 12, RULE_string);
    try {
      enterOuterAlt(_localctx, 1);
      state = 75;
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

  BoolContext bool() {
    dynamic _localctx = BoolContext(context, state);
    enterRule(_localctx, 14, RULE_bool);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 77;
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
      state = 79;
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

  NumberContext number() {
    dynamic _localctx = NumberContext(context, state);
    enterRule(_localctx, 18, RULE_number);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 82;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_SYMBOL) {
        state = 81;
        match(TOKEN_SYMBOL);
      }

      state = 84;
      _la = tokenStream.LA(1)!;
      if (!(_la == TOKEN_NUMBER || _la == TOKEN_NUMERIC_LITERAL)) {
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

  static const List<int> _serializedATN = [
      4,1,18,87,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,6,
      2,7,7,7,2,8,7,8,2,9,7,9,1,0,3,0,22,8,0,1,0,1,0,1,1,1,1,1,1,1,1,5,1,
      30,8,1,10,1,12,1,33,9,1,1,1,3,1,36,8,1,1,1,1,1,1,1,1,1,3,1,42,8,1,
      1,2,1,2,1,2,1,2,1,3,1,3,1,4,1,4,1,4,1,4,1,4,1,4,3,4,56,8,4,1,5,1,5,
      1,5,1,5,5,5,62,8,5,10,5,12,5,65,9,5,1,5,3,5,68,8,5,1,5,1,5,1,5,1,5,
      3,5,74,8,5,1,6,1,6,1,7,1,7,1,8,1,8,1,9,3,9,83,8,9,1,9,1,9,1,9,0,0,
      10,0,2,4,6,8,10,12,14,16,18,0,3,3,0,12,13,15,15,17,17,1,0,7,8,1,0,
      14,15,89,0,21,1,0,0,0,2,41,1,0,0,0,4,43,1,0,0,0,6,47,1,0,0,0,8,55,
      1,0,0,0,10,73,1,0,0,0,12,75,1,0,0,0,14,77,1,0,0,0,16,79,1,0,0,0,18,
      82,1,0,0,0,20,22,3,8,4,0,21,20,1,0,0,0,21,22,1,0,0,0,22,23,1,0,0,0,
      23,24,5,0,0,1,24,1,1,0,0,0,25,26,5,1,0,0,26,31,3,4,2,0,27,28,5,2,0,
      0,28,30,3,4,2,0,29,27,1,0,0,0,30,33,1,0,0,0,31,29,1,0,0,0,31,32,1,
      0,0,0,32,35,1,0,0,0,33,31,1,0,0,0,34,36,5,2,0,0,35,34,1,0,0,0,35,36,
      1,0,0,0,36,37,1,0,0,0,37,38,5,3,0,0,38,42,1,0,0,0,39,40,5,1,0,0,40,
      42,5,3,0,0,41,25,1,0,0,0,41,39,1,0,0,0,42,3,1,0,0,0,43,44,3,6,3,0,
      44,45,5,4,0,0,45,46,3,8,4,0,46,5,1,0,0,0,47,48,7,0,0,0,48,7,1,0,0,
      0,49,56,3,12,6,0,50,56,3,18,9,0,51,56,3,2,1,0,52,56,3,10,5,0,53,56,
      3,14,7,0,54,56,3,16,8,0,55,49,1,0,0,0,55,50,1,0,0,0,55,51,1,0,0,0,
      55,52,1,0,0,0,55,53,1,0,0,0,55,54,1,0,0,0,56,9,1,0,0,0,57,58,5,5,0,
      0,58,63,3,8,4,0,59,60,5,2,0,0,60,62,3,8,4,0,61,59,1,0,0,0,62,65,1,
      0,0,0,63,61,1,0,0,0,63,64,1,0,0,0,64,67,1,0,0,0,65,63,1,0,0,0,66,68,
      5,2,0,0,67,66,1,0,0,0,67,68,1,0,0,0,68,69,1,0,0,0,69,70,5,6,0,0,70,
      74,1,0,0,0,71,72,5,5,0,0,72,74,5,6,0,0,73,57,1,0,0,0,73,71,1,0,0,0,
      74,11,1,0,0,0,75,76,5,13,0,0,76,13,1,0,0,0,77,78,7,1,0,0,78,15,1,0,
      0,0,79,80,5,9,0,0,80,17,1,0,0,0,81,83,5,16,0,0,82,81,1,0,0,0,82,83,
      1,0,0,0,83,84,1,0,0,0,84,85,7,2,0,0,85,19,1,0,0,0,9,21,31,35,41,55,
      63,67,73,82
  ];

  static final ATN _ATN =
      ATNDeserializer().deserialize(_serializedATN);
}
class Json5Context extends ParserRuleContext {
  TerminalNode? EOF() => getToken(JSON5Parser.TOKEN_EOF, 0);
  ValueContext? value() => getRuleContext<ValueContext>(0);
  Json5Context([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_json5;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is JSON5Visitor<T>) {
     return visitor.visitJson5(this);
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
    if (visitor is JSON5Visitor<T>) {
     return visitor.visitObject(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class PairContext extends ParserRuleContext {
  KeyContext? key() => getRuleContext<KeyContext>(0);
  ValueContext? value() => getRuleContext<ValueContext>(0);
  PairContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_pair;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is JSON5Visitor<T>) {
     return visitor.visitPair(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class KeyContext extends ParserRuleContext {
  TerminalNode? STRING() => getToken(JSON5Parser.TOKEN_STRING, 0);
  TerminalNode? IDENTIFIER() => getToken(JSON5Parser.TOKEN_IDENTIFIER, 0);
  TerminalNode? LITERAL() => getToken(JSON5Parser.TOKEN_LITERAL, 0);
  TerminalNode? NUMERIC_LITERAL() => getToken(JSON5Parser.TOKEN_NUMERIC_LITERAL, 0);
  KeyContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_key;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is JSON5Visitor<T>) {
     return visitor.visitKey(this);
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
    if (visitor is JSON5Visitor<T>) {
     return visitor.visitValue(this);
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
    if (visitor is JSON5Visitor<T>) {
     return visitor.visitArray(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class StringContext extends ParserRuleContext {
  TerminalNode? STRING() => getToken(JSON5Parser.TOKEN_STRING, 0);
  StringContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_string;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is JSON5Visitor<T>) {
     return visitor.visitString(this);
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
    if (visitor is JSON5Visitor<T>) {
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
    if (visitor is JSON5Visitor<T>) {
     return visitor.visitNull(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class NumberContext extends ParserRuleContext {
  TerminalNode? NUMERIC_LITERAL() => getToken(JSON5Parser.TOKEN_NUMERIC_LITERAL, 0);
  TerminalNode? NUMBER() => getToken(JSON5Parser.TOKEN_NUMBER, 0);
  TerminalNode? SYMBOL() => getToken(JSON5Parser.TOKEN_SYMBOL, 0);
  NumberContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_number;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is JSON5Visitor<T>) {
     return visitor.visitNumber(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

