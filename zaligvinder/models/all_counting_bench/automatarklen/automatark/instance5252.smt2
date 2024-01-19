(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z]{2}|[A-Z]\d|\d[A-Z])[1-9](\d{1,3})?$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 2 2) (re.range "A" "Z")) (re.++ (re.range "A" "Z") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "A" "Z"))) (re.range "1" "9") (re.opt ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}wrf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wrf/i\u{0a}")))))
; ^(\d)?(\d|,)*\.?\d{1,2}$
(assert (not (str.in_re X (re.++ (re.opt (re.range "0" "9")) (re.* (re.union (re.range "0" "9") (str.to_re ","))) (re.opt (str.to_re ".")) ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; [a-zA-Z]*( [a-zA-Z]*)?
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.++ (str.to_re " ") (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}")))))
; ^[^ ,0]*$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re ",") (str.to_re "0"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
