(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((^([\d]{1,3})(,{1}([\d]{3}))*)|(^[\d]*))((\.{1}[\d]{2})?$)
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ ((_ re.loop 1 1) (str.to_re ",")) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.* (re.range "0" "9"))) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^((0?[1-9])|((1|2)[0-9])|30|31)$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (str.to_re "30") (str.to_re "31")) (str.to_re "\u{0a}"))))
; (AUX|PRN|NUL|COM\d|LPT\d)+\s*$
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "AUX") (str.to_re "PRN") (str.to_re "NUL") (re.++ (str.to_re "COM") (re.range "0" "9")) (re.++ (str.to_re "LPT") (re.range "0" "9")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
