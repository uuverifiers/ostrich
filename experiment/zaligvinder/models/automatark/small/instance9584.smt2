(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\w+Host\x3AUser-Agent\x3ATPSystemad\x2Esearchsquire\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:User-Agent:TPSystemad.searchsquire.com\u{0a}")))))
; ^(F-)?((2[A|B])|[0-9]{2})[0-9]{3}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "F-")) (re.union (re.++ (str.to_re "2") (re.union (str.to_re "A") (str.to_re "|") (str.to_re "B"))) ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
