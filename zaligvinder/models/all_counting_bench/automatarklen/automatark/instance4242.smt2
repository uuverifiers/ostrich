(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 5) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; BysooTBUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "BysooTBUser-Agent:\u{0a}"))))
; [^A-Za-z0-9_@\.]|@{2,}|\.{5,}
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (str.to_re "@")) (re.* (str.to_re "@"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (str.to_re ".")) (re.* (str.to_re "."))) (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re "@") (str.to_re ".")))))
(assert (> (str.len X) 10))
(check-sat)
