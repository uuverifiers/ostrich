(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}lzh([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.lzh") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /\/index\d{9}\.asp/i
(assert (str.in_re X (re.++ (str.to_re "//index") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re ".asp/i\u{0a}"))))
(check-sat)
