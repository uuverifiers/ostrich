(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^( )*(\+?( )?\(?( )?(\d{1,3})?)\)?(.|-|_ )?\(?(\d{3})\)?(.|-|_ )?\(?(\d{3})\)?(.|-|_ )?\(?(\d{4})\)?( )*$
(assert (str.in_re X (re.++ (re.* (str.to_re " ")) (re.opt (str.to_re ")")) (re.opt (re.union re.allchar (str.to_re "-") (str.to_re "_ "))) (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union re.allchar (str.to_re "-") (str.to_re "_ "))) (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union re.allchar (str.to_re "-") (str.to_re "_ "))) (re.opt (str.to_re "(")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.* (str.to_re " ")) (str.to_re "\u{0a}") (re.opt (str.to_re "+")) (re.opt (str.to_re " ")) (re.opt (str.to_re "(")) (re.opt (str.to_re " ")) (re.opt ((_ re.loop 1 3) (re.range "0" "9"))))))
(check-sat)
