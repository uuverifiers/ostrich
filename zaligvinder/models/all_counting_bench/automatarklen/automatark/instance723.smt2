(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\u{3a}\s+sErver\s+-~-GREATHost\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "sErver") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "-~-GREATHost:\u{0a}")))))
; http[s]?://(www.facebook|[a-zA-Z]{2}-[a-zA-Z]{2}.facebook|facebook)\.com/(pages/[a-zA-Z0-9\.-]+/[0-9]+|[a-zA-Z0-9\.-]+)[/]?$
(assert (str.in_re X (re.++ (str.to_re "http") (re.opt (str.to_re "s")) (str.to_re "://") (re.union (re.++ (str.to_re "www") re.allchar (str.to_re "facebook")) (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "-") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) re.allchar (str.to_re "facebook")) (str.to_re "facebook")) (str.to_re ".com/") (re.union (re.++ (str.to_re "pages/") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "-"))) (str.to_re "/") (re.+ (re.range "0" "9"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "-")))) (re.opt (str.to_re "/")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
