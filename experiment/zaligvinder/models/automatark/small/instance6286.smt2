(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[^iIoOqQ'-]{10,17}$
(assert (str.in_re X (re.++ ((_ re.loop 10 17) (re.union (str.to_re "i") (str.to_re "I") (str.to_re "o") (str.to_re "O") (str.to_re "q") (str.to_re "Q") (str.to_re "'") (str.to_re "-"))) (str.to_re "\u{0a}"))))
; SpyBuddy\sPARSER.*Host\x3Aaction\x2Eforhttp\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (str.in_re X (re.++ (str.to_re "SpyBuddy") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "PARSER") (re.* re.allchar) (str.to_re "Host:action.forhttp://www.searchinweb.com/search.php?said=bar\u{0a}"))))
(check-sat)
