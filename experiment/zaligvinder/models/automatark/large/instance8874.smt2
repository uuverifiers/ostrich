(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/html\/license_[0-9A-F]{550,}\.html$/Ui
(assert (str.in_re X (re.++ (str.to_re "//html/license_.html/Ui\u{0a}") ((_ re.loop 550 550) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "A" "F"))))))
; (private|public|protected)\s\w(.)*\((.)*\)[^;]
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* re.allchar) (str.to_re "(") (re.* re.allchar) (str.to_re ")") (re.comp (str.to_re ";")) (str.to_re "\u{0a}p") (re.union (str.to_re "rivate") (str.to_re "ublic") (str.to_re "rotected")))))
(check-sat)
