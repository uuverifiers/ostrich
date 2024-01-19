(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}ogx([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.ogx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ("[^"]*")|('[^\r]*)(\r\n)?
(assert (not (str.in_re X (re.union (re.++ (str.to_re "\u{22}") (re.* (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}")) (re.++ (re.opt (str.to_re "\u{0d}\u{0a}")) (str.to_re "\u{0a}'") (re.* (re.comp (str.to_re "\u{0d}"))))))))
; &#\d{2,5};
(assert (str.in_re X (re.++ (str.to_re "&#") ((_ re.loop 2 5) (re.range "0" "9")) (str.to_re ";\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
