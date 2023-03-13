(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((0[1-9])|(1[0-2]))\/*((2011)|(20[1-9][1-9]))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.* (str.to_re "/")) (re.union (str.to_re "2011") (re.++ (str.to_re "20") (re.range "1" "9") (re.range "1" "9"))) (str.to_re "\u{0a}")))))
; ^\{([1-9]{1}|[1-9]{1}[0-9]{1,}){1}\}\{([1-9]{1}|[1-9]{1}[0-9]{1,}){1}\}(.*)$
(assert (str.in_re X (re.++ (str.to_re "{") ((_ re.loop 1 1) (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.+ (re.range "0" "9"))))) (str.to_re "}{") ((_ re.loop 1 1) (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.+ (re.range "0" "9"))))) (str.to_re "}") (re.* re.allchar) (str.to_re "\u{0a}"))))
(check-sat)
