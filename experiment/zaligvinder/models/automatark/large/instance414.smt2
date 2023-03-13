(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/b\/(letr|req|opt|eve)\/[0-9a-fA-F]{24}$/U
(assert (str.in_re X (re.++ (str.to_re "//b/") (re.union (str.to_re "letr") (str.to_re "req") (str.to_re "opt") (str.to_re "eve")) (str.to_re "/") ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "/U\u{0a}"))))
; ^([A-Z]{1,2}[0-9]{1,2}|[A-Z]{3}|[A-Z]{1,2}[0-9][A-Z])( |-)[0-9][A-Z]{2}
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) ((_ re.loop 1 2) (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) (re.range "0" "9") (re.range "A" "Z"))) (re.union (str.to_re " ") (str.to_re "-")) (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}")))))
; /encoding\x3D[\u{22}\u{27}][^\u{22}\u{27}]{1024}/
(assert (str.in_re X (re.++ (str.to_re "/encoding=") (re.union (str.to_re "\u{22}") (str.to_re "'")) ((_ re.loop 1024 1024) (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/\u{0a}"))))
(check-sat)
