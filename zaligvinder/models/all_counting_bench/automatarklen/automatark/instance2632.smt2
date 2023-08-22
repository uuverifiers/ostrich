(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d{2,4}
(assert (str.in_re X (re.++ ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; User-Agent\u{3a}User-Agent\x3A
(assert (not (str.in_re X (str.to_re "User-Agent:User-Agent:\u{0a}"))))
; ^([1-9]\d{0,3}|[1-5]\d{4}|6[0-4]\d{3}|65[0-4]\d{2}|655[0-2]\d|6553[0-5])$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9"))) (re.++ (re.range "1" "5") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "6") (re.range "0" "4") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "65") (re.range "0" "4") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "655") (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "6553") (re.range "0" "5"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
