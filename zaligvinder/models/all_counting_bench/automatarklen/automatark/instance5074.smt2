(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(1[89]|[2-9]\d)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.union (str.to_re "8") (str.to_re "9"))) (re.++ (re.range "2" "9") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /\/[a-f0-9]{32}\/[a-f0-9]{32}\u{22}/R
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "\u{22}/R\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
