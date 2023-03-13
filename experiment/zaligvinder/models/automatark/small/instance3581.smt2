(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([+]31|0031)\s\(0\)([0-9]{9})|([+]31|0031)\s0([0-9]{9})|0([0-9]{9}))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "+31") (str.to_re "0031")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "(0)") ((_ re.loop 9 9) (re.range "0" "9"))) (re.++ (re.union (str.to_re "+31") (str.to_re "0031")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "0") ((_ re.loop 9 9) (re.range "0" "9"))) (re.++ (str.to_re "0") ((_ re.loop 9 9) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; HWPE[^\n\r]*Basic.*LOGsearches\x2Eworldtostart\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "HWPE") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Basic") (re.* re.allchar) (str.to_re "LOGsearches.worldtostart.com\u{0a}")))))
; /^\u{2f}\d{3}\u{2f}\d{3}\u{2e}html$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".html/U\u{0a}"))))
(check-sat)
