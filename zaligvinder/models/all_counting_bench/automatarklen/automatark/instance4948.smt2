(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\{([1-9]{1}|[1-9]{1}[0-9]{1,}){1}\}\{([1-9]{1}|[1-9]{1}[0-9]{1,}){1}\}(.*)$
(assert (not (str.in_re X (re.++ (str.to_re "{") ((_ re.loop 1 1) (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.+ (re.range "0" "9"))))) (str.to_re "}{") ((_ re.loop 1 1) (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.+ (re.range "0" "9"))))) (str.to_re "}") (re.* re.allchar) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
