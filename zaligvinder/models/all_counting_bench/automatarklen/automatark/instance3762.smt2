(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}asx([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.asx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /^\/images2\/[0-9a-fA-F]{500,}/U
(assert (not (str.in_re X (re.++ (str.to_re "//images2//U\u{0a}") ((_ re.loop 500 500) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F")))))))
; ([0-9]|[0-9][0-9])\.\s
(assert (not (str.in_re X (re.++ (str.to_re ".") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}") (re.range "0" "9") (re.range "0" "9")))))
; LogsHXLogOnlytoolbar\x2Ei-lookup\x2Ecom
(assert (str.in_re X (str.to_re "LogsHXLogOnlytoolbar.i-lookup.com\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
