(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((http\://|https\://|ftp\://)|(www.))+(([a-zA-Z0-9\.-]+\.[a-zA-Z]{2,4})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(/[a-zA-Z0-9%:/-_\?\.'~]*)?
(assert (str.in_re X (re.++ (re.+ (re.union (re.++ (str.to_re "www") re.allchar) (str.to_re "http://") (str.to_re "https://") (str.to_re "ftp://"))) (re.union (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re "/") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "%") (str.to_re ":") (re.range "/" "_") (str.to_re "?") (str.to_re ".") (str.to_re "'") (str.to_re "~"))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
