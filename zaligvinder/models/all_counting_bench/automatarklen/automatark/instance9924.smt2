(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; InformationSubject\x3ASpynovabyBlacksnprtz\x7CdialnoSearch
(assert (str.in_re X (str.to_re "InformationSubject:SpynovabyBlacksnprtz|dialnoSearch\u{0a}")))
; ^/{1}(((/{1}\.{1})?[a-zA-Z0-9 ]+/?)+(\.{1}[a-zA-Z0-9]{2,4})?)$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "/")) (str.to_re "\u{0a}") (re.+ (re.++ (re.opt (re.++ ((_ re.loop 1 1) (str.to_re "/")) ((_ re.loop 1 1) (str.to_re ".")))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " "))) (re.opt (str.to_re "/")))) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))))))
; /^\/[0-9]{5}\.jar$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re ".jar/U\u{0a}"))))
; (\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2})|(\d{3}\.\d{3}\.\d{3}\-\d{2})
(assert (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
