(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d|,)*\.?\d*$
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (str.to_re ","))) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; urn:[a-z0-9]{1}[a-z0-9\-]{1,31}:[a-z0-9_,:=@;!'%/#\(\)\+\-\.\$\*\?]+
(assert (not (str.in_re X (re.++ (str.to_re "urn:") ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 1 31) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (str.to_re ":") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re ",") (str.to_re ":") (str.to_re "=") (str.to_re "@") (str.to_re ";") (str.to_re "!") (str.to_re "'") (str.to_re "%") (str.to_re "/") (str.to_re "#") (str.to_re "(") (str.to_re ")") (str.to_re "+") (str.to_re "-") (str.to_re ".") (str.to_re "$") (str.to_re "*") (str.to_re "?"))) (str.to_re "\u{0a}")))))
; ^[a-z0-9_.-]*@[a-z0-9-]+(.[a-z]{2,4})+$
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re ".") (str.to_re "-"))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.+ (re.++ re.allchar ((_ re.loop 2 4) (re.range "a" "z")))) (str.to_re "\u{0a}")))))
; ^[a-zA-Z0-9]{1,20}$
(assert (str.in_re X (re.++ ((_ re.loop 1 20) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
