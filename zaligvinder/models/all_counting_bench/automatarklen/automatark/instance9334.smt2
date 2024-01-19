(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-z]+([a-z0-9-]*[a-z0-9]+)?(\.([a-z]+([a-z0-9-]*[a-z0-9]+)?)+)*$
(assert (not (str.in_re X (re.++ (re.+ (re.range "a" "z")) (re.opt (re.++ (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))) (re.* (re.++ (str.to_re ".") (re.+ (re.++ (re.+ (re.range "a" "z")) (re.opt (re.++ (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))))))) (str.to_re "\u{0a}")))))
; /^(www\.|http:\/\/|https:\/\/|http:\/\/www\.|https:\/\/www\.)[a-z0-9]+\.[a-z]{2,4}$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "www.") (str.to_re "http://") (str.to_re "https://") (str.to_re "http://www.") (str.to_re "https://www.")) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 4) (re.range "a" "z")) (str.to_re "/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
