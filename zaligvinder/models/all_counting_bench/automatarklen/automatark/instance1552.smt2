(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^N[1-9][0-9]{0,4}$|^N[1-9][0-9]{0,3}[A-Z]$|^N[1-9][0-9]{0,2}[A-Z]{2}$
(assert (str.in_re X (re.++ (str.to_re "N") (re.range "1" "9") (re.union ((_ re.loop 0 4) (re.range "0" "9")) (re.++ ((_ re.loop 0 3) (re.range "0" "9")) (re.range "A" "Z")) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}"))))))
; /^(\d+\*)+(\d)+$/gm
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.++ (re.+ (re.range "0" "9")) (str.to_re "*"))) (re.+ (re.range "0" "9")) (str.to_re "/gm\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
