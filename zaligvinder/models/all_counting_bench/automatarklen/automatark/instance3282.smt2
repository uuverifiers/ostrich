(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\+){1}91){1}[1-9]{1}[0-9]{9}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.++ ((_ re.loop 1 1) (str.to_re "+")) (str.to_re "91"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (([\n,  ])*((<+)([^<>]+)(>*))+([\n,  ])*)+
(assert (not (str.in_re X (re.++ (re.+ (re.++ (re.* (re.union (str.to_re "\u{0a}") (str.to_re ",") (str.to_re " "))) (re.+ (re.++ (re.+ (str.to_re "<")) (re.+ (re.union (str.to_re "<") (str.to_re ">"))) (re.* (str.to_re ">")))) (re.* (re.union (str.to_re "\u{0a}") (str.to_re ",") (str.to_re " "))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
