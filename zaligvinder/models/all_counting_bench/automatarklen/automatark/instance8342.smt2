(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b[^aeiou]+[aeiou][^aeiou]+\b
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "a") (str.to_re "e") (str.to_re "i") (str.to_re "o") (str.to_re "u"))) (re.union (str.to_re "a") (str.to_re "e") (str.to_re "i") (str.to_re "o") (str.to_re "u")) (re.+ (re.union (str.to_re "a") (str.to_re "e") (str.to_re "i") (str.to_re "o") (str.to_re "u"))) (str.to_re "\u{0a}"))))
; (1 )?\d{3} \d{3}-\d{4}
(assert (str.in_re X (re.++ (re.opt (str.to_re "1 ")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
