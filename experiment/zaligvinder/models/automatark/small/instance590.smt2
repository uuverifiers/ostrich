(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0-9]{1})|([0-9]{1}[0-9]{1})|([1-3]{1}[0-6]{1}[0-5]{1}))d(([0-9]{1})|(1[0-9]{1})|([1-2]{1}[0-3]{1}))h(([0-9]{1})|([1-5]{1}[0-9]{1}))m$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "3")) ((_ re.loop 1 1) (re.range "0" "6")) ((_ re.loop 1 1) (re.range "0" "5")))) (str.to_re "d") (re.union ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re "1") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "2")) ((_ re.loop 1 1) (re.range "0" "3")))) (str.to_re "h") (re.union ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "5")) ((_ re.loop 1 1) (re.range "0" "9")))) (str.to_re "m\u{0a}")))))
; (^(\d+)$)|(^(\d{1,3}[ ,\.](\d{3}[ ,\.])*\d{3}|\d{1,3})$)
(assert (str.in_re X (re.union (re.+ (re.range "0" "9")) (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re ",") (str.to_re ".")) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re ",") (str.to_re ".")))) ((_ re.loop 3 3) (re.range "0" "9"))) ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
