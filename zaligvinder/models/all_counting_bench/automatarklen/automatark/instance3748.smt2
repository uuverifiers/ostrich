(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}skm([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.skm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; \x2Ftoolbar\x2Fsupremetb\s+wjpropqmlpohj\u{2f}lo\s+resultsmaster\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "/toolbar/supremetb") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "wjpropqmlpohj/lo") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "resultsmaster.com\u{13}\u{0a}")))))
; ookflolfctm\u{2f}nmot\.fmu
(assert (str.in_re X (str.to_re "ookflolfctm/nmot.fmu\u{0a}")))
; ^\.{0,2}[\/\\]
(assert (str.in_re X (re.++ ((_ re.loop 0 2) (str.to_re ".")) (re.union (str.to_re "/") (str.to_re "\u{5c}")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
