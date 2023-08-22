(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-Z0_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "0") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re "@") (re.union (re.++ (str.to_re "[") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".")) (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re ".")))) (re.union ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 3) (re.range "0" "9"))) (re.opt (str.to_re "]")) (str.to_re "\u{0a}")))))
; [0][^0]|([^0]{1}(.){1})|[^0]*
(assert (not (str.in_re X (re.union (re.++ (str.to_re "0") (re.comp (str.to_re "0"))) (re.++ ((_ re.loop 1 1) (re.comp (str.to_re "0"))) ((_ re.loop 1 1) re.allchar)) (re.++ (re.* (re.comp (str.to_re "0"))) (str.to_re "\u{0a}"))))))
; ^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")) (re.* (re.++ (re.* (re.union (str.to_re "-") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")))) (str.to_re "@") (re.+ (re.++ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")) (str.to_re "."))) ((_ re.loop 2 9) (re.union (re.range "a" "z") (re.range "A" "Z"))))))
; /\u{26}tv\u{3d}\d\.\d\.\d{4}\.\d{4}/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/&tv=") (re.range "0" "9") (str.to_re ".") (re.range "0" "9") (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
